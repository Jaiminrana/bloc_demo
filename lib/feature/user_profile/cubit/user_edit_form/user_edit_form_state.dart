import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_edit_form_state.freezed.dart';

@freezed
abstract class UserEditFormState with _$UserEditFormState {
  const factory UserEditFormState({
    String? name,
    String? email,
    String? originalName,
    String? originalEmail,
    String? nameError,
    String? emailError,

    @Default(false) bool canSubmit,
  }) = _UserEditFormState;
}
