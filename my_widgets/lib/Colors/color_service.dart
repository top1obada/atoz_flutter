import 'package:flutter/material.dart';

class ColorService {
  ColorService._();

  static Color parseColor(String? hexCode, int? shade) {
    // Default color if parsing fails
    const Color defaultColor = Colors.blue;

    if (hexCode == null || hexCode.isEmpty) return defaultColor;

    try {
      // Remove # if present and parse hex
      String hex = hexCode.replaceFirst('#', '');

      // Handle different hex formats
      if (hex.length == 6) {
        hex = 'FF$hex'; // Add full opacity
      } else if (hex.length != 8) {
        return defaultColor; // Invalid format
      }

      final int colorValue = int.parse(hex, radix: 16);
      final Color baseColor = Color(colorValue);

      // Apply shade adjustment based on integer value
      if (shade != null) {
        final double amount =
            (shade - 500) / 1000.0; // Convert to -0.4 to +0.4 range
        if (amount > 0) {
          return _darkenColor(baseColor, amount.abs());
        } else if (amount < 0) {
          return _lightenColor(baseColor, amount.abs());
        }
      }

      return baseColor;
    } catch (e) {
      return defaultColor;
    }
  }

  static Color _darkenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);

    final HSLColor hsl = HSLColor.fromColor(color);
    final HSLColor darkened = hsl.withLightness(
      (hsl.lightness - amount).clamp(0.0, 1.0),
    );
    return darkened.toColor();
  }

  static Color _lightenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);

    final HSLColor hsl = HSLColor.fromColor(color);
    final HSLColor lightened = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return lightened.toColor();
  }
}
