import '../entities/accessibility_settings.dart';
import '../repositories/accessibility_preferences_repository.dart';

class LoadAccessibilitySettingsUseCase {
  LoadAccessibilitySettingsUseCase(this._repository);

  final AccessibilityPreferencesRepository _repository;

  AccessibilitySettings call() {
    return _repository.loadSettings();
  }
}
