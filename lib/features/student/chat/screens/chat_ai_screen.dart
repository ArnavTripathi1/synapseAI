import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/chat_background.dart';
import '../widgets/empathy_avatar.dart';

class ChatAIScreen extends StatefulWidget {
  const ChatAIScreen({super.key});

  @override
  State<ChatAIScreen> createState() => _ChatAIScreenState();
}

class _ChatAIScreenState extends State<ChatAIScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = []; // Empty initially to show the "Greeting"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Extend body behind AppBar for that full-screen glass effect
      extendBodyBehindAppBar: true,
      appBar: _buildGlassAppBar(),
      body: Stack(
        children: [
          // 1. The Custom Background
          const EtherealBackground(),

          // 2. The Content
          SafeArea(
            child: Column(
              children: [
                // EXPANDED AREA: Either the Greeting OR the Chat List
                Expanded(
                  child: _messages.isEmpty
                      ? _buildEmptyState() // Shows the "Finn is here" greeting
                      : _buildChatList(), // Shows messages once you type
                ),

                // 3. The Bottom Input Field
                _buildInputArea(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  PreferredSizeWidget _buildGlassAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.5),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: Colors.black87,
          ),
        ),
      ),
      title: Text(
        "Chat with Synapse AI",
        style: GoogleFonts.plusJakartaSans(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  // The "Finn is here..." Centerpiece
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const EmpathyAvatar(),

          const SizedBox(height: 40),

          // The Text
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
                  text: "Myra",
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF7B61FF),
                  ),
                ),
                const TextSpan(text: " is here to listen to you,\n"),
                TextSpan(
                  text: "How are you feeling right now?",
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

  // Placeholder for when messages exist
  Widget _buildChatList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        // Just for demo: We assume all messages in this list are from the User for now.
        // Later, when you connect the API, we will check: isUser ? _buildUserBubble : _buildAIBubble
        return Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16), // More breathing room between bubbles
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75), // Don't stretch full width
            decoration: BoxDecoration(
              // THE SERENITY GRADIENT
              // Matches the Avatar's "Moonstone" vibe
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFA1C4FD), // Soft Periwinkle
                  Color(0xFFC2E9FB), // Pale Cyan
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              // Soft Shadow to make it float (Lightness = Hope)
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFA1C4FD).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
              // Asymmetric rounded corners (looks more organic/friendly than a box)
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(4), // "Speech Bubble" tail
              ),
            ),
            child: Text(
              _messages[index],
              style: const TextStyle(
                color: Color(0xFF1E293B), // "Slate 800" - Soft Dark Blue, easier on eyes than Black
                fontSize: 15,
                height: 1.4, // Better line height for readability
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputArea() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8), // Glass effect
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
              backgroundColor: Color(0xFF7B61FF), // The Purple Send Button
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

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(text);
      _controller.clear();
    });
  }
}
