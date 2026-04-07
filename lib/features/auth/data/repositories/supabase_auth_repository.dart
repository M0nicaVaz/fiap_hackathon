import 'package:supabase_flutter/supabase_flutter.dart';

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
  Future<void> enter({required String email, required String password}) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> enterWithGoogle() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'https://vmyacifgkzsefkitjzuk.supabase.co/auth/v1/callback',
    );
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  UserProfile? _mapUser(User? user) {
    if (user == null) return null;
    return UserProfile(
      uid: user.id,
      email: user.email ?? '',
      displayName: user.userMetadata?['full_name'] as String? ??
          user.userMetadata?['name'] as String?,
      photoUrl: user.userMetadata?['avatar_url'] as String?,
    );
  }
}
