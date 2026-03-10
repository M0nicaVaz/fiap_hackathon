import 'package:flutter/material.dart';

class AppTypography {
  final String fontFamily;
  final double caption;
  final double label;
  final double bodyMedium;
  final double bodyLarge;
  final double headingMedium;
  final double headingLarge;
  final double display;
  final FontWeight regular;
  final FontWeight semiBold;
  final FontWeight bold;
  final double lineHeight;
  final double letterSpacing;

  const AppTypography({
    required this.fontFamily,
    required this.caption,
    required this.label,
    required this.bodyMedium,
    required this.bodyLarge,
    required this.headingMedium,
    required this.headingLarge,
    required this.display,
    required this.regular,
    required this.semiBold,
    required this.bold,
    required this.lineHeight,
    required this.letterSpacing,
  });
}
