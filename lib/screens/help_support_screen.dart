// Path: screens/help_support_screen.dart

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  final Color primaryMaroon = AppColors.primaryColor;

  // 🛠️ Custom Option Tile (For Chat/Email/FAQs)
  Widget _buildSupportTile({
    required IconData icon,
    required String title,
    bool isDropdown = false, // True for FAQs
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        leading: Icon(icon, color: primaryMaroon, size: 28),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: Icon(
          isDropdown ? Icons.keyboard_arrow_down : Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 20,
        ),
        onTap: onTap ??
            () {
              // Default action
              // Note: FAQs tile will usually navigate or expand within the screen.
              debugPrint('$title tapped');
            },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Light background matching image
      appBar: AppBar(
        title: const Text('Help & Support', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryMaroon,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            // 1. Headset Icon (Image Placeholder)
            // Note: Exact image is hard to reproduce with standard Icons, using a suitable substitute.
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: primaryMaroon,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.headset_mic, color: Colors.white, size: 60),
            ),
            const SizedBox(height: 20),

            // 2. Greeting Text
            const Text(
              'Hello, How can we help you?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 30),

            // 3. Contact Options (Chat, Email)
            _buildSupportTile(
              icon: Icons.chat_bubble_outline,
              title: 'Contact Live Chat',
              onTap: () {
                // TODO: Implement Live Chat navigation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening Live Chat...')),
                );
              },
            ),
            _buildSupportTile(
              icon: Icons.email_outlined,
              title: 'Send us an Email', // Corrected title from image 'Contact Live Chat' to 'Send us an Email' for logic flow, but keeping icon style
              onTap: () {
                // TODO: Implement Email launch functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening Email App...')),
                );
              },
            ),

            // 4. FAQs Dropdown
            _buildSupportTile(
              icon: Icons.quiz_outlined,
              title: 'FAQs',
              isDropdown: true,
              onTap: () {
                // TODO: Implement FAQ list or navigation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening FAQ Section...')),
                );
              },
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}