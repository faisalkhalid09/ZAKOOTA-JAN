// Path: screens/roleselection_screen.dart

import 'package:flutter/material.dart';
import 'package:my_flutter_app/utils/app_colors.dart' as app_colors;
import 'client_signup_screen.dart';
import 'lawyer_signup_screen.dart';
import 'login_screen.dart'; // Login Screen ka import shamil karen

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole; // 'lawyer' or 'client'

  final Color primary = app_colors.AppColors.primaryColor;
  final Color text = app_colors.AppColors.textColor;

  // 1. Navigation function to Signup Screens (Used by the final button)
  void _navigateToSignUpScreen() {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please select whether you are a client or a lawyer.')),
      );
      return;
    }

    Widget targetScreen;
    if (_selectedRole == 'lawyer') {
      targetScreen = const LawyerSignUpScreen();
    } else {
      targetScreen = const ClientSignUpScreen();
    }

    // 💡 FIX: pushReplacement ki jagah Navigator.push istemal kiya hai.
    // Isse RoleSelectionScreen stack mein rahegi aur Signup Screen ka back arrow uspar wapas jaa sakega.
    Navigator.push(context, MaterialPageRoute(builder: (_) => targetScreen));
  }

  // 2. Navigation function to Login Screen (Used by the 'Login' link/button)
  void _navigateToLoginScreen() {
    // 💡 FIX: pushReplacement ki jagah Navigator.push istemal kiya hai.
    // Isse user Login Screen par jaa sakega aur wahan se back aakar role select kar sakega.
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  // 3. Role Card Tap Handler (ONLY SELECTS ROLE, DOES NOT NAVIGATE IMMEDIATELY)
  void _onRoleCardTap(String role) {
    setState(() {
      _selectedRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_colors.AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button (Yeh button agar RoleSelectionScreen se pehle koi screen hai toh hi kaam karega,
                // otherwise agar yeh app ki pehli screen hai toh isko hata dena chahiye ya iski functionality change karni chahiye.)
                // Assuming isse pehle koi Intro/Splash screen hai.
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: text,
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 10),

                // Title Section
                Text(
                  'I am',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: primary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose the type of your account accordingly so\nwe can find what you need.',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: text),
                ),
                const SizedBox(height: 30),

                // Lawyer Role Card
                _buildRoleCard(
                  roleTitle: 'I am a Lawyer',
                  roleDescription:
                      'Help your clients dealing with different legal matters, answer their queries and more',
                  isSelected: _selectedRole == 'lawyer',
                  onTap: () => _onRoleCardTap('lawyer'),
                ),
                const SizedBox(height: 20),

                // Client Role Card
                _buildRoleCard(
                  roleTitle: 'I am a Client',
                  roleDescription:
                      'Find expert attorneys, get online consultation for your issues, read blogs, and more',
                  isSelected: _selectedRole == 'client',
                  onTap: () => _onRoleCardTap('client'),
                ),
                const SizedBox(height: 40),

                // Final Sign Up Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        _selectedRole == null ? null : _navigateToSignUpScreen,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      elevation: 5,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(
                      'Sign up as ${_selectedRole ?? 'Role'}',
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Sign In Section (Changed to Login)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Joined us before?',
                        style: TextStyle(fontSize: 14, color: text)),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: _navigateToLoginScreen,
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Role Card Widget (No change)
  Widget _buildRoleCard({
    required String roleTitle,
    required String roleDescription,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: app_colors.AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
              color: isSelected ? primary : Colors.grey.shade300,
              width: isSelected ? 2.0 : 1.0),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: primary.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 3))
                ]
              : null,
        ),
        child: Row(
          children: [
            // Placeholder Icon for Role Image
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.grey.shade200),
              // Conditional Icon based on role
              child: Icon(
                roleTitle.contains('Lawyer') ? Icons.gavel : Icons.cases,
                size: 30,
                color: primary,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(roleTitle,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primary)),
                  const SizedBox(height: 4),
                  Text(roleDescription,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: text.withOpacity(0.8))),
                ],
              ),
            ),
            // Selection indicator
            if (isSelected) Icon(Icons.check_circle, color: primary),
          ],
        ),
      ),
    );
  }
}
