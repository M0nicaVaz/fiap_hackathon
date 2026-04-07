import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';

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
  Future<void> enter({required String email, required String password}) async {
    _isSignedIn = true;
  }

  @override
  Future<void> enterWithGoogle() async {
    _isSignedIn = true;
  }

  @override
  Future<void> signOut() async {
    _isSignedIn = false;
  }
}
