import '../entities/user_profile.dart';
import '../repositories/auth_repository.dart';

class WatchAuthStateUseCase {
  WatchAuthStateUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Stream<UserProfile?> call() => _authRepository.authStateChanges;
}
