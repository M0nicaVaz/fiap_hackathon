import '../repositories/auth_repository.dart';
import '../../../../core/result/result.dart';

class EnterWithGoogleUseCase {
  EnterWithGoogleUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<Result<void>> call() {
    return _authRepository.enterWithGoogle();
  }
}
