import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package
import '../utils/app_colors.dart';
import '../services/google_sign_in_service.dart';
import 'login_screen.dart';

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
  final TextEditingController addressController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignInService _googleSignInService = GoogleSignInService();

  bool _isLoading = false;
  bool isLawyerSelected = true;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    addressController.dispose();
    experienceController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  // 🚀 Google Sign-In Logic for Lawyers
  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      // Sign in with Google
      final UserCredential? userCredential =
          await _googleSignInService.signInWithGoogle();

      // If user cancelled the sign-in
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

      // Check if user already exists in Firestore
      final docSnapshot =
          await _firestore.collection('lawyers').doc(user.uid).get();

      if (docSnapshot.exists) {
        // User already registered, redirect to login
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

      // Extract name from Google account
      final displayName = user.displayName ?? '';

      // Save new lawyer data to Firestore with basic info
      // Note: Phone, address, and experience can be added later via profile completion
      await _firestore.collection('lawyers').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email ?? '',
        'fullName': displayName,
        'phone': '', // Can be updated later
        'address': '', // Can be updated later
        'experience': '', // Can be updated later
        'userType': 'Lawyer',
        'authProvider': 'Google',
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Lawyer registered via Google: ${user.uid}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Google Sign-In successful! Redirecting to Login.')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // 🚀 Registration aur Firestore Data Saving Logic (Collection 'lawyers' updated)
  Future<void> _registerLawyer() async {
    setState(() => _isLoading = true);

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final fullName = nameController.text.trim();

      if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
        throw Exception("Name, Email, and Password are required.");
      }

      // 1. Firebase Auth Registration
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception("Registration failed, user not created.");
      }

      // 2. 🔑 Firestore Data Save: 'lawyers' collection mein
      await _firestore.collection('lawyers').doc(user.uid).set({
        'uid': user.uid,
        'email': email,
        'fullName': fullName,
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
        'experience': experienceController.text.trim(),
        'userType': 'Lawyer', // Role define kiya gaya
        'createdAt': FieldValue.serverTimestamp(),
      });

      print(
          'Lawyer signed up and data saved to lawyers collection: ${user.uid}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Registration successful! Redirecting to Login.')),
      );

      // Navigator.pushReplacement for clean navigation
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
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

  // 🔹 Social button with image
  Widget _buildSocialButton(String text, String imagePath) {
    return Container(
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
    );
  }

  // Text Field Widget (Same as provided)
  Widget _buildTextField(
      {required String hintText,
      bool isPassword = false,
      TextEditingController? controller}) {
    final Color primaryBorderColor = Colors.grey.shade400;

    final OutlineInputBorder commonBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: primaryBorderColor, width: 1.0),
    );

    return TextField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
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

  // Radio Option Widget (Same as provided)
  Widget _buildRadioOption(
      String label, bool selected, void Function(bool?)? onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<bool>(
          value: true,
          groupValue: selected,
          onChanged: label == 'Lawyer' ? onChanged : null,
          activeColor: primaryMaroon,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Sign Up as Lawyer',
            style: TextStyle(color: Colors.black)),
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
            /// 🔹 ZAKOOTA LOGO IMAGE
            SizedBox(
              height: 200,
              width: 200,
              child: Image.asset(
                'assets/intro4.png',
                fit: BoxFit.contain,
              ),
            ),
            const Text('Create your lawyer account',
                style: TextStyle(fontSize: 18, color: Colors.black54)),
            const SizedBox(height: 30),

            /// 🔹 GOOGLE BUTTON
            GestureDetector(
              onTap: _isLoading ? null : _signInWithGoogle,
              child: _buildSocialButton(
                'Continue with Google',
                'assets/g.png',
              ),
            ),
            const SizedBox(height: 15),

            /// 🔹 FACEBOOK BUTTON
            _buildSocialButton(
              'Continue with Facebook',
              'assets/f.png',
            ),
            const SizedBox(height: 20),
            const Text('or', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 20),

            // Form Fields
            _buildTextField(hintText: 'Full Name', controller: nameController),
            const SizedBox(height: 15),
            _buildTextField(hintText: 'Email', controller: emailController),
            const SizedBox(height: 15),
            _buildTextField(
                hintText: 'Password',
                isPassword: true,
                controller: passwordController),
            const SizedBox(height: 15),
            _buildTextField(
                hintText: 'Phone number', controller: phoneController),
            const SizedBox(height: 15),
            _buildTextField(hintText: 'Address', controller: addressController),
            const SizedBox(height: 15),
            _buildTextField(
                hintText: 'Years of Experience',
                controller: experienceController),
            const SizedBox(height: 20),

            // Step 1: Upload Documents
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Step 1:  Upload Documents',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            // Role Selection
            const Align(
                alignment: Alignment.centerLeft,
                child: Text('Select your role:',
                    style: TextStyle(fontSize: 14, color: Colors.black54))),
            Row(
              children: [
                _buildRadioOption('Client', !isLawyerSelected, null),
                const SizedBox(width: 20),
                _buildRadioOption('Lawyer', isLawyerSelected,
                    (v) => setState(() => isLawyerSelected = true)),
              ],
            ),
            const SizedBox(height: 15),

            // Document Upload Placeholder
            _buildTextField(
                hintText: 'Upload Your Bar Council License (Optional)',
                controller: null),

            const SizedBox(height: 30),

            // Bottom Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Join Zakoota',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryMaroon),
                ),
                const SizedBox(height: 8),
                const Text(
                  'By continuing, you agree to Zakoota’s terms of use and acknowledge our privacy policy.',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Make sure your bar council license details are valid and up to date.',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Register Button
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
                    : const Text('Register and continue',
                        style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
