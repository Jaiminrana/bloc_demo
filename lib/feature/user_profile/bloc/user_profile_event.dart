import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:self/feature/user_profile/data/models/user_profile_model.dart';

part 'user_profile_event.freezed.dart';

@freezed
sealed class UserProfileEvent with _$UserProfileEvent {
  const factory UserProfileEvent.fetchUser(int userId) = FetchUser;

  const factory UserProfileEvent.updateUser({
    required UserProfileModel updatedUser,
  }) = UpdateUser;
}
