import '../repositories/auth_repository.dart';

class EnterWithGoogleUseCase {
  EnterWithGoogleUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<void> call() {
    return _authRepository.enterWithGoogle();
  }
}
