import '../entities/user_profile.dart';
import '../../../../core/result/result.dart';

abstract interface class AuthRepository {
  bool get isSignedIn;

  UserProfile? get currentUser;

  Stream<UserProfile?> get authStateChanges;

  Future<Result<void>> enter({required String email, required String password});

  Future<Result<void>> register({
    required String email,
    required String password,
  });

  Future<Result<void>> enterWithGoogle();

  Future<Result<void>> signOut();
}
