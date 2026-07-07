import 'dart:async';

import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:self/core/router/app_state_notifier.dart';
import 'package:self/core/router/route_names.dart';
import 'package:self/feature/auth/bloc/auth_bloc.dart';
import 'package:self/feature/auth/bloc/auth_state.dart';
import 'package:self/feature/auth/presentation/auth_screen.dart';
import 'package:self/feature/home/presentation/home_screen.dart';
import 'package:self/feature/splash/bloc/splash_bloc.dart';
import 'package:self/feature/splash/presentation/splash_screen.dart';

import 'app_routes.dart';

class AppRouter {
  final AuthBloc authBloc;
  final SplashBloc splashBloc;

  late final AppStateNotifier _appStateNotifier;

  late final GoRouter router;

  AppRouter(this.authBloc, this.splashBloc) {
    _appStateNotifier = AppStateNotifier(authBloc, splashBloc);
    router = GoRouter(
      initialLocation: AppRoutes.splash,
      refreshListenable: _appStateNotifier,
      redirect: redirect,
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          name: RouteNames.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          name: RouteNames.login,
          builder: (context, state) => const AuthScreen(),
        ),
        GoRoute(
          path: AppRoutes.home,
          name: RouteNames.home,
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    );
  }

  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    final authState = authBloc.state;
    final splashState = splashBloc.state;

    final isOnSplashScreen = state.matchedLocation == AppRoutes.splash;
    final isOnLoginScreen = state.matchedLocation == AppRoutes.login;

    if (!splashState.isCompleted) {
      return isOnSplashScreen ? null : AppRoutes.splash;
    }

    switch (authState.status) {
      case AuthStatusEnum.loading:
        return null;

      // App is checking authentication
      case AuthStatusEnum.initial:
        return isOnSplashScreen ? null : AppRoutes.splash;
      // User is logged in
      case AuthStatusEnum.authenticated:
        return (isOnLoginScreen || isOnSplashScreen) ? AppRoutes.home : null;

      // User is not logged in
      case AuthStatusEnum.unauthenticated:
      case AuthStatusEnum.failure:
        return isOnLoginScreen ? null : AppRoutes.login;
    }
  }

  void dispose() {
    _appStateNotifier.dispose();
  }
}
