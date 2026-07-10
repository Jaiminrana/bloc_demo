import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:self/feature/splash/bloc/splash_event.dart';
import 'package:self/feature/splash/bloc/splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashState()) {
    on<SplashStarted>(_onSplashStarted);
  }

  Future<void> _onSplashStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    await Future.delayed(Duration(milliseconds: 1000));
    emit(state.copyWith(isCompleted: true));
  }
}
