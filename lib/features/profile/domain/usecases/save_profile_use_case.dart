import '../../../auth/domain/entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class SaveProfileUseCase {
  SaveProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<void> call(UserProfile profile) => _repository.saveProfile(profile);
}
