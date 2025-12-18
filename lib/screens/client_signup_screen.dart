// Path: screens/client_signup_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// 🔑 Firestore package import kiya gaya
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/app_colors.dart';
import '../services/google_sign_in_service.dart';
import 'login_screen.dart';

class ClientSignUpScreen extends StatefulWidget {
  const ClientSignUpScreen({super.key});

  @override
  State<ClientSignUpScreen> createState() => _ClientSignUpScreenState();
}

class _ClientSignUpScreenState extends State<ClientSignUpScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _agreedToTerms = false;
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  final Color primaryMaroon = AppColors.primaryColor;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // 🔑 Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // 🔑 Google Sign-In service
  final GoogleSignInService _googleSignInService = GoogleSignInService();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  // 🚀 Google Sign-In Logic
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
          await _firestore.collection('clients').doc(user.uid).get();

      if (docSnapshot.exists) {
        // User already registered, redirect to login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Account already exists. Redirecting to Login.')),
        );
        _navigateToLogin();
        return;
      }

      // Extract name from Google account
      final displayName = user.displayName ?? '';
      final nameParts = displayName.split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
      final lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      // Save new client data to Firestore
      await _firestore.collection('clients').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email ?? '',
        'firstName': firstName,
        'lastName': lastName,
        'userType': 'Client',
        'authProvider': 'Google',
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Client registered via Google: ${user.uid}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Google Sign-In successful! Redirecting to Login.')),
      );

      _navigateToLogin();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // 🚀 Registration aur Firestore Data Saving Logic
  Future<void> _registerClient() async {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please agree to the User Agreement and Privacy Policy.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();

      if (email.isEmpty || password.isEmpty || firstName.isEmpty) {
        throw Exception("First Name, Email, and Password are required.");
      }

      // 1. Firebase Auth Registration
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception("Registration failed, user not created.");
      }

      // 2. 🔑 Firestore Data Save: 'clients' collection mein
      await _firestore.collection('clients').doc(user.uid).set({
        'uid': user.uid,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'userType': 'Client', // Role define kiya gaya
        'createdAt': FieldValue.serverTimestamp(),
        // Aap yahan aur fields bhi add kar sakte hain
      });

      print("Client Registered and data saved to Firestore: ${user.uid}");

      // Success hone par Login Screen par navigate karen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Registration successful! Redirecting to Login.')),
      );

      _navigateToLogin();
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // 🛠️ _buildInputField function (Same as provided)
  Widget _buildInputField({
    required String hintText,
    TextEditingController? controller,
    bool isPassword = false,
    bool hasEye = false,
    bool isPasswordVisible = false,
    VoidCallback? toggleVisibility,
  }) {
    final Color primaryBorderColor = Colors.grey.shade400;

    final OutlineInputBorder commonBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: primaryBorderColor, width: 1.0),
    );

    return TextField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
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
        suffixIcon: hasEye
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: toggleVisibility,
              )
            : null,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      ),
    );
  }

  // 🔹 Social button with image (Same as provided)
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

  @override
  Widget build(BuildContext context) {
    // UI remains the same
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Sign Up as Client',
          style: TextStyle(color: Color.fromARGB(253, 0, 0, 0)),
        ),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            /// 🔹 ZAKOOTA LOGO IMAGE (Size Increased)
            SizedBox(
              height: 200,
              width: 200,
              child: Image.asset(
                'assets/intro4.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Signing up as a client',
              style:
                  TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
            ),
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
            const Text('or',
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    hintText: 'First Name',
                    controller: _firstNameController,
                    isPasswordVisible: _isPasswordVisible,
                    toggleVisibility: () {},
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInputField(
                    hintText: 'Last Name',
                    controller: _lastNameController,
                    isPasswordVisible: _isPasswordVisible,
                    toggleVisibility: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildInputField(
              hintText: 'Email',
              controller: _emailController,
              isPasswordVisible: _isPasswordVisible,
              toggleVisibility: () {},
            ),
            const SizedBox(height: 15),
            // 🔹 PASSWORD FIELD with Eye Toggle
            _buildInputField(
              hintText: 'Password',
              controller: _passwordController,
              isPassword: true,
              hasEye: true,
              isPasswordVisible: _isPasswordVisible,
              toggleVisibility: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _agreedToTerms,
                  onChanged: (value) {
                    setState(() => _agreedToTerms = value!);
                  },
                  activeColor: primaryMaroon,
                ),
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                          fontSize: 14, color: Color.fromARGB(255, 0, 0, 0)),
                      children: [
                        const TextSpan(text: 'I agree to the ZAKOOTA '),
                        TextSpan(
                          text: 'User Agreement',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryMaroon,
                          ),
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryMaroon,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // 🔹 Join ZAKOOTA Button (Register Button)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _isLoading || !_agreedToTerms ? null : _registerClient,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryMaroon,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Join ZAKOOTA',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            // 🚀 Login Navigation added here
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account? '),
                GestureDetector(
                  onTap: _navigateToLogin,
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryMaroon,
                    ),
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
