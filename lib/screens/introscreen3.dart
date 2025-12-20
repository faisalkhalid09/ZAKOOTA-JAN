import 'package:flutter/material.dart';
import 'package:zakoota/utils/app_colors.dart' as app_colors; // 🔹 Prefix added
import '../widgets/custombuttons.dart';
import 'roleselection_screen.dart';

class IntroScreen3 extends StatelessWidget {
  const IntroScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_colors.AppColors.backgroundColor, // 🔹 Prefix used
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔹 Intro Image
              Image.asset(
                'assets/intro3.png', // <-- apni image ka naam lagao
                height: 250,
              ),
              const SizedBox(height: 40),

              // 🔹 Heading
              const Text(
                "Get Legal Help Easily!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF600000),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                "Connect with professional lawyers anytime, anywhere.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 60),

              // 🔹 Continue Button
              CustomButton(
                text: "Continue",
                onTap: () {
                  print("Continue Pressed ✅");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const RoleSelectionScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
