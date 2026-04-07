import '../../../auth/domain/entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  GetProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<UserProfile?> call(String uid) => _repository.getProfile(uid);
}
