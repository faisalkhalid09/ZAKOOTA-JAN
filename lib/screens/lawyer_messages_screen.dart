import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class LawyerMessagesScreen extends StatefulWidget {
  const LawyerMessagesScreen({super.key});

  @override
  State<LawyerMessagesScreen> createState() => _LawyerMessagesScreenState();
}

class _LawyerMessagesScreenState extends State<LawyerMessagesScreen> {
  int? selectedChatIndex;
  bool showSidebar = false;

  final List<Map<String, dynamic>> chats = [
    {
      'name': 'Ahmed Hassan',
      'lastMessage': 'Thank you for the update on my case...',
      'time': '2m',
      'unread': 2,
      'online': true,
      'messages': [
        {
          'text': 'Hello, I need help with my case',
          'isMe': false,
          'time': '10:30 AM'
        },
        {
          'text': 'Sure, I can help you. What seems to be the issue?',
          'isMe': true,
          'time': '10:32 AM'
        },
        {
          'text': 'I received a notice from the court',
          'isMe': false,
          'time': '10:35 AM'
        },
        {
          'text': 'No problem, let me review it. Can you send me the document?',
          'isMe': true,
          'time': '10:37 AM'
        },
        {
          'text': 'Yes, I will send it right away',
          'isMe': false,
          'time': '10:38 AM'
        },
        {
          'text': 'Thank you for the update on my case...',
          'isMe': false,
          'time': '10:40 AM'
        },
      ],
    },
    {
      'name': 'Fatima Ali',
      'lastMessage': 'When is the next hearing scheduled?',
      'time': '1h',
      'unread': 0,
      'online': false,
      'messages': [
        {'text': 'Good morning', 'isMe': false, 'time': '9:00 AM'},
        {
          'text': 'Good morning! How can I help you?',
          'isMe': true,
          'time': '9:05 AM'
        },
        {
          'text': 'When is the next hearing scheduled?',
          'isMe': false,
          'time': '9:10 AM'
        },
      ],
    },
    {
      'name': 'Usman Khan',
      'lastMessage': 'I have some questions about the contract',
      'time': '3h',
      'unread': 1,
      'online': true,
      'messages': [
        {'text': 'I need contract review', 'isMe': false, 'time': 'Yesterday'},
        {
          'text': 'I have some questions about the contract',
          'isMe': false,
          'time': 'Yesterday'
        },
      ],
    },
    {
      'name': 'Sana Khan',
      'lastMessage': 'Thank you for accepting my request',
      'time': '5h',
      'unread': 0,
      'online': false,
      'messages': [
        {
          'text': 'Thank you for accepting my request',
          'isMe': false,
          'time': 'Yesterday'
        },
      ],
    },
    {
      'name': 'Ali Raza',
      'lastMessage': 'Can we schedule a meeting?',
      'time': '1d',
      'unread': 0,
      'online': false,
      'messages': [
        {
          'text': 'Can we schedule a meeting?',
          'isMe': false,
          'time': '2 days ago'
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Row(
          children: [
            // Sidebar when chat is open
            if (showSidebar && selectedChatIndex != null)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: 70,
                child: _buildSidebar(),
              ),
            // Main content with animation
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final offsetAnimation = Tween<Offset>(
                    begin: selectedChatIndex == null
                        ? const Offset(
                            -1.0, 0.0) // Slide from left when closing
                        : const Offset(
                            1.0, 0.0), // Slide from right when opening
                    end: Offset.zero,
                  ).animate(animation);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: selectedChatIndex == null
                    ? KeyedSubtree(
                        key: const ValueKey('chatsList'),
                        child: _buildChatsList(),
                      )
                    : KeyedSubtree(
                        key: ValueKey('chat_$selectedChatIndex'),
                        child: _buildChatView(),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 70,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          right: BorderSide(color: AppColors.gray200, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Back button
          Container(
            padding: const EdgeInsets.all(12),
            child: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: AppColors.maroonPrimary, size: 24),
              onPressed: () {
                setState(() {
                  selectedChatIndex = null;
                  showSidebar = false;
                });
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
          Divider(color: AppColors.gray200, height: 1),
          // Profile pictures
          Expanded(
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                if (index == selectedChatIndex) return const SizedBox.shrink();
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedChatIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.maroonVeryLight,
                          child: Icon(Icons.person,
                              color: AppColors.maroonPrimary, size: 22),
                        ),
                        if (chats[index]['unread'] > 0)
                          Positioned(
                            right: 8,
                            top: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: AppColors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        if (chats[index]['online'])
                          Positioned(
                            right: 8,
                            bottom: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.green,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.white, width: 2),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatsList() {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.gray200),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gray200.withOpacity(0.5),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: AppColors.gray600, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search messages...',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: AppColors.gray600,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Chats list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildChatCard(index),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChatCard(int index) {
    final chat = chats[index];
    return InkWell(
      onTap: () {
        setState(() {
          selectedChatIndex = index;
          showSidebar = true;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              chat['unread'] > 0 ? AppColors.maroonVeryLight : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: chat['unread'] > 0
                ? AppColors.maroonLight.withOpacity(0.3)
                : AppColors.gray200,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.gray200.withOpacity(0.5),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.maroonVeryLight,
                  child: Icon(Icons.person,
                      color: AppColors.maroonPrimary, size: 26),
                ),
                if (chat['unread'] > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: AppColors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${chat['unread']}',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                if (chat['online'])
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat['name'],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: chat['unread'] > 0
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                      Text(
                        chat['time'],
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.gray600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat['lastMessage'],
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.gray600,
                      fontWeight: chat['unread'] > 0
                          ? FontWeight.w500
                          : FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatView() {
    if (selectedChatIndex == null) return const SizedBox.shrink();

    final chat = chats[selectedChatIndex!];
    final messages = chat['messages'] as List<Map<String, dynamic>>;

    return Column(
      children: [
        // Chat header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border(
              bottom: BorderSide(color: AppColors.gray200, width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.gray200.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.maroonVeryLight,
                    child: Icon(Icons.person,
                        color: AppColors.maroonPrimary, size: 20),
                  ),
                  if (chat['online'])
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),
                    if (chat['online'])
                      Text(
                        'Online',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon:
                    Icon(Icons.phone, color: AppColors.maroonPrimary, size: 22),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.videocam,
                    color: AppColors.maroonPrimary, size: 22),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.more_vert, color: AppColors.gray600, size: 22),
                onPressed: () {},
              ),
            ],
          ),
        ),
        // Messages
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return _buildMessageBubble(
                message['text'],
                message['isMe'],
                message['time'],
              );
            },
          ),
        ),
        // Message input
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildMessageBubble(String text, bool isMe, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.maroonVeryLight,
              child:
                  Icon(Icons.person, color: AppColors.maroonPrimary, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? AppColors.maroonPrimary : AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(isMe ? 12 : 0),
                  bottomRight: Radius.circular(isMe ? 0 : 12),
                ),
                border: Border.all(
                  color: isMe ? AppColors.maroonPrimary : AppColors.gray200,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gray200.withOpacity(0.3),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 13,
                      color: isMe ? AppColors.white : AppColors.textColor,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 10,
                      color: isMe
                          ? AppColors.white.withOpacity(0.7)
                          : AppColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.maroonVeryLight,
              child:
                  Icon(Icons.person, color: AppColors.maroonPrimary, size: 16),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.gray200, width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file, color: AppColors.gray600, size: 22),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.gray200),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: AppColors.gray600,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                style: const TextStyle(fontSize: 13),
                maxLines: null,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.maroonPrimary,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.send, color: AppColors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
