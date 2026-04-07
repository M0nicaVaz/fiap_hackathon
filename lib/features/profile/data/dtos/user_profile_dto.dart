import '../../../auth/domain/entities/user_profile.dart';

class UserProfileDto {
  static UserProfile fromRow(Map<String, dynamic> row, {required String email}) {
    return UserProfile(
      uid: row['id'] as String,
      email: email,
      displayName: row['display_name'] as String?,
      photoUrl: row['photo_url'] as String?,
    );
  }

  static Map<String, dynamic> toRow(UserProfile profile) {
    return {
      'id': profile.uid,
      'display_name': profile.displayName,
      'photo_url': profile.photoUrl,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}
