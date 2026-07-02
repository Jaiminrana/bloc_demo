import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';
@freezed
sealed class AuthEvent with _$AuthEvent {
  const factory AuthEvent.loginSubmitted({
    required String username,
    required String password,
  }) = LoginSubmitted;

  const factory AuthEvent.logoutRequested() = LogoutRequested;

  const factory AuthEvent.checkAuthStatus() = CheckAuthStatus;

  const factory AuthEvent.refreshToken() = RefreshToken;
}