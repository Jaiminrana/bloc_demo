import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:self/core/errors/failure.dart';
import 'package:self/feature/user_profile/data/models/user_profile_model.dart';

part 'user_profile_state.freezed.dart';

@freezed
abstract class UserProfileState with _$UserProfileState {
  const factory UserProfileState({
    @Default(UserStatus.initial) UserStatus status,
    UserProfileModel? user,
    Failure? failure,
  }) = _UserProfileState;
}

enum UserStatus { initial, loading, loaded, updating, failure }
