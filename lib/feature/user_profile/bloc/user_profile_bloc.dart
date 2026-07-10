import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:self/core/errors/app_exception.dart';
import 'package:self/feature/user_profile/bloc/user_profile_event.dart';
import 'package:self/feature/user_profile/bloc/user_profile_state.dart';
import 'package:self/feature/user_profile/data/repository/user_profile_repository.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserProfileRepository _repository;

  UserProfileBloc(this._repository)
    : super(UserProfileState(status: UserStatus.initial)) {
    on<FetchUser>(_fetchUser);
    on<UpdateUser>(_updateUser);
  }

  Future<void> _fetchUser(
    FetchUser event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(state.copyWith(status: UserStatus.loading));

    try {
      final user = await _repository.fetchUser(event.userId);
      emit(state.copyWith(status: UserStatus.loaded, user: user));
    } on AppException catch (e) {
      emit(state.copyWith(status: UserStatus.failure, failure: e.failure));
    }
  }

  Future<void> _updateUser(
    UpdateUser event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(state.copyWith(status: UserStatus.updating));

    try {
      final user = await _repository.updateUser(event.updatedUser);
      emit(state.copyWith(status: UserStatus.loaded, user: user));
    } on AppException catch (e) {
      emit(state.copyWith(status: UserStatus.failure, failure: e.failure));
    }
  }
}
