import '../entities/accessibility_settings.dart';
import '../repositories/remote_accessibility_preferences_repository.dart';

class SyncAccessibilitySettingsUseCase {
  SyncAccessibilitySettingsUseCase(this._repository);

  final RemoteAccessibilityPreferencesRepository _repository;

  Future<void> call(String uid, AccessibilitySettings settings) {
    return _repository.saveAccessibilitySettings(uid, settings);
  }
}
