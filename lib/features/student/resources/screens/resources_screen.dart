import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart'; // Required for APIAuthorizationType
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

// --- IMPORTS FOR NAVIGATION ---
import 'article_reading_screen.dart';
import 'video_player_screen.dart';

// --- 1. UPDATED DATA MODEL ---
class ResourceItem {
  final String id;
  final String title;
  final String type; // 'VIDEO' or 'ARTICLE'
  final String category;
  final String duration;
  final String s3Key; // The path in S3
  final String description;
  final String? headerImageKey;
  final String counselorId; // ✅ ADDED THIS FIELD

  ResourceItem({
    required this.id,
    required this.title,
    required this.type,
    required this.category,
    required this.duration,
    required this.s3Key,
    required this.description,
    this.headerImageKey,
    required this.counselorId, // ✅ REQUIRED
  });

  factory ResourceItem.fromJson(Map<String, dynamic> json) {
    return ResourceItem(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      category: json['category'],
      duration: json['duration'] ?? "N/A",
      s3Key: json['url'],
      description: json['description'] ?? "",
      headerImageKey: json['headerImage'],
      counselorId: json['counselorID'] ?? "", // ✅ MAP FROM JSON
    );
  }
}

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  // --- STATE VARIABLES ---
  int _selectedIndex = 0;
  final List<String> _categories = ["All", "Anxiety", "Sleep", "Depression", "Focus"];

  bool _isLoadingResources = true;
  bool _isLoadingRecommendations = true;
  bool _isNavigating = false;

  List<ResourceItem> _allResources = [];
  List<ResourceItem> _recommendedItems = [];

  // --- GRAPHQL QUERIES ---

  // 2. UPDATED QUERY TO FETCH COUNSELOR ID
  final String listResourcesQuery = '''
    query ListResources {
      listResources {
        items {
          id
          title
          type
          category
          duration
          description
          url
          headerImage
          counselorID 
        }
      }
    }
  ''';

  // Fetch Chat Sessions
  final String listSessionsQuery = '''
    query ListSessions {
      listAIChatSessions {
        items {
          id
          updatedAt
        }
      }
    }
  ''';

  // Fetch Messages
  final String listMessagesQuery = '''
    query ListMessages(\$sessionId: ID!) {
      listAIChatMessages(filter: { sessionID: { eq: \$sessionId } }) {
        items {
          content
          isUser
          createdAt
        }
      }
    }
  ''';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _fetchResources();

    if (!mounted) return;

    String context = await _generateContextFromChatHistory();
    debugPrint("🤖 AI Context: $context");

    await _fetchAIRecommendations(context);
  }

  // --- FETCH RESOURCES ---
  Future<void> _fetchResources() async {
    try {
      final request = GraphQLRequest<String>(document: listResourcesQuery);
      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        final Map<String, dynamic> data = jsonDecode(response.data!);
        final List<dynamic> items = data['listResources']['items'];

        final List<ResourceItem> loaded = items
            .where((i) => i != null)
            .map((i) => ResourceItem.fromJson(i))
            .toList();

        if (mounted) {
          setState(() {
            _allResources = loaded;
            _isLoadingResources = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching resources: $e");
      if (mounted) setState(() => _isLoadingResources = false);
    }
  }

  // --- GENERATE CONTEXT ---
  Future<String> _generateContextFromChatHistory() async {
    try {
      final sessionReq = GraphQLRequest<String>(
          document: listSessionsQuery,
          authorizationMode: APIAuthorizationType.userPools
      );
      final sessionRes = await Amplify.API.query(request: sessionReq).response;

      if (sessionRes.data == null) return "I want to improve my mental health.";

      final sessionData = jsonDecode(sessionRes.data!);
      final List<dynamic> sessions = sessionData['listAIChatSessions']['items'];

      if (sessions.isEmpty) return "I want to improve my mental health.";

      sessions.sort((a, b) {
        DateTime dateA = DateTime.parse(a['updatedAt']);
        DateTime dateB = DateTime.parse(b['updatedAt']);
        return dateB.compareTo(dateA);
      });

      final latestSessionId = sessions[0]['id'];

      final msgReq = GraphQLRequest<String>(
          document: listMessagesQuery,
          variables: {'sessionId': latestSessionId},
          authorizationMode: APIAuthorizationType.userPools
      );
      final msgRes = await Amplify.API.query(request: msgReq).response;

      if (msgRes.data == null) return "I want to improve my mental health.";

      final msgData = jsonDecode(msgRes.data!);
      final List<dynamic> messages = msgData['listAIChatMessages']['items'];

      final userMessages = messages
          .where((m) => m['isUser'] == true)
          .map((m) => m)
          .toList();

      userMessages.sort((a, b) => DateTime.parse(a['createdAt']).compareTo(DateTime.parse(b['createdAt'])));

      final recentMessages = userMessages.length > 5
          ? userMessages.sublist(userMessages.length - 5)
          : userMessages;

      String aggregatedText = recentMessages.map((m) => m['content']).join(". ");

      if (aggregatedText.trim().isEmpty) return "I want to improve my mental health.";

      return aggregatedText;

    } catch (e) {
      return "I want to improve my mental health.";
    }
  }

  // --- AI RECOMMENDATION ---
  Future<void> _fetchAIRecommendations(String userQuery) async {
    const String apiUrl = "https://recommandation-backend-2.onrender.com/query";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"question": userQuery}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List<dynamic> identifiedCauses = [];
        if (data['answer'] is Map && data['answer']['cause'] is List) {
          identifiedCauses = data['answer']['cause'];
        }

        final List<ResourceItem> matches = [];

        for (var resource in _allResources) {
          for (var cause in identifiedCauses) {
            String rCat = resource.category.toLowerCase();
            String cStr = cause.toString().toLowerCase();
            if (rCat.contains(cStr) || cStr.contains(rCat)) {
              if (!matches.contains(resource)) matches.add(resource);
            }
          }
        }

        if (mounted) {
          setState(() {
            _recommendedItems = matches;
            _isLoadingRecommendations = false;
          });
        }
      } else {
        throw Exception("Server status: ${response.statusCode}");
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _recommendedItems = _allResources.take(3).toList();
          _isLoadingRecommendations = false;
        });
      }
    }
  }

  Future<String> _getS3Url(String key) async {
    try {
      final result = await Amplify.Storage.getUrl(
        path: StoragePath.fromString(key),
        options: const StorageGetUrlOptions(
          pluginOptions: S3GetUrlPluginOptions(expiresIn: Duration(hours: 1)),
        ),
      ).result;
      return result.url.toString();
    } catch (e) {
      return "";
    }
  }

  // --- 3. UPDATED NAVIGATION HANDLER ---
  Future<void> _handleResourceTap(ResourceItem item) async {
    if (_isNavigating) return;
    setState(() => _isNavigating = true);

    try {
      final contentUrl = await _getS3Url(item.s3Key);

      if (item.type == 'VIDEO') {
        if (mounted) {
          Navigator.push(context, MaterialPageRoute(
              builder: (_) => VideoPlayerScreen(
                  videoUrl: contentUrl,
                  title: item.title,
                  description: item.description
              )
          ));
        }
      } else {
        // ARTICLE
        final response = await http.get(Uri.parse(contentUrl));
        final markdownContent = response.body;

        String headerImageUrl = "https://img.freepik.com/free-vector/organic-flat-people-meditating-illustration_23-2148906556.jpg";
        if (item.headerImageKey != null && item.headerImageKey!.isNotEmpty) {
          headerImageUrl = await _getS3Url(item.headerImageKey!);
        }

        if (mounted) {
          Navigator.push(context, MaterialPageRoute(
              builder: (_) => ArticleDetailScreen(
                title: item.title,
                category: item.category,
                readTime: item.duration,
                imageUrl: headerImageUrl,
                content: markdownContent,
                // ✅ FIXED: PASSING THE COUNSELOR ID HERE
                counselorId: item.counselorId,
              )
          ));
        }
      }
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Could not load resource: $e")));
    } finally {
      if (mounted) setState(() => _isNavigating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<ResourceItem> filteredList = _selectedIndex == 0
        ? _allResources
        : _allResources.where((i) => i.category == _categories[_selectedIndex]).toList();

    final videos = filteredList.where((i) => i.type == 'VIDEO').toList();
    final articles = filteredList.where((i) => i.type == 'ARTICLE').toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 100,
                floating: true,
                pinned: true,
                backgroundColor: const Color(0xFFF8FAFC),
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                  title: Text("Wellness Library", style: GoogleFonts.plusJakartaSans(color: const Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 22)),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
                    child: TextField(
                      onSubmitted: (val) {
                        setState(() => _isLoadingRecommendations = true);
                        _fetchAIRecommendations(val);
                      },
                      decoration: InputDecoration(
                        hintText: "Search or tell us how you feel...",
                        hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey[400]),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFFA1C4FD)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedIndex == index;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedIndex = index),
                        child: AnimatedContainer(
                          duration: 200.ms,
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFA1C4FD) : Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: isSelected ? Colors.transparent : Colors.grey[200]!),
                          ),
                          child: Text(_categories[index], style: GoogleFonts.plusJakartaSans(color: isSelected ? Colors.white : Colors.grey[600], fontWeight: FontWeight.w600)),
                        ),
                      );
                    },
                  ),
                ),
              ),

              if (_isLoadingResources)
                const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
              else ...[
                if (_selectedIndex == 0) ...[
                  SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20, 10, 20, 12), child: Text("Based on your chats", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold)))),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 220,
                      child: _isLoadingRecommendations
                          ? const Center(child: CircularProgressIndicator())
                          : _recommendedItems.isEmpty
                          ? Center(child: Text("No specific recommendations yet.", style: GoogleFonts.plusJakartaSans(color: Colors.grey)))
                          : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: _recommendedItems.length,
                        itemBuilder: (_, i) => RecommendedResourceCard(item: _recommendedItems[i], onTap: () => _handleResourceTap(_recommendedItems[i])),
                      ),
                    ),
                  )
                ],

                if (videos.isNotEmpty) ...[
                  SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 12), child: Text("Browse Videos", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold)))),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(delegate: SliverChildBuilderDelegate((_, i) => ResourceListItem(item: videos[i], index: i, onTap: () => _handleResourceTap(videos[i])), childCount: videos.length)),
                  )
                ],

                if (articles.isNotEmpty) ...[
                  SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 12), child: Text("Browse Articles", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold)))),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(delegate: SliverChildBuilderDelegate((_, i) => ResourceListItem(item: articles[i], index: i, onTap: () => _handleResourceTap(articles[i])), childCount: articles.length)),
                  )
                ],
              ],
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),

          if (_isNavigating)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            )
        ],
      ),
    );
  }
}

// --- WIDGET COMPONENTS ---

class RecommendedResourceCard extends StatelessWidget {
  final ResourceItem item;
  final VoidCallback onTap;

  const RecommendedResourceCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: item.type == 'VIDEO' ? const Color(0xFFFFF1F1) : const Color(0xFFF0F9FF),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Text(item.category, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                Icon(item.type == 'VIDEO' ? FontAwesomeIcons.play : FontAwesomeIcons.bookOpen, size: 14, color: Colors.black45)
              ],
            ),
            const Spacer(),
            Text(item.title, maxLines: 3, overflow: TextOverflow.ellipsis, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(item.duration, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}

class ResourceListItem extends StatelessWidget {
  final ResourceItem item;
  final int index;
  final VoidCallback onTap;

  const ResourceListItem({super.key, required this.item, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(
                color: item.type == 'VIDEO' ? Colors.red[50] : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                item.type == 'VIDEO' ? FontAwesomeIcons.play : FontAwesomeIcons.bookOpen,
                color: item.type == 'VIDEO' ? Colors.redAccent : const Color(0xFFA1C4FD),
                size: 18,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text("${item.category} • ${item.duration}", style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[500])),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (50 * index).ms).slideX();
  }
}
