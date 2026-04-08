import '../entities/accessibility_settings.dart';
import '../repositories/remote_accessibility_preferences_repository.dart';

class LoadRemoteAccessibilitySettingsUseCase {
  LoadRemoteAccessibilitySettingsUseCase(this._repository);

  final RemoteAccessibilityPreferencesRepository _repository;

  Future<AccessibilitySettings?> call(String uid) {
    return _repository.getAccessibilitySettings(uid);
  }
}
