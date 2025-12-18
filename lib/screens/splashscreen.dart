import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'introscreen1.dart';
import 'login_screen.dart';
import 'client_home_screen.dart';
import 'lawyer_home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  /// Check if user is logged in and if intro has been shown
  Future<void> _checkAuthAndNavigate() async {
    // Wait 2 seconds for splash screen display
    await Future.delayed(const Duration(seconds: 2));

    // Check if user is currently logged in with Firebase
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // User is logged in, check their role and navigate to home screen
      await _navigateToHomeScreen(currentUser.uid);
    } else {
      // User is not logged in, check if intro has been shown
      await _checkIntroStatus();
    }
  }

  /// Check if intro screens have been shown before
  Future<void> _checkIntroStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;

    if (!mounted) return;

    if (hasSeenIntro) {
      // User has seen intro before, go directly to login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      // First time user, show intro screens
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const IntroScreen1()),
      );
    }
  }

  /// Get user role from Firestore and navigate to appropriate home screen
  Future<void> _navigateToHomeScreen(String uid) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Check if user is a lawyer
      final lawyerDoc = await firestore.collection('lawyers').doc(uid).get();
      if (lawyerDoc.exists) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LawyerHomeScreen()),
        );
        return;
      }

      // Check if user is a client
      final clientDoc = await firestore.collection('clients').doc(uid).get();
      if (clientDoc.exists) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ClientHomeScreen()),
        );
        return;
      }

      // Role not found, logout and go to intro/login
      await FirebaseAuth.instance.signOut();
      await _checkIntroStatus();
    } catch (e) {
      debugPrint('Error checking user role: $e');
      // On error, logout and go to intro/login
      await FirebaseAuth.instance.signOut();
      await _checkIntroStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF6B1E1E), // 🔹 Dark maroon shade
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔹 App Logo
            Image.asset(
              'assets/intro.png',
              width: size.width * 0.5,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 25),

            // 🔹 App Name
            const Text(
              'Zakoota Lawyer App',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 10),

            // 🔹 Tagline
            const Text(
              'Your Legal Partner Anytime',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
