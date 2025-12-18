// Path: screens/notifications_screen.dart (FINAL Stateful & Functional)

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/app_nav_bar.dart';

// 🔑 Data Structure
class AppNotification {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  bool isRead; // This needs to be mutable

  AppNotification({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    this.isRead = false,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final Color primaryMaroon = AppColors.primaryColor;
  final Color backgroundColor = const Color(0xFFF7F7F7);
  String _searchQuery = '';

  // 🔑 Dummy Data (Initial List)
  final List<AppNotification> allNotifications = [
    AppNotification(
        title: 'Your appointment with Ali Khan is confirmed.',
        subtitle: 'Tomorrow, 10:00 AM at Lahore High Court.',
        time: 'NEW',
        icon: Icons.calendar_today,
        isRead: false),
    AppNotification(
        title: 'New message from Sarah Ali.',
        subtitle: 'Please review the attached contract.',
        time: '5 hours ago',
        icon: Icons.chat_bubble_outline,
        isRead: false),
    AppNotification(
        title: 'Case Status Changed',
        subtitle: 'Now your case status is \'In Progress\'.',
        time: 'Yesterday',
        icon: Icons.account_balance_wallet_outlined,
        isRead: true),
    AppNotification(
        title: 'New Document Uploaded',
        subtitle: 'Sarah Ali added Case_Evidence.pdf to your case.',
        time: '2 days ago',
        icon: Icons.insert_drive_file,
        isRead: true),
    AppNotification(
        title: 'Payment Received',
        subtitle: 'You received a payment of \$500.',
        time: '1 week ago',
        icon: Icons.attach_money,
        isRead: true),
  ];

  // 🔑 Filtering Logic
  List<AppNotification> get filteredNotifications {
    if (_searchQuery.isEmpty) {
      // Sort: Unread first, then Read
      return allNotifications.toList()
        ..sort((a, b) => a.isRead == b.isRead ? 0 : (a.isRead ? 1 : -1));
    }

    final query = _searchQuery.toLowerCase();
    return allNotifications.where((notification) {
      return notification.title.toLowerCase().contains(query) ||
          notification.subtitle.toLowerCase().contains(query);
    }).toList();
  }
  
  // 🔑 Function to toggle read status
  void _toggleNotificationReadStatus(AppNotification notification) {
    setState(() {
      notification.isRead = !notification.isRead;
    });
  }

  // 🔑 Function to Mark All As Read/Unread
  void _markAllRead() {
    setState(() {
      bool allAreRead = allNotifications.every((n) => n.isRead);
      // Agar sab read hain, toh sabko unread kar do. Warna sabko read kar do.
      bool targetReadStatus = !allAreRead; 
      
      for (var notification in allNotifications) {
        notification.isRead = targetReadStatus;
      }
    });
  }
  
  // 🔑 Notification Tile Widget (Updated UI)
  Widget _buildNotificationTile({required AppNotification notification}) {
    // Background color based on read status
    final tileColor = notification.isRead ? Colors.white : primaryMaroon.withOpacity(0.05);

    return InkWell(
      onTap: () {
        _toggleNotificationReadStatus(notification);
        // TODO: Navigate to notification details screen
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Icon and Border
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: primaryMaroon.withOpacity(0.5)),
              ),
              child: Icon(notification.icon, color: primaryMaroon, size: 20),
            ),
            const SizedBox(width: 12),
            
            // Middle Content (Title and Subtitle)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            
            // Right Status (Time/New Tag)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!notification.isRead && notification.time == 'NEW')
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: primaryMaroon,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text('NEW',
                        style: TextStyle(
                            color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                if (notification.isRead || notification.time != 'NEW')
                  Text(notification.time,
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool allRead = allNotifications.every((n) => n.isRead);
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryMaroon, // Maroon App Bar
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined, color: Colors.white),
            onPressed: () {
              // TODO: Notification Settings or other action
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search Notifications',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
            ),
          ),
          
          // 2. Mark All As Read Button (Dynamic Text)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: ElevatedButton(
              onPressed: _markAllRead, // Calls the function to toggle all statuses
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryMaroon,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                allRead ? 'Mark All As Unread' : 'Mark All As Read',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          
          // 3. Notification List (Filtered and Sorted)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 10),
              children: filteredNotifications.map((notification) {
                return _buildNotificationTile(notification: notification);
              }).toList(),
            ),
          ),
        ],
      ),

      // 4. Bottom Navigation Bar
      bottomNavigationBar: AppNavBar(
        currentIndex: 4, // Adjust index as per your AppNavBar logic
        context: context,
      ),
    );
  }
}