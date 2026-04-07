import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../features/accessibility_preferences/domain/entities/accessibility_settings.dart';
import '../../../../features/auth/domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../dtos/accessibility_settings_dto.dart';
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
    await _client
        .from('profiles')
        .upsert(UserProfileDto.toRow(profile));
  }

  @override
  Future<AccessibilitySettings?> getAccessibilitySettings(String uid) async {
    final row = await _client
        .from('accessibility_settings')
        .select()
        .eq('user_id', uid)
        .maybeSingle();
    if (row == null) return null;
    return AccessibilitySettingsDto.fromRow(row);
  }

  @override
  Future<void> saveAccessibilitySettings(
    String uid,
    AccessibilitySettings settings,
  ) async {
    await _client
        .from('accessibility_settings')
        .upsert(AccessibilitySettingsDto.toRow(uid, settings));
  }
}
