import '../repositories/auth_repository.dart';

class RegisterUseCase {
  RegisterUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<void> call({required String email, required String password}) {
    return _authRepository.register(email: email, password: password);
  }
}
