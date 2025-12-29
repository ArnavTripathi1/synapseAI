import 'dart:async';
import 'package:flutter/material.dart';

// 1. Create a proper Model for type safety
class ChatMessage {
  final String text;
  final DateTime time;
  final bool isMe;
  final bool isRead;

  ChatMessage({
    required this.text,
    required this.time,
    required this.isMe,
    this.isRead = false,
  });
}

class ChatDetailScreen extends StatefulWidget {
  final String studentName;
  const ChatDetailScreen({super.key, required this.studentName});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isTyping = false; // To simulate the "Other user is typing..." state

  // Note: We initialize with 'reverse' order (Newest first) for the ListView
  late List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _loadMockMessages();
  }

  void _loadMockMessages() {
    final now = DateTime.now();
    _messages = [
      ChatMessage(
        text: "It takes practice. Let's try to focus on just 2 minutes today. I'm sending you a short guide.",
        time: now.subtract(const Duration(minutes: 5)),
        isMe: true,
        isRead: true,
      ),
      ChatMessage(
        text: "I tried, but I find it hard to focus.",
        time: now.subtract(const Duration(minutes: 6)),
        isMe: false,
      ),
      ChatMessage(
        text: "Hi Aditya. That is completely normal. Have you tried the breathing exercises we discussed last week?",
        time: now.subtract(const Duration(minutes: 10)),
        isMe: true,
        isRead: true,
      ),
      ChatMessage(
        text: "Hello Dr. Sharma, I've been feeling a bit anxious about my upcoming exams.",
        time: now.subtract(const Duration(minutes: 15)),
        isMe: false,
      ),
    ];
  }

  // Helper to extract initials
  String _getInitials(String name) {
    if (name.isEmpty) return "";
    List<String> parts = name.trim().split(" ");
    if (parts.length > 1) {
      return "${parts.first[0]}${parts.last[0]}".toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  // Helper to format time (e.g., 10:30 AM)
  String _formatTime(DateTime time) {
    String hour = time.hour > 12 ? (time.hour - 12).toString() : time.hour.toString();
    String period = time.hour >= 12 ? "PM" : "AM";
    String minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute $period";
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // 1. Add User Message
    setState(() {
      _messages.insert(0, ChatMessage(
        text: text,
        time: DateTime.now(),
        isMe: true,
        isRead: false,
      ));
    });
    _messageController.clear();

    // 2. Simulate "Typing..." effect from the student
    setState(() => _isTyping = true);

    // 3. Simulate Auto-Reply (Frontend Magic)
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.insert(0, ChatMessage(
            text: "Thank you, doctor. I will try that right now.",
            time: DateTime.now(),
            isMe: false,
          ));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFE7DE), // Slight warm tone (WhatsApp-like)
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leadingWidth: 40,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF3b5998),
              child: Text(
                _getInitials(widget.studentName),
                style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.studentName,
                  style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  _isTyping ? "typing..." : "Online",
                  style: TextStyle(
                    color: _isTyping ? const Color(0xFF3b5998) : Colors.green,
                    fontSize: 12,
                    fontWeight: _isTyping ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam_outlined, color: Color(0xFF3b5998), size: 28),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. The Chat List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true, // CRITICAL: This keeps list at bottom and handles keyboard push
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];

                // Date Separator Logic (Optional: Add 'Today' header if date changes)
                // For simplicity in this snippet, we focus on the bubbles

                return _buildMessageBubble(message);
              },
            ),
          ),

          // 2. Typing Indicator (Visual flair)
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 12, height: 12,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey),
                      ),
                      SizedBox(width: 8),
                      Text("Typing...", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),

          // 3. Input Area
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.grey, size: 28),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: TextField(
                  controller: _messageController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: "Type a message...",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _sendMessage,
              child: const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFF3b5998),
                child: Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: msg.isMe ? const Color(0xFF3b5998) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: msg.isMe ? const Radius.circular(16) : Radius.zero,
            bottomRight: msg.isMe ? Radius.zero : const Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              msg.text,
              style: TextStyle(
                color: msg.isMe ? Colors.white : Colors.black87,
                fontSize: 15,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(msg.time),
                  style: TextStyle(
                    color: msg.isMe ? Colors.white70 : Colors.grey[500],
                    fontSize: 10,
                  ),
                ),
                if (msg.isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.done_all,
                    size: 14,
                    color: msg.isRead ? Colors.lightBlueAccent : Colors.white54,
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}
