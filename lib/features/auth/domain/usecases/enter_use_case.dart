import '../repositories/auth_repository.dart';

class EnterUseCase {
  EnterUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<void> call() {
    return _authRepository.enter();
  }
}
