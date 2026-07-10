import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self/feature/auth/bloc/auth_bloc.dart';
import 'package:self/feature/counter/bloc/counter_bloc.dart';
import 'package:self/feature/splash/bloc/splash_bloc.dart';
import 'package:self/feature/user_profile/bloc/user_profile_bloc.dart';
import 'package:self/feature/user_profile/cubit/user_edit_form/user_edit_form_cubit.dart';

import 'app.dart';
import 'core/di/injector.dart';
import 'core/di/service_locator.dart';
import 'core/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<SplashBloc>()),
        BlocProvider.value(value: getIt<AuthBloc>()),
        BlocProvider(create: (_) => CounterBloc()),
        BlocProvider(create: (_) => getIt<UserProfileBloc>()),
        BlocProvider(create: (_) => UserEditFormCubit()),
      ],
      child: MyApp(router: getIt<AppRouter>().router),
    ),
  );
}
