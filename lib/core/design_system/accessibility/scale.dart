class AccessibilityScale {
  final double fontScale;
  final double uiScale;

  const AccessibilityScale({required this.fontScale, required this.uiScale});
}

AccessibilityScale scaleFromFont(double fontScale) {
  final clampedFont = fontScale.clamp(0.8, 1.8).toDouble();

  final uiScale = 1 + ((clampedFont - 1) * 0.5);

  return AccessibilityScale(
    fontScale: clampedFont,
    uiScale: uiScale.clamp(1.0, 1.4),
  );
}
