import 'dart:convert';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

// ✅ Custom Widgets & Models
import '../../../../models/AIChatMessage.dart';
import '../../../../models/AIChatSession.dart';
import '../widgets/chat_background.dart';
import '../widgets/empathy_avatar.dart';

class ChatAIScreen extends StatefulWidget {
  const ChatAIScreen({super.key});

  @override
  State<ChatAIScreen> createState() => _ChatAIScreenState();
}

class _ChatAIScreenState extends State<ChatAIScreen> {
  // --- Controllers & Keys ---
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // --- State Variables ---
  List<AIChatMessage> _messages = [];
  List<AIChatSession> _sessions = [];
  AIChatSession? _currentSession;

  bool _isTyping = false;
  bool _isLoadingHistory = true;

  @override
  void initState() {
    super.initState();
    _fetchChatHistory();
  }

  // ==========================================
  // 🚀 BACKEND LOGIC (RAW GRAPHQL STRINGS)
  // ==========================================

  /// 1. Fetch History using String Query
  Future<void> _fetchChatHistory() async {
    const String graphQLDocument = '''query ListSessions {
      listAIChatSessions(limit: 50) {
        items {
          id
          title
          updatedAt
          createdAt
        }
      }
    }''';

    try {
      final request = GraphQLRequest<String>(
        authorizationMode: APIAuthorizationType.userPools,
        document: graphQLDocument,
      );
      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        final Map<String, dynamic> data = jsonDecode(response.data!);
        final List<dynamic> itemsData = data['listAIChatSessions']['items'];

        // Convert JSON Map -> AIChatSession Objects
        final List<AIChatSession> loadedSessions = itemsData.map((json) {
          return AIChatSession(
            id: json['id'],
            title: json['title'],
            updatedAt: json['updatedAt'] != null
                ? TemporalDateTime.fromString(json['updatedAt'])
                : null,
            createdAt: json['createdAt'] != null
                ? TemporalDateTime.fromString(json['createdAt'])
                : null,
          );
        }).toList();

        // Sort: Newest "updatedAt" goes to the top
        loadedSessions.sort((a, b) {
          final aTime = a.updatedAt ?? a.createdAt;
          final bTime = b.updatedAt ?? b.createdAt;
          return bTime!.compareTo(aTime!);
        });

        if (mounted) {
          setState(() {
            _sessions = loadedSessions;
            _isLoadingHistory = false;
          });
        }
      }
    } catch (e) {
      safePrint("Error fetching history: $e");
      if (mounted) setState(() => _isLoadingHistory = false);
    }
  }

  /// 2. Load Conversation using String Query (Filter by SessionID)
  Future<void> _loadSession(AIChatSession session) async {
    Navigator.pop(context); // Close drawer
    setState(() {
      _currentSession = session;
      _messages = [];
      _isTyping = false;
    });

    const String graphQLDocument = '''query ListMessages(\$sessionId: ID!) {
      listAIChatMessages(filter: { sessionID: { eq: \$sessionId } }) {
        items {
          id
          content
          isUser
          createdAt
          sessionID
        }
      }
    }''';

    try {
      final request = GraphQLRequest<String>(
        authorizationMode: APIAuthorizationType.userPools,
        document: graphQLDocument,
        variables: {'sessionId': session.id},
      );
      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        final Map<String, dynamic> data = jsonDecode(response.data!);
        final List<dynamic> itemsData = data['listAIChatMessages']['items'];

        final List<AIChatMessage> loadedMessages = itemsData.map((json) {
          return AIChatMessage(
            id: json['id'],
            sessionID: json['sessionID'],
            content: json['content'],
            isUser: json['isUser'],
            createdAt: TemporalDateTime.fromString(json['createdAt']),
          );
        }).toList();

        // Sort: Oldest to Newest
        loadedMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

        if (mounted) {
          setState(() {
            _messages = loadedMessages;
          });
        }
      }
    } catch (e) {
      safePrint("Error loading messages: $e");
    }
  }

  /// 3. Reset State
  void _startNewChat() {
    Navigator.pop(context);
    setState(() {
      _currentSession = null;
      _messages = [];
      _isTyping = false;
    });
  }

  /// 4. Send Message (Raw Mutations)
  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final now = TemporalDateTime.now();
    final nowIso = now.toString(); // For JSON variables

    // 🅰️ Optimistic Update
    setState(() {
      _messages.add(
        AIChatMessage(
          id: DateTime.now().toString(),
          sessionID: _currentSession?.id ?? "temp",
          content: text,
          isUser: true,
          createdAt: now,
        ),
      );
      _controller.clear();
      _isTyping = true;
    });

    try {
      // 🅱️ Create Session if needed
      if (_currentSession == null) {
        String autoTitle = text.length > 30
            ? "${text.substring(0, 30)}..."
            : text;

        const String createSessionMutation =
            '''mutation CreateSession(\$title: String!, \$updatedAt: AWSDateTime!) {
          createAIChatSession(input: { title: \$title, updatedAt: \$updatedAt }) {
            id
            title
            updatedAt
            createdAt
          }
        }''';

        final request = GraphQLRequest<String>(
          authorizationMode: APIAuthorizationType.userPools,
          document: createSessionMutation,
          variables: {'title': autoTitle, 'updatedAt': nowIso},
        );

        final response = await Amplify.API.mutate(request: request).response;

        if (response.data != null) {
          final json = jsonDecode(response.data!)['createAIChatSession'];
          _currentSession = AIChatSession(
            id: json['id'],
            title: json['title'],
            updatedAt: TemporalDateTime.fromString(json['updatedAt']),
            createdAt: TemporalDateTime.fromString(json['createdAt']),
          );
          _fetchChatHistory(); // Refresh Sidebar
        }
      } else {
        // Update Timestamp
        const String updateSessionMutation =
            '''mutation UpdateSession(\$id: ID!, \$updatedAt: AWSDateTime!) {
          updateAIChatSession(input: { id: \$id, updatedAt: \$updatedAt }) {
            id
            updatedAt
          }
        }''';

        final request = GraphQLRequest<String>(
          authorizationMode: APIAuthorizationType.userPools,
          document: updateSessionMutation,
          variables: {'id': _currentSession!.id, 'updatedAt': nowIso},
        );
        // Fire and forget (don't await strictly for UI speed)
        Amplify.API.mutate(request: request);
      }

      // 🆎 Save USER Message
      const String createMessageMutation =
          '''mutation CreateMessage(\$sessionId: ID!, \$content: String!, \$isUser: Boolean!, \$createdAt: AWSDateTime!) {
        createAIChatMessage(input: { sessionID: \$sessionId, content: \$content, isUser: \$isUser, createdAt: \$createdAt }) {
          id
        }
      }''';

      final userMsgRequest = GraphQLRequest<String>(
        authorizationMode: APIAuthorizationType.userPools,
        document: createMessageMutation,
        variables: {
          'sessionId': _currentSession!.id,
          'content': text,
          'isUser': true,
          'createdAt': nowIso,
        },
      );
      await Amplify.API.mutate(request: userMsgRequest).response;

      // 🆑 Call Lambda API (Synapse AI)
      final body = jsonEncode({'question': text});
      final restOperation = Amplify.API.post(
        '/chat',
        apiName: 'synapseAI',
        body: HttpPayload.string(body),
        headers: {'Content-Type': 'application/json'},
      );

      final apiRes = await restOperation.response;
      final jsonResponse = jsonDecode(await apiRes.decodeBody());
      final aiText = jsonResponse['answer'] ?? "I'm listening...";

      // 🆔 Save AI Message
      final aiMsgRequest = GraphQLRequest<String>(
        authorizationMode: APIAuthorizationType.userPools,
        document: createMessageMutation, // Reuse the same mutation string
        variables: {
          'sessionId': _currentSession!.id,
          'content': aiText,
          'isUser': false,
          'createdAt': TemporalDateTime.now().toString(),
        },
      );

      final aiRes = await Amplify.API.mutate(request: aiMsgRequest).response;
      String newAiMsgId = "temp_ai_id";

      if (aiRes.data != null) {
        newAiMsgId = jsonDecode(aiRes.data!)['createAIChatMessage']['id'];
      }

      // 📧 Update UI
      if (mounted) {
        setState(() {
          _messages.add(
            AIChatMessage(
              id: newAiMsgId,
              sessionID: _currentSession!.id,
              content: aiText,
              isUser: false,
              createdAt: TemporalDateTime.now(),
            ),
          );
          _isTyping = false;
        });
      }
    } catch (e) {
      safePrint("Error in chat flow: $e");
      if (mounted) {
        setState(() {
          _messages.add(
            AIChatMessage(
              id: "error",
              sessionID: "error",
              content: "I'm having trouble connecting. Please try again.",
              isUser: false,
              createdAt: now,
            ),
          );
          _isTyping = false;
        });
      }
    }
  }

  // ==========================================
  // 🎨 UI COMPONENTS (UNCHANGED)
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      drawer: _buildGeminiDrawer(),
      appBar: _buildGlassAppBar(),
      body: Stack(
        children: [
          const EtherealBackground(),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: _messages.isEmpty && !_isTyping
                      ? _buildEmptyState()
                      : _buildChatList(),
                ),
                if (_isTyping) _buildTypingIndicator(),
                _buildInputArea(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeminiDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFFF0F4F8),
      surfaceTintColor: Colors.transparent,
      width: MediaQuery.of(context).size.width * 0.75,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              child: InkWell(
                onTap: _startNewChat,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD3E3FD),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add, color: Color(0xFF041E49), size: 20),
                      const SizedBox(width: 12),
                      Text(
                        "New chat",
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF041E49),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                "Recent",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ),
            Expanded(
              child: _isLoadingHistory
                  ? const Center(child: CircularProgressIndicator())
                  : _sessions.isEmpty
                  ? Center(
                      child: Text(
                        "No history yet",
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: _sessions.length,
                      itemBuilder: (context, index) {
                        final session = _sessions[index];
                        final isActive = _currentSession?.id == session.id;
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFFD3E3FD).withOpacity(0.5)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            dense: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            leading: const Icon(
                              FontAwesomeIcons.message,
                              size: 14,
                              color: Colors.black54,
                            ),
                            title: Text(
                              session.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            onTap: () => _loadSession(session),
                          ),
                        );
                      },
                    ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.help_outline,
                size: 20,
                color: Colors.black87,
              ),
              title: Text(
                "Help & FAQ",
                style: GoogleFonts.plusJakartaSans(fontSize: 14),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildGlassAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      title: Text(
        "Synapse AI",
        style: GoogleFonts.plusJakartaSans(
          color: Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const EmpathyAvatar(),
          const SizedBox(height: 40),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.plusJakartaSans(
                fontSize: 24,
                height: 1.3,
                color: const Color(0xFF2B2D42),
              ),
              children: [
                TextSpan(
                  text: "Hi there,\n",
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "How can I help you today?",
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 800.ms).moveY(begin: 20, end: 0),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        return Align(
          alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: _buildMessageBubble(msg),
        );
      },
    );
  }

  Widget _buildMessageBubble(AIChatMessage msg) {
    final isUser = msg.isUser;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.8,
      ),
      decoration: BoxDecoration(
        gradient: isUser
            ? const LinearGradient(
          colors: [Color(0xFFA1C4FD), Color(0xFFC2E9FB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : const LinearGradient(colors: [Colors.white, Colors.white]),
        color: isUser ? null : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(24),
          topRight: const Radius.circular(24),
          bottomLeft: Radius.circular(isUser ? 24 : 4),
          bottomRight: Radius.circular(isUser ? 4 : 24),
        ),
      ),
      // ✅ CHANGED: Used MarkdownBody instead of Text
      child: MarkdownBody(
        data: msg.content,
        selectable: true, // Allows users to copy text
        styleSheet: MarkdownStyleSheet(
          // 'p' is for normal paragraph text - matches your old Text style
          p: const TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 15,
            height: 1.4,
            fontWeight: FontWeight.w500,
          ),
          // 'strong' is for **bold** text
          strong: const TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
          ),
          // Styles for bullet lists
          listBullet: const TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 16,
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          _dot(0),
          const SizedBox(width: 4),
          _dot(200),
          const SizedBox(width: 4),
          _dot(400),
        ],
      ),
    );
  }

  Widget _dot(int delay) {
    return const CircleAvatar(radius: 4, backgroundColor: Color(0xFF7B61FF))
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scale(delay: delay.ms, duration: 600.ms);
  }

  Widget _buildInputArea() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Tell me what's on your mind...",
                hintStyle: GoogleFonts.plusJakartaSans(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
              onSubmitted: _sendMessage,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _sendMessage(_controller.text),
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFF7B61FF),
              child: Icon(
                FontAwesomeIcons.paperPlane,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
