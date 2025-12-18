// Path: screens/chat_screen.dart (FIXED Context Error)

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ChatScreen extends StatelessWidget {
  final String lawyerName;
  const ChatScreen({super.key, required this.lawyerName});

  final Color primaryMaroon = AppColors.primaryColor;
  final Color backgroundColor = const Color(0xFFF7F7F7);

  // 🔑 Message Bubble Widget (Context added as argument)
  Widget _buildMessageBubble(
      {required BuildContext context, // ✅ Context added here
      required String message,
      required bool isMe}) {
    // Alignment based on sender
    final alignment = isMe ? Alignment.centerRight : Alignment.centerLeft;
    final color = isMe ? primaryMaroon : Colors.grey.shade200;
    final textColor = isMe ? Colors.white : Colors.black;

    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              // Fix: Context is now available
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15),
                topRight: const Radius.circular(15),
                bottomLeft: isMe ? const Radius.circular(15) : Radius.zero,
                bottomRight: isMe ? Radius.zero : const Radius.circular(15),
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Text(
              message,
              style: TextStyle(color: textColor, fontSize: 15),
            ),
          ),
          const SizedBox(height: 4),
          // Time Stamp (Optional, for realistic chat)
          Text(
            '${isMe ? '10:05 AM' : '10:07 AM'}',
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ],
      ),
    );
  }

  // 🔑 Message Input Field Widget
  Widget _buildChatInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: Colors.white,
      child: SafeArea(
        child: Row(
          children: [
            // Attachment Icon
            IconButton(
              icon: Icon(Icons.attachment, color: primaryMaroon),
              onPressed: () {
                // TODO: Handle attachment upload
              },
            ),
            // Text Input Field
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                ),
              ),
            ),
            // Send Button
            CircleAvatar(
              backgroundColor: primaryMaroon,
              radius: 20,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: () {
                  // TODO: Handle message send
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lawyerName,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              'Online', // Dummy status
              style: TextStyle(color: Colors.greenAccent, fontSize: 12),
            ),
          ],
        ),
        backgroundColor: primaryMaroon, // Maroon App Bar
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // TODO: Chat options (e.g., View Profile, Clear Chat)
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Message List Area
          Expanded(
            child: ListView(
              reverse: true, // Newest messages bottom par show honge
              padding: const EdgeInsets.only(top: 10.0),
              children: [
                _buildMessageBubble(
                    context: context, // ✅ Context passed here
                    message: 'I have attached the required affidavit.',
                    isMe: true),
                _buildMessageBubble(
                    context: context, // ✅ Context passed here
                    message: 'Thank you. I will review it shortly.',
                    isMe: false),
                _buildMessageBubble(
                    context: context, // ✅ Context passed here
                    message: 'Did you receive the documents I sent yesterday?',
                    isMe: true),
                _buildMessageBubble(
                    context: context, // ✅ Context passed here
                    message:
                        'Yes, I received them. Please check your email for the next steps.',
                    isMe: false),
                // Add more dummy messages for scroll testing
                _buildMessageBubble(
                    context: context, message: 'Okay, thanks.', isMe: true),
                _buildMessageBubble(
                    context: context, message: 'You are welcome.', isMe: false),
              ]
                  .reversed
                  .toList(), // Messages ko seedha order mein dikhane ke liye reverse kiya
            ),
          ),

          // Chat Input Field
          _buildChatInput(context),
        ],
      ),
    );
  }
}
