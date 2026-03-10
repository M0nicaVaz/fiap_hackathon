class AccessibilityScale {
  final double fontScale;
  final double uiScale;

  const AccessibilityScale({required this.fontScale, required this.uiScale});
}

AccessibilityScale scaleFromFont(double fontScale) {
  final uiScale = 1 + ((fontScale - 1) * 0.5);

  return AccessibilityScale(fontScale: fontScale, uiScale: uiScale);
}
