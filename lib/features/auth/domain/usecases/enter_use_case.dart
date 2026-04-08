import '../repositories/auth_repository.dart';
import '../../../../core/result/result.dart';

class EnterUseCase {
  EnterUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<Result<void>> call({required String email, required String password}) {
    return _authRepository.enter(email: email, password: password);
  }
}
