import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF087F73);
  static const Color primaryDark = Color(0xFF05645B);
  static const Color primaryLight = Color(0xFFE6F5F2);

  static const Color background = Color(0xFFF7F9F9);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF172321);
  static const Color textSecondary = Color(0xFF667370);
  static const Color textMuted = Color(0xFF9EA9A6);

  static const Color border = Color(0xFFE1E8E6);
  static const Color borderLight = Color(0xFFF0F4F3);

  static const Color success = Color(0xFF2E8B57);
  static const Color successLight = Color(0xFFEBF7F0);

  static const Color warning = Color(0xFFD99A00);
  static const Color warningLight = Color(0xFFFFF9E6);

  static const Color error = Color(0xFFD64545);
  static const Color errorLight = Color(0xFFFDECEE);

  static const Color info = Color(0xFF3678C8);
  static const Color infoLight = Color(0xFFEBF3FC);

  // UAE Service Brand Accents & Gradients
  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFFFFBF0);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryDark, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF034A43), Color(0xFF087F73), Color(0xFF0C9B8C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient lightGradient = LinearGradient(
    colors: [Color(0xFFF4FAF8), Color(0xFFE6F5F2)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
