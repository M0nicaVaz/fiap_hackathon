import '../entities/user_profile.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  GetCurrentUserUseCase(this._authRepository);

  final AuthRepository _authRepository;

  UserProfile? call() => _authRepository.currentUser;
}
