abstract interface class AuthRepository {
  bool get isSignedIn;

  Future<void> enter();

  Future<void> signOut();
}
