import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/result/result.dart';

class InMemoryAuthRepository implements AuthRepository {
  bool _isSignedIn = false;

  @override
  bool get isSignedIn => _isSignedIn;

  @override
  UserProfile? get currentUser => _isSignedIn
      ? const UserProfile(uid: 'debug', email: 'debug@debug.com')
      : null;

  @override
  Stream<UserProfile?> get authStateChanges => const Stream.empty();

  @override
  Future<Result<void>> enter({
    required String email,
    required String password,
  }) async {
    _isSignedIn = true;
    return const Success<void>(null);
  }

  @override
  Future<Result<void>> register({
    required String email,
    required String password,
  }) async {
    _isSignedIn = true;
    return const Success<void>(null);
  }

  @override
  Future<Result<void>> enterWithGoogle() async {
    _isSignedIn = true;
    return const Success<void>(null);
  }

  @override
  Future<Result<void>> signOut() async {
    _isSignedIn = false;
    return const Success<void>(null);
  }
}
