import '../../../accessibility_preferences/domain/entities/accessibility_settings.dart';
import '../repositories/profile_repository.dart';

class SyncAccessibilityToSupabaseUseCase {
  SyncAccessibilityToSupabaseUseCase(this._repository);

  final ProfileRepository _repository;

  Future<void> call(String uid, AccessibilitySettings settings) =>
      _repository.saveAccessibilitySettings(uid, settings);
}
