import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../features/auth/domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../dtos/user_profile_dto.dart';

class SupabaseProfileRepository implements ProfileRepository {
  SupabaseProfileRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<UserProfile?> getProfile(String uid) async {
    final row = await _client
        .from('profiles')
        .select()
        .eq('id', uid)
        .maybeSingle();
    if (row == null) return null;
    final email = _client.auth.currentUser?.email ?? '';
    return UserProfileDto.fromRow(row, email: email);
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    await _client.from('profiles').upsert(UserProfileDto.toRow(profile));
  }
}
