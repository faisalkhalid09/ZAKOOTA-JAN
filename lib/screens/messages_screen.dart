// Path: screens/messages_screen.dart (FINAL Stateful & Filtered)

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'chat_screen.dart';

// 🔑 Data Structure
class Message {
  final String name;
  final String designation;
  final String message;
  final String time;
  final bool isNew;

  Message({
    required this.name,
    required this.designation,
    required this.message,
    required this.time,
    required this.isNew,
  });
}

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final Color primaryMaroon = AppColors.primaryColor;
  final Color backgroundColor = const Color(0xFFF7F7F7);
  String _searchQuery = ''; // State variable for search

  // 🔑 Dummy Data
  final List<Message> allMessages = [
    Message(
        name: 'Adnan Tariq',
        designation: 'Family Lawyer',
        message: 'Please send the document.',
        time: 'Yesterday',
        isNew: true),
    Message(
        name: 'Faisal Azeem',
        designation: 'Criminal Lawyer',
        message: 'Sure, tomorrow works for me.',
        time: 'Monday',
        isNew: false),
    Message(
        name: 'Amna Mazan',
        designation: 'Property Lawyer',
        message: 'That sounds good to me.',
        time: '1 month ago',
        isNew: false),
    Message(
        name: 'Jibran Khalid',
        designation: 'Corporate Lawyer',
        message: 'We will review and...',
        time: '1 month ago',
        isNew: false),
    Message(
        name: 'Faris Shah',
        designation: 'Tax Lawyer',
        message: 'I\'ve attached the deed of sale...',
        time: '3 months ago',
        isNew: false),
  ];

  // 🔑 Filtering Logic
  List<Message> get filteredMessages {
    if (_searchQuery.isEmpty) {
      return allMessages;
    }
    return allMessages.where((messageItem) {
      final query = _searchQuery.toLowerCase();
      // Search by Name, Designation, or Message content
      return messageItem.name.toLowerCase().contains(query) ||
          messageItem.designation.toLowerCase().contains(query) ||
          messageItem.message.toLowerCase().contains(query);
    }).toList();
  }

  // 🔑 Updated Message Tile Widget
  Widget _buildMessageTile({
    required BuildContext context,
    required Message messageItem,
  }) {
    return InkWell(
      onTap: () {
        // Navigate to chat screen on tap
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(lawyerName: messageItem.name)),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Profile Picture
            const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 15),

            // Middle: Name, Designation, Message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    messageItem.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: messageItem.isNew ? Colors.black : Colors.black87,
                    ),
                  ),
                  Text(
                    messageItem.designation, // e.g. Family Lawyer
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    messageItem.message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: messageItem.isNew
                          ? Colors.black
                          : Colors.grey.shade700,
                      fontWeight: messageItem.isNew
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            // Right: Time
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                messageItem.time,
                style: TextStyle(
                  color: messageItem.isNew ? primaryMaroon : Colors.grey,
                  fontSize: 12,
                  fontWeight:
                      messageItem.isNew ? FontWeight.bold : FontWeight.normal,
                ),
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
        title: const Text(
          'Messages',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryMaroon, // Maroon App Bar
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {
              // TODO: Navigate to Message Settings
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Search Bar (Now updates state for filtering)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value; // 🔑 Search Query updated
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search Lawyer or Case...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                ),
              ),
            ),
          ),

          // 2. Filtered Message List
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: filteredMessages.map((messageItem) {
                return _buildMessageTile(
                  context: context,
                  messageItem: messageItem,
                );
              }).toList(), // List of filtered widgets
            ),
          ),
        ],
      ),

      // 3. Floating Action Button
      floatingActionButton: FloatingActionButton(
        heroTag: 'messages_fab',
        onPressed: () {
          // TODO: Start New Chat
        },
        backgroundColor: primaryMaroon,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
