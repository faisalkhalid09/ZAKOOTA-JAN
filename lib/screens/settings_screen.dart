// Path: screens/settings_screen.dart

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'edit_profile_screen.dart'; // Linking Edit Profile

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Color primaryMaroon = AppColors.primaryColor;
  String? _selectedLanguage = 'English';
  String? _selectedCountry = 'Pakistan';

  // 🛠️ Custom Tile Widget for Options
  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    Widget? trailingWidget,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          leading: Icon(icon, color: primaryMaroon, size: 20),
          title: Text(title, style: const TextStyle(fontSize: 15)),
          trailing: trailingWidget ??
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          onTap: onTap,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(height: 1, color: Colors.grey.shade300),
        ),
      ],
    );
  }

  // 🛠️ Custom Dropdown Field Widget
  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String currentValue,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: currentValue,
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                items: items.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        Icon(icon, color: primaryMaroon, size: 18),
                        const SizedBox(width: 10),
                        Text(value, style: const TextStyle(fontSize: 15)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Setting', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryMaroon,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Area for quick navigation to Edit Profile
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              leading: const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/profile_placeholder.png'),
                backgroundColor: Colors.grey,
              ),
              title: const Text('Amal aml', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: const Text('@amalaml', style: TextStyle(color: Colors.grey, fontSize: 13)),
              trailing: Icon(Icons.arrow_forward_ios, color: primaryMaroon, size: 16),
              onTap: () {
                // Navigates to Edit Profile when clicking on the profile area
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                );
              },
            ),
            Divider(height: 1, color: Colors.grey.shade300),
            const SizedBox(height: 10),

            // Select Language
            _buildDropdownField(
              label: 'Select Language',
              icon: Icons.lock_outline, // Using lock icon as per image
              currentValue: _selectedLanguage!,
              items: const ['English', 'Urdu', 'Arabic'],
              onChanged: (newValue) {
                setState(() {
                  _selectedLanguage = newValue;
                });
              },
            ),

            // Select Country/Region
            _buildDropdownField(
              label: 'Select Country/ Region',
              icon: Icons.location_on_outlined, // Using location icon as per image
              currentValue: _selectedCountry!,
              items: const ['Pakistan', 'USA', 'UK'],
              onChanged: (newValue) {
                setState(() {
                  _selectedCountry = newValue;
                });
              },
            ),
            const SizedBox(height: 10),

            // Lawyer Preference Header
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 5, bottom: 5),
              child: Text('Lawyer Preference', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryMaroon)),
            ),
            _buildOptionTile(
              icon: Icons.balance,
              title: 'Preferred Lawyer Type',
              onTap: () {},
            ),
            _buildOptionTile(
              icon: Icons.balance,
              title: 'Preferred Consultation Type',
              onTap: () {},
            ),
            const SizedBox(height: 10),

            // Privacy & Security Header
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 5, bottom: 5),
              child: Text('Privacy & Security', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryMaroon)),
            ),
            _buildOptionTile(
              icon: Icons.lock_outline,
              title: 'Profile Visibility',
              onTap: () {},
            ),
            _buildOptionTile(
              icon: Icons.chat_bubble_outline,
              title: 'Who can message me',
              onTap: () {},
            ),
            const SizedBox(height: 10),

            // Display & Theme Header
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 5, bottom: 5),
              child: Text('Display & Theme', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryMaroon)),
            ),
            _buildOptionTile(
              icon: Icons.lock_outline, // Placeholder icon
              title: 'Dark/Light mode',
              trailingWidget: Switch(
                value: true, // Assuming default is Light mode (or set state)
                onChanged: (val) {
                  // TODO: Implement Theme toggle logic
                },
                activeColor: primaryMaroon,
              ),
              onTap: () {},
            ),
            const SizedBox(height: 10),

            // Notifications Header
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 5, bottom: 5),
              child: Text('Notifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryMaroon)),
            ),
            _buildOptionTile(
              icon: Icons.calendar_today_outlined, // Placeholder icon
              title: 'Appointment Reminder',
              trailingWidget: Switch(
                value: true,
                onChanged: (val) {
                  // TODO: Implement switch logic
                },
                activeColor: primaryMaroon,
              ),
              onTap: () {},
            ),
            _buildOptionTile(
              icon: Icons.balance, // Placeholder icon
              title: 'Lawyer Messages',
              trailingWidget: Switch(
                value: false,
                onChanged: (val) {
                  // TODO: Implement switch logic
                },
                activeColor: primaryMaroon,
              ),
              onTap: () {},
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}