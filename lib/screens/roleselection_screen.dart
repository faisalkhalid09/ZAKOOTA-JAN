// Path: screens/roleselection_screen.dart (Enhanced with Animations)

import 'package:flutter/material.dart';
import 'package:zakoota/utils/app_colors.dart' as app_colors;
import 'client_signup_screen.dart';
import 'lawyer_signup_screen.dart';
import 'login_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with TickerProviderStateMixin {
  String? _selectedRole; // 'lawyer' or 'client'
  late AnimationController _iconController;
  late AnimationController _checkController;

  final Color primary = app_colors.AppColors.primaryColor;
  final Color text = app_colors.AppColors.textColor;

  @override
  void initState() {
    super.initState();
    // Animation controller for icon rotation/bounce
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    // Animation controller for checkmark
    _checkController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _iconController.dispose();
    _checkController.dispose();
    super.dispose();
  }

  // 1. Navigation function to Signup Screens
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

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => targetScreen));
  }

  // 2. Navigation function to Login Screen
  void _navigateToLoginScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  // 3. Role Card Tap Handler with Animations
  void _onRoleCardTap(String role) {
    setState(() {
      _selectedRole = role;
    });
    // Trigger animations
    _iconController.reset();
    _iconController.forward();
    _checkController.reset();
    _checkController.forward();
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
                // Back Button
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
                _buildAnimatedRoleCard(
                  roleTitle: 'I am a Lawyer',
                  roleDescription:
                      'Help your clients dealing with different legal matters, answer their queries and more',
                  isSelected: _selectedRole == 'lawyer',
                  roleKey: 'lawyer',
                  onTap: () => _onRoleCardTap('lawyer'),
                  emoji: '⚖️',
                  icon: Icons.gavel,
                ),
                const SizedBox(height: 20),

                // Client Role Card
                _buildAnimatedRoleCard(
                  roleTitle: 'I am a Client',
                  roleDescription:
                      'Find expert attorneys, get online consultation for your issues, read blogs, and more',
                  isSelected: _selectedRole == 'client',
                  roleKey: 'client',
                  onTap: () => _onRoleCardTap('client'),
                  emoji: '📋',
                  icon: Icons.person,
                ),
                const SizedBox(height: 40),

                // Animated Sign Up Button
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
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
                      elevation: _selectedRole == null ? 2 : 5,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: animation,
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        'Sign up as ${_selectedRole ?? 'Role'}',
                        key: ValueKey<String>(_selectedRole ?? 'none'),
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Sign In Section
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

  // Enhanced Animated Role Card Widget
  Widget _buildAnimatedRoleCard({
    required String roleTitle,
    required String roleDescription,
    required bool isSelected,
    required String roleKey,
    required VoidCallback onTap,
    required String emoji,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: app_colors.AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
              color: isSelected ? primary : Colors.grey.shade300,
              width: isSelected ? 2.5 : 1.0),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: primary.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, 4))
                ]
              : [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 3,
                      offset: const Offset(0, 2))
                ],
        ),
        child: Row(
          children: [
            // Animated Icon Container
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? primary.withOpacity(0.1)
                    : Colors.grey.shade200,
              ),
              child: _selectedRole == roleKey
                  ? RotationTransition(
                      turns: Tween<double>(begin: 0, end: 0.1).animate(
                        CurvedAnimation(
                          parent: _iconController,
                          curve: Curves.elasticOut,
                        ),
                      ),
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 1.0, end: 1.2).animate(
                          CurvedAnimation(
                            parent: _iconController,
                            curve:
                                const Interval(0.0, 0.5, curve: Curves.easeOut),
                          ),
                        ),
                        child: Icon(
                          icon,
                          size: 30,
                          color: primary,
                        ),
                      ),
                    )
                  : Icon(
                      icon,
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
          ],
        ),
      ),
    );
  }
}
