import '../repositories/auth_repository.dart';

class CheckSessionUseCase {
  CheckSessionUseCase(this._authRepository);

  final AuthRepository _authRepository;

  bool call() {
    return _authRepository.isSignedIn;
  }
}
