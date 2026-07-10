import 'package:bloc/bloc.dart';
import 'package:self/feature/user_profile/cubit/user_edit_form/user_edit_form_state.dart';

class UserEditFormCubit extends Cubit<UserEditFormState> {
  UserEditFormCubit() : super(const UserEditFormState());

  bool get isDirty =>
      state.name != state.originalName || state.email != state.originalEmail;

  void initialized(String name, String email) {
    emit(
      state.copyWith(
        name: name,
        email: email,
        originalName: name,
        originalEmail: email,
        canSubmit: false,
      ),
    );
  }

  void nameChange(String value) {
    final error = _validateName(value);

    emit(
      state.copyWith(
        name: value,
        nameError: error,
        canSubmit: _canSubmit(name: value, email: state.email),
      ),
    );
  }

  void emailChanged(String value) {
    final error = _validateEmail(value);

    emit(
      state.copyWith(
        email: value,
        emailError: error,
        canSubmit: _canSubmit(name: state.name, email: value),
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'First name is required';
    }

    if (value.trim().length < 3) {
      return 'Minimum 3 characters';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final regex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!regex.hasMatch(value)) {
      return 'Invalid email';
    }

    return null;
  }

  bool _canSubmit({String? name, String? email}) {
    return _validateName(name) == null && _validateEmail(email) == null;
  }
}
