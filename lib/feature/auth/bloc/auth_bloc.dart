import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:self/core/errors/app_exception.dart';
import 'package:self/core/errors/failure_message_mapper.dart';
import 'package:self/core/errors/failures.dart';
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
        LoginRequestModel(
          username: event.username,
          password: event.password,
          expiresInMins: 1,
        ),
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
    } on AppException catch (e) {
      emit(
        state.copyWith(
          status: AuthStatusEnum.failure,
          user: null,
          errorMessage: '${e.failure}',
          // errorMessage: 'Something went wrong.',
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

    try {
      await authRepository.logout();
      emit(
        state.copyWith(
          status: AuthStatusEnum.unauthenticated,
          user: null,
          errorMessage: null,
        ),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(
          user: null,
          errorMessage: FailureMessageMapper.map(e.failure),
        ),
      );
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final sessionExist = await authRepository.hasSession();

      if (!sessionExist) {
        throw AppException(const UnAuthorizedFailure());
      }

      emit(state.copyWith(status: AuthStatusEnum.authenticated));

      await authRepository.validateSession();
    } catch (e) {
      if (e is AppException && e.failure is UnAuthorizedFailure) {
        emit(
          state.copyWith(status: AuthStatusEnum.unauthenticated, user: null),
        );
      }
    }
  }

  FutureOr<void> _onRefreshToken(RefreshToken event, Emitter<AuthState> emit) {}
}
