import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/accessibility_settings.dart';
import '../../domain/repositories/remote_accessibility_preferences_repository.dart';
import '../dtos/remote_accessibility_settings_dto.dart';

class SupabaseRemoteAccessibilityPreferencesRepository
    implements RemoteAccessibilityPreferencesRepository {
  SupabaseRemoteAccessibilityPreferencesRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<AccessibilitySettings?> getAccessibilitySettings(String uid) async {
    final row = await _client
        .from('accessibility_settings')
        .select()
        .eq('user_id', uid)
        .maybeSingle();
    if (row == null) return null;
    return RemoteAccessibilitySettingsDto.fromRow(row);
  }

  @override
  Future<void> saveAccessibilitySettings(
    String uid,
    AccessibilitySettings settings,
  ) async {
    await _client
        .from('accessibility_settings')
        .upsert(RemoteAccessibilitySettingsDto.toRow(uid, settings));
  }
}
