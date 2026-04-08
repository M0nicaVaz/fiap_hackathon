import '../repositories/auth_repository.dart';
import '../../../../core/result/result.dart';

class SignOutUseCase {
  SignOutUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<Result<void>> call() {
    return _authRepository.signOut();
  }
}
