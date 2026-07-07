import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:self/feature/auth/bloc/auth_event.dart';
import 'package:self/feature/auth/bloc/auth_state.dart';
import 'package:self/feature/auth/data/models/login_request_model.dart';
import 'package:self/feature/auth/data/repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.authRepository)
    : super(AuthState(status: AuthStatusEnum.initial)) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutRequested>(_onLogoutRequest);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<RefreshToken>(_onRefreshToken);

    add(const AuthEvent.checkAuthStatus());
  }

  final AuthRepository authRepository;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatusEnum.loading, errorMessage: null));
    try {
      final user = await authRepository.login(
        LoginRequestModel(username: event.username, password: event.password),
      );

      emit(
        state.copyWith(
          status: AuthStatusEnum.authenticated,
          user: user,
          errorMessage: null,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          status: AuthStatusEnum.failure,
          user: null,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatusEnum.failure,
          user: null,
          errorMessage: 'Something went wrong.',
        ),
      );
    }
  }

  FutureOr<void> _onLogoutRequest(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthStatusEnum.loading,
        user: null,
        errorMessage: null,
      ),
    );
    await Future.delayed(Duration(milliseconds: 3000));
    await authRepository.logout();

    emit(
      state.copyWith(
        status: AuthStatusEnum.unauthenticated,
        user: null,
        errorMessage: null,
      ),
    );
  }

  FutureOr<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    final user = await authRepository.checkAuthStatus();

    user != null
        ? emit(state.copyWith(status: AuthStatusEnum.authenticated))
        : emit(
            state.copyWith(status: AuthStatusEnum.unauthenticated, user: null),
          );
  }

  FutureOr<void> _onRefreshToken(RefreshToken event, Emitter<AuthState> emit) {}
}
