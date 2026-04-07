import '../../../auth/domain/entities/user_profile.dart';
import '../../../accessibility_preferences/domain/entities/accessibility_settings.dart';

abstract interface class ProfileRepository {
  Future<UserProfile?> getProfile(String uid);

  Future<void> saveProfile(UserProfile profile);

  Future<AccessibilitySettings?> getAccessibilitySettings(String uid);

  Future<void> saveAccessibilitySettings(
    String uid,
    AccessibilitySettings settings,
  );
}
