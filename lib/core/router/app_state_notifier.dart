import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:self/feature/auth/bloc/auth_bloc.dart';
import 'package:self/feature/auth/bloc/auth_state.dart';
import 'package:self/feature/splash/bloc/splash_bloc.dart';
import 'package:self/feature/splash/bloc/splash_state.dart';

class AppStateNotifier extends ChangeNotifier {
  final AuthBloc authBloc;
  final SplashBloc splashBloc;

  late final StreamSubscription<AuthState> _authSubscription;
  late final StreamSubscription<SplashState> _splashSubscription;

  AppStateNotifier(this.authBloc, this.splashBloc) {
    _splashSubscription = splashBloc.stream.listen((_) {
      notifyListeners();
    });
    _authSubscription = authBloc.stream.listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    _splashSubscription.cancel();
    super.dispose();
  }
}
