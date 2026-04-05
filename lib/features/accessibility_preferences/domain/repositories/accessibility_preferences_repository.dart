import '../entities/accessibility_settings.dart';

abstract interface class AccessibilityPreferencesRepository {
  AccessibilitySettings loadSettings();

  Future<void> saveSettings(AccessibilitySettings settings);
}
