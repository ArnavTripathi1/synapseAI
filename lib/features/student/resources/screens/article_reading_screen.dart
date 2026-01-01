import 'dart:convert';
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ArticleDetailScreen extends StatefulWidget {
  final String title;
  final String category;
  final String readTime;
  final String imageUrl;
  final String content;
  final String counselorId; // This is the UserProfile ID of the Counselor

  const ArticleDetailScreen({
    super.key,
    required this.title,
    required this.category,
    required this.readTime,
    required this.imageUrl,
    required this.content,
    required this.counselorId,
  });

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  // --- UI STATE ---
  bool isBookmarked = false;
  bool isPlaying = false;

  // --- AUTHOR DATA ---
  String _authorName = "Loading...";
  String _authorSpecialization = "";
  String? _authorImageUrl;
  bool _isLoadingAuthor = true;

  // --- TTS STATE ---
  final FlutterTts flutterTts = FlutterTts();
  int _lastCharacterIndex = 0;
  String _cleanContentForTts = "";

  @override
  void initState() {
    super.initState();
    // 1. Prepare text for speech immediately (strip markdown symbols)
    _cleanContentForTts = _cleanMarkdownForTTS(widget.content);

    // 2. Initialize TTS engine
    _initTts();

    // 3. Fetch the real author details using the User ID
    _fetchCounselorDetails();
  }

  // ---------------------------------------------------------------------------
  // 1. FETCH AUTHOR LOGIC (FIXED)
  // ---------------------------------------------------------------------------
  Future<void> _fetchCounselorDetails() async {
    // We use listCounselorProfiles with a filter because we are searching by userProfileID, not the primary key.
    const counselorQuery = '''
      query GetCounselorByUser(\$uid: ID!) {
        listCounselorProfiles(filter: { userProfileID: { eq: \$uid } }) {
          items {
            specialization
            user {
              name
              imageUrl
            }
          }
        }
      }
    ''';

    try {
      final request = GraphQLRequest<String>(
        document: counselorQuery,
        variables: {'uid': widget.counselorId},
        authorizationMode: APIAuthorizationType.userPools,
      );

      final response = await Amplify.API.query(request: request).response;

      if (mounted) {
        setState(() {
          _isLoadingAuthor = false; // Stop loading regardless of result

          if (response.data != null) {
            final data = jsonDecode(response.data!);
            final items = data['listCounselorProfiles']['items'] as List;

            if (items.isNotEmpty) {
              final counselor = items[0];
              _authorName = counselor['user']['name'] ?? "Unknown Counselor";
              _authorImageUrl = counselor['user']['imageUrl'];
              _authorSpecialization = counselor['specialization'] ?? "Wellness Expert";
            } else {
              _authorName = "Verified Counselor"; // Fallback if record missing
            }
          }
        });
      }
    } catch (e) {
      debugPrint("Error fetching author: $e");
      if (mounted) {
        setState(() {
          _authorName = "Counselor";
          _isLoadingAuthor = false;
        });
      }
    }
  }

  // ---------------------------------------------------------------------------
  // 2. MARKDOWN CLEANER FOR TTS
  // ---------------------------------------------------------------------------
  String _cleanMarkdownForTTS(String markdown) {
    // Replace headers (# Header) with just text
    String cleaned = markdown.replaceAll(RegExp(r'(^|\n)\s*#+\s*'), ' ');

    // Remove bold/italic markers (**text** or *text*)
    cleaned = cleaned.replaceAll(RegExp(r'\*\*|__|\*|_'), '');

    // Remove links [text](url) -> keep only 'text'
    cleaned = cleaned.replaceAllMapped(RegExp(r'\[([^\]]+)\]\([^)]+\)'), (match) {
      return match.group(1) ?? "";
    });

    // Remove images ![alt](url) -> remove entirely
    cleaned = cleaned.replaceAll(RegExp(r'!\[[^\]]*\]\([^)]+\)'), '');

    // Remove blockquotes (>)
    cleaned = cleaned.replaceAll(RegExp(r'(^|\n)\s*>\s*'), ' ');

    // Remove list bullets (- or *)
    cleaned = cleaned.replaceAll(RegExp(r'(^|\n)\s*[-*]\s+'), ' ');

    return cleaned.trim();
  }

  // ---------------------------------------------------------------------------
  // 3. TTS SETUP
  // ---------------------------------------------------------------------------
  void _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    if (Platform.isAndroid) await flutterTts.setQueueMode(1);

    // Track progress based on cleaned text
    flutterTts.setProgressHandler((String text, int start, int end, String word) {
      setState(() => _lastCharacterIndex = start);
    });

    flutterTts.setStartHandler(() => setState(() => isPlaying = true));

    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
        _lastCharacterIndex = 0;
      });
    });

    flutterTts.setErrorHandler((msg) => setState(() => isPlaying = false));
  }

  Future<void> _togglePlay() async {
    if (isPlaying) {
      await flutterTts.stop();
      setState(() => isPlaying = false);
    } else {
      // ✅ Speak the CLEANED text
      String textToSpeak = _cleanContentForTts;

      // Resume logic (approximate)
      if (_lastCharacterIndex > 0 && _lastCharacterIndex < textToSpeak.length) {
        textToSpeak = textToSpeak.substring(_lastCharacterIndex);
      }

      var result = await flutterTts.speak(textToSpeak);
      if (result == 1) setState(() => isPlaying = true);
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // 4. UI BUILD
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. Header Image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const CircleAvatar(backgroundColor: Colors.white70, child: Icon(Icons.arrow_back, color: Colors.black)),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: CircleAvatar(
                    backgroundColor: Colors.white70,
                    child: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border, color: isBookmarked ? Colors.teal : Colors.black)
                ),
                onPressed: () => setState(() => isBookmarked = !isBookmarked),
              ),
              const SizedBox(width: 16),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeaderImage(),
            ),
          ),

          // 2. Content Body
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              transform: Matrix4.translationValues(0, -20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meta Tags
                  Row(
                    children: [
                      _buildCategoryChip(),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(widget.readTime, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(widget.title, style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.bold, height: 1.2)),
                  const SizedBox(height: 20),

                  // Author & Play Button
                  Row(
                    children: [
                      // Author Avatar
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _authorImageUrl != null
                            ? NetworkImage(_authorImageUrl!)
                            : null,
                        child: _authorImageUrl == null
                            ? const Icon(Icons.person, color: Colors.grey)
                            : null,
                      ),
                      const SizedBox(width: 12),

                      // Author Text (Dynamic)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _isLoadingAuthor
                                ? Container(width: 100, height: 14, color: Colors.grey[100])
                                : Text(
                                _authorName,
                                style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1E293B)),
                                maxLines: 1, overflow: TextOverflow.ellipsis
                            ),
                            const SizedBox(height: 2),
                            Text(
                                _authorSpecialization,
                                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[500])
                            ),
                          ],
                        ),
                      ),

                      // Play Button
                      FloatingActionButton.small(
                        onPressed: _togglePlay,
                        elevation: 0,
                        backgroundColor: isPlaying ? const Color(0xFFA1C4FD) : const Color(0xFFF1F5F9),
                        child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),

                  // Content (Markdown)
                  MarkdownBody(
                    data: widget.content,
                    selectable: true,
                    styleSheet: MarkdownStyleSheet(
                      p: GoogleFonts.plusJakartaSans(fontSize: 16, height: 1.6, color: const Color(0xFF334155)),
                      h1: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.bold),
                      h2: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.bold),
                      h3: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w600),
                      listBullet: const TextStyle(color: Color(0xFF3b5998), fontSize: 16),
                      blockquote: GoogleFonts.plusJakartaSans(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey[700]),
                      blockquoteDecoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: const Border(left: BorderSide(color: Color(0xFF3b5998), width: 4)),
                      ),
                    ),
                  ).animate().fadeIn(delay: 300.ms),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    if (widget.imageUrl.startsWith("http")) {
      return Image.network(widget.imageUrl, fit: BoxFit.cover);
    } else {
      return Container(color: Colors.grey[300]);
    }
  }

  Widget _buildCategoryChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFA1C4FD).withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
          widget.category.toUpperCase(),
          style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF1E293B))
      ),
    );
  }
}
