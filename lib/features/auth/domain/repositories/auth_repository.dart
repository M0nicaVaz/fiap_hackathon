import '../entities/user_profile.dart';

abstract interface class AuthRepository {
  bool get isSignedIn;

  UserProfile? get currentUser;

  Stream<UserProfile?> get authStateChanges;

  Future<void> enter({required String email, required String password});

  Future<void> enterWithGoogle();

  Future<void> signOut();
}
