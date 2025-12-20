import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_colors.dart';
import '../services/google_sign_in_service.dart';
import 'login_screen.dart';
import 'lawyer_profile_setup_screen.dart';

class LawyerSignUpScreen extends StatefulWidget {
  const LawyerSignUpScreen({super.key});

  @override
  State<LawyerSignUpScreen> createState() => _LawyerSignUpScreenState();
}

class _LawyerSignUpScreenState extends State<LawyerSignUpScreen> {
  final Color primaryMaroon = AppColors.primaryColor;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignInService _googleSignInService = GoogleSignInService();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  // Google Sign-In Logic
  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      final UserCredential? userCredential =
          await _googleSignInService.signInWithGoogle();

      if (userCredential == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google Sign-In cancelled.')),
        );
        return;
      }

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Sign-in failed, user not created.');
      }

      // Check if user already exists
      final docSnapshot =
          await _firestore.collection('users').doc(user.uid).get();

      if (docSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Account already exists. Redirecting to Login.')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        return;
      }

      final displayName = user.displayName ?? '';

      // Save to users collection
      await _firestore.collection('users').doc(user.uid).set({
        'name': displayName,
        'email': user.email ?? '',
        'phone': '', // Will be added in profile setup if needed
        'role': 'lawyer',
        'isActive': true,
        'isVerified': false,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
        'profilePictureURL': '',
      });

      // Create placeholder lawyerProfiles document
      await _firestore.collection('lawyerProfiles').doc(user.uid).set({
        'userId': user.uid,
        'fullName': '',
        'cnic': '',
        'yearsOfExperience': 0,
        'barCouncil': '',
        'licenseNumber': '',
        'licenseCardFrontURL': '',
        'licenseCardBackURL': '',
        'selfieWithLicenseURL': '',
        'verificationStatus': 'pending',
        'verifiedAt': null,
        'verifiedBy': null,
        'rejectionReason': null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Navigate to Profile Setup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LawyerProfileSetupScreen(userId: user.uid)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Email/Password Registration
  Future<void> _registerLawyer() async {
    setState(() => _isLoading = true);

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final fullName = nameController.text.trim();
      final phone = phoneController.text.trim();

      if (email.isEmpty ||
          password.isEmpty ||
          fullName.isEmpty ||
          phone.isEmpty) {
        throw Exception("Name, Email, Phone, and Password are required.");
      }

      // Firebase Auth Registration
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception("Registration failed, user not created.");
      }

      // Save to users collection
      await _firestore.collection('users').doc(user.uid).set({
        'name': fullName,
        'email': email,
        'phone': phone,
        'role': 'lawyer',
        'isActive': true,
        'isVerified': false,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
        'profilePictureURL': '',
      });

      // Create placeholder lawyerProfiles document
      await _firestore.collection('lawyerProfiles').doc(user.uid).set({
        'userId': user.uid,
        'fullName': '',
        'cnic': '',
        'yearsOfExperience': 0,
        'barCouncil': '',
        'licenseNumber': '',
        'licenseCardFrontURL': '',
        'licenseCardBackURL': '',
        'selfieWithLicenseURL': '',
        'verificationStatus': 'pending',
        'verifiedAt': null,
        'verifiedBy': null,
        'rejectionReason': null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Account created! Complete your profile.')),
      );

      // Navigate to Profile Setup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LawyerProfileSetupScreen(userId: user.uid)),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Registration failed.';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Social button widget
  Widget _buildSocialButton(
      String text, String imagePath, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 20,
              width: 20,
            ),
            const SizedBox(width: 10),
            Text(text, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // Text Field Widget
  Widget _buildTextField({
    required String hintText,
    bool isPassword = false,
    TextEditingController? controller,
    TextInputType? keyboardType,
  }) {
    final Color primaryBorderColor = Colors.grey.shade400;

    final OutlineInputBorder commonBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: primaryBorderColor, width: 1.0),
    );

    return TextField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: commonBorder,
        enabledBorder: commonBorder,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryMaroon, width: 2.0),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: _togglePasswordVisibility,
              )
            : null,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Sign Up', style: TextStyle(color: Colors.black)),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ZAKOOTA LOGO
            SizedBox(
              height: 150,
              width: 150,
              child: Image.asset(
                'assets/intro4.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Create your lawyer account',
              style: TextStyle(fontSize: 18, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // GOOGLE BUTTON
            _buildSocialButton(
              'Sign up with Google',
              'assets/g.png',
              _isLoading ? null : _signInWithGoogle,
            ),
            const SizedBox(height: 15),

            // FACEBOOK BUTTON
            _buildSocialButton(
              'Sign up with Facebook',
              'assets/f.png',
              null, // Not implemented yet
            ),
            const SizedBox(height: 20),
            const Text('or', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 20),

            // Form Fields
            _buildTextField(hintText: 'Full Name', controller: nameController),
            const SizedBox(height: 15),
            _buildTextField(
              hintText: 'Email',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            _buildTextField(
              hintText: 'Phone Number',
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 15),
            _buildTextField(
              hintText: 'Password',
              isPassword: true,
              controller: passwordController,
            ),
            const SizedBox(height: 30),

            // Sign Up Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _registerLawyer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryMaroon,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Sign Up', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 20),

            // Login Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?',
                    style: TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryMaroon),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
