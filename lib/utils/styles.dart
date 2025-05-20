import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF0077B6);
  static const accent = Color(0xFF00B4D8);
  static const background = Color(0xFFF0F4F8);
  static const textPrimary = Color(0xFF023047);
  static const textSecondary = Color(0xFF6C757D);
  static const inputFill = Color(0xFFE9EEF4);
  static const error = Color(0xFFEF476F);
}

class AppTextStyles {
  static const header = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 1.2,
  );
  static const label = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );
  static const inputText = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );
  static const button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const snackBar = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}

class AppRadius {
  static const radius12 = BorderRadius.all(Radius.circular(12));
  static const radius20 = BorderRadius.all(Radius.circular(20));
}
