import 'package:flutter/material.dart';

class VoworaValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address.';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password.';
    }
    if (value.length < 8) {
      return 'Password must contain at least 8 characters.';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter.';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter.';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number.';
    }
    return null;
  }

  static String? validateLoginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password.';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password.';
    }
    if (value != originalPassword) {
      return 'Passwords do not match.';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number.';
    }
    if (value.trim().length < 6) {
      return 'Please enter a valid phone number.';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName.';
    }
    return null;
  }

  // Returns strength info: double score (0.0 to 1.0), String label, Color color
  static PasswordStrength getPasswordStrength(String password) {
    if (password.isEmpty) {
      return PasswordStrength(score: 0.0, label: 'Weak', color: Colors.grey);
    }
    int scorePoints = 0;
    if (password.length >= 8) scorePoints++;
    if (RegExp(r'[A-Z]').hasMatch(password)) scorePoints++;
    if (RegExp(r'[a-z]').hasMatch(password)) scorePoints++;
    if (RegExp(r'[0-9]').hasMatch(password)) scorePoints++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) scorePoints++;

    if (scorePoints <= 2) {
      return PasswordStrength(score: 0.33, label: 'Weak', color: Colors.redAccent);
    } else if (scorePoints <= 4) {
      return PasswordStrength(score: 0.66, label: 'Medium', color: Colors.amber);
    } else {
      return PasswordStrength(score: 1.0, label: 'Strong', color: Colors.green);
    }
  }
}

class PasswordStrength {
  final double score;
  final String label;
  final Color color;

  PasswordStrength({
    required this.score,
    required this.label,
    required this.color,
  });
}
