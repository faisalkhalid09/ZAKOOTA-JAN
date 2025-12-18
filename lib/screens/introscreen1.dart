import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custombuttons.dart';
import '../utils/app_colors.dart' as app_colors;
import 'roleselection_screen.dart';

class IntroScreen1 extends StatefulWidget {
  const IntroScreen1({super.key});

  @override
  State<IntroScreen1> createState() => _IntroScreen1State();
}

class _IntroScreen1State extends State<IntroScreen1> {
  final PageController _controller = PageController();

  Future<void> _completeIntro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenIntro', true);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const RoleSelectionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_colors.AppColors.backgroundColor, // 🔹 Prefix used
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 🔹 PageView for intro slides
            PageView(
              controller: _controller,
              children: const [
                IntroPage(
                  image: 'assets/intro1.png',
                  title: 'Easy to Hire',
                  subtitle:
                      'Find and hire professional lawyers easily with Zakoota App.',
                ),
                IntroPage(
                  image: 'assets/intro2.png',
                  title: 'Easy Payments',
                  subtitle:
                      'Make secure online payments to your lawyer anytime, anywhere.',
                ),
                IntroPage(
                  image: 'assets/intro3.png',
                  title: 'Get Legal Help Anytime',
                  subtitle:
                      'Chat and connect with professional lawyers whenever you need.',
                ),
              ],
            ),

            // 🔹 Skip Button
            Positioned(
              top: 20,
              right: 20,
              child: TextButton(
                onPressed: _completeIntro,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: app_colors.AppColors.primaryColor, // 🔹 Prefix used
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            // 🔹 Bottom Indicator + Next Button
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: app_colors.AppColors.primaryColor, // 🔹 Prefix used
                      dotColor: Colors.grey,
                      dotHeight: 10,
                      dotWidth: 10,
                      expansionFactor: 3,
                      spacing: 8,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Centered Compact Next Button
                  Center(
                    child: SizedBox(
                      width: 180,
                      child: CustomButton(
                        text: 'Next',
                        onTap: () {
                          final currentPage = _controller.page?.round() ?? 0;

                          if (currentPage == 2) {
                            _completeIntro();
                          } else {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.linear,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IntroPage extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const IntroPage({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: size.height * 0.4, fit: BoxFit.contain),
          const SizedBox(height: 30),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: app_colors.AppColors.primaryColor, // 🔹 Prefix used
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
