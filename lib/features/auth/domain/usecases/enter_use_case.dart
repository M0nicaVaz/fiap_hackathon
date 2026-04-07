import '../repositories/auth_repository.dart';

class EnterUseCase {
  EnterUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<void> call({required String email, required String password}) {
    return _authRepository.enter(email: email, password: password);
  }
}
