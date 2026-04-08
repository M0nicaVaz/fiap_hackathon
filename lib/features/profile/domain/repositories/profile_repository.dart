import '../../../auth/domain/entities/user_profile.dart';

abstract interface class ProfileRepository {
  Future<UserProfile?> getProfile(String uid);

  Future<void> saveProfile(UserProfile profile);
}
