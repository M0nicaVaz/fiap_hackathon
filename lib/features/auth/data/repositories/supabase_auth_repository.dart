import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client);

  final SupabaseClient _client;

  @override
  bool get isSignedIn => _client.auth.currentUser != null;

  @override
  UserProfile? get currentUser => _mapUser(_client.auth.currentUser);

  @override
  Stream<UserProfile?> get authStateChanges {
    return _client.auth.onAuthStateChange.map(
      (event) => _mapUser(event.session?.user),
    );
  }

  @override
  Future<Result<void>> enter({
    required String email,
    required String password,
  }) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
      return const Success<void>(null);
    } catch (error, stackTrace) {
      return FailureResult(FailureMapper.fromException(error, stackTrace));
    }
  }

  @override
  Future<Result<void>> register({
    required String email,
    required String password,
  }) async {
    try {
      await _client.auth.signUp(email: email, password: password);
      return const Success<void>(null);
    } catch (error, stackTrace) {
      return FailureResult(FailureMapper.fromException(error, stackTrace));
    }
  }

  @override
  Future<Result<void>> enterWithGoogle() async {
    try {
      await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: kIsWeb
            ? Uri.base.origin
            : 'https://vmyacifgkzsefkitjzuk.supabase.co/auth/v1/callback',
      );
      return const Success<void>(null);
    } catch (error, stackTrace) {
      return FailureResult(FailureMapper.fromException(error, stackTrace));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _client.auth.signOut();
      return const Success<void>(null);
    } catch (error, stackTrace) {
      return FailureResult(FailureMapper.fromException(error, stackTrace));
    }
  }

  UserProfile? _mapUser(User? user) {
    if (user == null) return null;
    return UserProfile(
      uid: user.id,
      email: user.email ?? '',
      displayName:
          user.userMetadata?['full_name'] as String? ??
          user.userMetadata?['name'] as String?,
      photoUrl: user.userMetadata?['avatar_url'] as String?,
    );
  }
}
