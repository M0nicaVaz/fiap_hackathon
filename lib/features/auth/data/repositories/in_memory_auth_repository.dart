import '../../domain/repositories/auth_repository.dart';

class InMemoryAuthRepository implements AuthRepository {
  bool _isSignedIn = false;

  @override
  bool get isSignedIn => _isSignedIn;

  @override
  Future<void> enter() async {
    _isSignedIn = true;
  }

  @override
  Future<void> signOut() async {
    _isSignedIn = false;
  }
}
