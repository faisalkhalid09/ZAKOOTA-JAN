// Path: screens/profile_screen.dart (FINAL CODE)

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_colors.dart';
import '../services/session_management_service.dart';
import 'payment_screen.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';
import 'rating_feedback_screen.dart';
import 'help_support_screen.dart'; // 💡 NEW: Linked HelpSupportScreen
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final Color primaryMaroon = AppColors.primaryColor;

  // 🔑 Option Tile Widget (Updated with onTap support)
  Widget _buildOptionTile(
      {required BuildContext context,
      required IconData icon,
      required String title,
      Widget? targetScreen,
      VoidCallback? onTap}) {
    return Column(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          // Icon
          leading: Icon(icon, color: primaryMaroon, size: 24),
          // Title
          title: Text(title, style: const TextStyle(fontSize: 16)),
          // Trailing Arrow
          trailing:
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          onTap: onTap ??
              () {
                if (targetScreen != null) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => targetScreen));
                } else {
                  // TODO: Implement specific action like Logout/Help
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$title tapped')),
                  );
                }
              },
        ),
        // Divider (Horizontal line below the tile)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(height: 1, color: Colors.grey.shade300),
        ),
      ],
    );
  }

  // 🔑 Logout Handler with Session Management
  Future<void> _handleLogout(BuildContext context) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  const Text('Logging out...'),
                ],
              ),
            ),
          );
        },
      );

      // Use SessionManagementService for logout
      final sessionService = SessionManagementService();
      final logoutSuccess = await sessionService.logout();

      if (context.mounted) {
        // Dismiss loading dialog
        Navigator.pop(context);

        if (logoutSuccess) {
          // Navigate to LoginScreen and clear navigation stack
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logout failed. Please try again.')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        // Dismiss loading dialog if open
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: $e')),
        );
      }
      debugPrint('Logout error: $e');
    }
  }

  // 🛠️ Profile Header with Clickable Name/Arrow
  Widget _buildProfileHeader(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox();

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('clients')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          String displayName = 'Client Name';
          String handle = '@client';
          String? profileImage;

          if (snapshot.hasData && snapshot.data!.exists) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            displayName =
                '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim();
            if (displayName.isEmpty) displayName = 'Client Name';
            handle = data['email'] ?? '@client';
            profileImage = data['profileImageUrl'];
          }

          return Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: profileImage != null && profileImage.isNotEmpty
                    ? NetworkImage(profileImage) as ImageProvider
                    : null,
                backgroundColor: Colors.grey,
                child: profileImage == null || profileImage.isEmpty
                    ? const Icon(Icons.person, color: Colors.white, size: 40)
                    : null,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfileScreen()),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: [
                        Text(displayName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        Text(handle,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.arrow_forward_ios,
                        color: Colors.black54, size: 16),
                  ],
                ),
              ),
              const SizedBox(height: 15),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
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
            const SizedBox(height: 20),
            _buildProfileHeader(context),
            const SizedBox(height: 15),

            // Edit Profile Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfileScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryMaroon,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Edit Profile',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 30),

            // Profile Options List
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.only(top: 10),
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
              child: Column(
                children: [
                  _buildOptionTile(
                      context: context,
                      icon: Icons.person_outline,
                      title: 'Personal Information',
                      targetScreen: const SettingsScreen()),
                  _buildOptionTile(
                      context: context,
                      icon: Icons.security,
                      title: 'Account & Security'),
                  _buildOptionTile(
                      context: context,
                      icon: Icons.credit_card_outlined,
                      title: 'Payment & Financial',
                      targetScreen: const PaymentsScreen()),
                  _buildOptionTile(
                      context: context,
                      icon: Icons.calendar_today_outlined,
                      title: 'Booking Appointment'),
                  _buildOptionTile(
                      context: context,
                      icon: Icons.settings,
                      title: 'Rating & Feedback',
                      targetScreen: const RatingFeedbackScreen()),
                  _buildOptionTile(
                      context: context,
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      targetScreen:
                          const HelpSupportScreen()), // ✅ FUNCTIONALITY: Linked to HelpSupportScreen
                  _buildOptionTile(
                      context: context,
                      icon: Icons.logout,
                      title: 'Log out',
                      onTap: () => _handleLogout(context)),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
