// Path: screens/payments_screen.dart

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/app_nav_bar.dart'; // Navigation ke liye zaroori

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  // Dropdown ke liye default value
  String? _selectedCurrency = 'USD';
  final List<String> _currencies = ['USD', 'PKR', 'EUR', 'GBP'];

  final Color primaryMaroon = AppColors.primaryColor;
  final Color backgroundColor = const Color(0xFFF7F7F7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        // Screenshot ke mutabiq maroon background
        backgroundColor: primaryMaroon,
        elevation: 0,
        title: const Text(
          'Payment & financial',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Payment Methods Section ---
            const Text(
              'Payment Methods',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),

            // Add Payment Method Button
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Add Payment Method functionality
              },
              icon: Icon(Icons.add, color: primaryMaroon),
              label: Text(
                'Add Payment Method',
                style: TextStyle(color: primaryMaroon, fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              ),
            ),

            // Note: Placeholder for payment methods list (can be added later)
            const SizedBox(height: 40),
            
            // --- Finance Settings Section ---
            const Text(
              'Finance Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),

            // Currency Dropdown
            const Text(
              'My Currency',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCurrency,
                  icon: Icon(Icons.keyboard_arrow_down, color: primaryMaroon),
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCurrency = newValue;
                    });
                  },
                  items: _currencies.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            
            const SizedBox(height: 30),

            // Save Setting Button
            SizedBox(
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Save settings functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryMaroon, // Maroon background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  elevation: 5,
                ),
                child: const Text(
                  'Save Setting',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),

      // 🔑 Bottom Navigation Bar
      // Assuming Payments is the 5th icon (More/Menu) based on the image bar
      bottomNavigationBar: AppNavBar(
        currentIndex: 4, // Ya jo bhi index Payments screen ke liye ho
        context: context,
      ),
    );
  }
}