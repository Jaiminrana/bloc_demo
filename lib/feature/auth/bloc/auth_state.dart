import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:self/feature/auth/data/models/user_model.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatusEnum.initial) AuthStatusEnum status,
    String? errorMessage,
    UserModel? user,
  }) = _AuthState;
}

enum AuthStatusEnum {
  initial,
  loading,
  authenticated,
  unauthenticated,
  failure,
}
