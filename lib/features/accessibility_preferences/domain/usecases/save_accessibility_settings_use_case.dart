import '../entities/accessibility_settings.dart';
import '../repositories/accessibility_preferences_repository.dart';

class SaveAccessibilitySettingsUseCase {
  SaveAccessibilitySettingsUseCase(this._repository);

  final AccessibilityPreferencesRepository _repository;

  Future<void> call(AccessibilitySettings settings) {
    return _repository.saveSettings(settings);
  }
}
