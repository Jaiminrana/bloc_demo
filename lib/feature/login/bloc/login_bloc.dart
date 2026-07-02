import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:self/feature/login/bloc/login_event.dart';
import 'package:self/feature/login/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    // need to perform login API call
    await Future.delayed(Duration(milliseconds: 100));

    if (true) //success
    {
      emit(state.copyWith(isLoading: false, user: 'Jaimin'));
    } else {
      emit(state.copyWith(isLoading: false, error: 'Login Failed'));
    }
  }
}
