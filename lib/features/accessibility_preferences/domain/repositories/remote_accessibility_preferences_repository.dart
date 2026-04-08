import '../entities/accessibility_settings.dart';

abstract interface class RemoteAccessibilityPreferencesRepository {
  Future<AccessibilitySettings?> getAccessibilitySettings(String uid);

  Future<void> saveAccessibilitySettings(
    String uid,
    AccessibilitySettings settings,
  );
}
