// Path: screens/rating_feedback_screen.dart

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class RatingFeedbackScreen extends StatefulWidget {
  const RatingFeedbackScreen({super.key});

  @override
  State<RatingFeedbackScreen> createState() => _RatingFeedbackScreenState();
}

class _RatingFeedbackScreenState extends State<RatingFeedbackScreen> {
  final Color primaryMaroon = AppColors.primaryColor;
  int _currentRating = 0;
  
  // List of feedback tags (Must be State variable to handle selection if needed, but here just for UI)
  final List<String> feedbackTags = [
    'Professional',
    'knowledgable',
    'Affordable',
    'Responsive',
    'Would hire again'
  ];

  // 🛠️ Star Rating Widget
  Widget _buildStar(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentRating = index;
        });
      },
      child: Icon(
        index <= _currentRating ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: 30,
      ),
    );
  }

  // 🛠️ Feedback Tag Widget
  Widget _buildFeedbackTag(String tag) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(tag, style: const TextStyle(fontSize: 14, color: Colors.black87)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Slightly off-white background
      appBar: AppBar(
        title: const Text('Rating & Feedback', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryMaroon,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Lawyer Profile Card (Matching image_61f8f6.png)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Lawyer Image
                  const CircleAvatar(
                    radius: 40,
                    // Replace with actual image asset path
                    backgroundImage: AssetImage('assets/lawyer_placeholder.png'),
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(width: 15),
                  // Lawyer Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Dr. Ravini Chilok',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        Row(
                          children: [
                            const Text('Criminal Civil',
                                style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 5),
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const Text('3.6', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                        const Text('Pakistan, Lahore',
                            style: TextStyle(color: Colors.grey, fontSize: 14)),
                        const SizedBox(height: 10),
                        // Rate Stars
                        Row(
                          children: [
                            const Text('Rate:', style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 5),
                            ...List.generate(5, (index) => _buildStar(index + 1)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 2. Feedback Text Field
            const Text(
              'Tell us about your experience',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextFormField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Write your feedback here.....',
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 30),

            // 3. Improvement Tags
            const Center(
              child: Text(
                'Where can we improve?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 15),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8.0, // horizontal spacing
              runSpacing: 4.0, // vertical spacing
              children: feedbackTags.map((tag) => _buildFeedbackTag(tag)).toList(),
            ),
            const SizedBox(height: 40),

            // 4. Submit Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement Submit Feedback logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Rating Submitted: $_currentRating stars')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryMaroon,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 5,
                ),
                child: const Text('Submit Feedback',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}