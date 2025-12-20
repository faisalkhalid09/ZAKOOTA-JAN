import 'package:flutter/material.dart';

class AppColors {
  // Maroon Palette
  static const Color maroonDark = Color(0xFF5C0A0A); // Deep maroon for headers
  static const Color maroonPrimary = Color(0xFF800020); // Primary maroon
  static const Color maroonMedium = Color(0xFF9B2D30); // Medium maroon
  static const Color maroonLight =
      Color(0xFFC44E52); // Light maroon for accents
  static const Color maroonVeryLight =
      Color(0xFFF5E8E8); // Very light maroon background

  // Legacy support
  static const Color primaryColor = maroonPrimary;
  static const Color backgroundColor =
      Color(0xFFFAFAFA); // Off-white background
  static const Color textColor = Color(0xFF2D2D2D); // Dark gray text

  // Neutrals
  static const Color white = Colors.white;
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray800 = Color(0xFF424242);

  // Accent Colors
  static const Color green = Color(0xFF2E7D32); // For success/positive
  static const Color red = Color(0xFFD32F2F); // For alerts/decline
  static const Color amber = Color(0xFFF57C00); // For warnings/pending
}
