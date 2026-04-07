import '../../../accessibility_preferences/domain/entities/accessibility_settings.dart';
import '../repositories/profile_repository.dart';

class LoadAccessibilityFromSupabaseUseCase {
  LoadAccessibilityFromSupabaseUseCase(this._repository);

  final ProfileRepository _repository;

  Future<AccessibilitySettings?> call(String uid) =>
      _repository.getAccessibilitySettings(uid);
}
