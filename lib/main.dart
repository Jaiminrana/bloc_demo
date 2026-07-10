import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self/core/storage/secure_storage_service.dart';
import 'package:self/feature/auth/bloc/auth_bloc.dart';
import 'package:self/feature/auth/data/datasource/auth_local_data_source.dart';
import 'package:self/feature/auth/data/repository/auth_repository.dart';
import 'package:self/feature/counter/bloc/counter_bloc.dart';
import 'package:self/feature/splash/bloc/splash_bloc.dart';
import 'package:self/feature/user_profile/bloc/user_profile_bloc.dart';
import 'package:self/feature/user_profile/cubit/user_edit_form/user_edit_form_cubit.dart';
import 'package:self/feature/user_profile/data/data_source/user_profile_remote_data_source.dart';
import 'package:self/feature/user_profile/data/repository/user_profile_repository.dart';

import 'app.dart';
import 'core/network/api_client.dart';
import 'core/network/dio_factory.dart';
import 'core/router/app_router.dart';
import 'feature/auth/data/datasource/auth_remote_datasource.dart';

void main() {
  final localDataSource = AuthLocalDataSourceImpl(SecureStorageService());
  final dio = DioFactory.create(localDataSource);

  final apiClient = ApiClient(dio);

  final remoteDataSource = AuthRemoteDataSourceImpl(apiClient);
  final userProfileRemoteDataSource = UserProfileRemoteDataSourceImpl(
    apiClient,
  );

  final repository = AuthRepositoryImpl(remoteDataSource, localDataSource);
  final userProfileRepository = UserProfileRepositoryImpl(
    userProfileRemoteDataSource,
  );
  final authBloc = AuthBloc(repository);
  final splashBloc = SplashBloc();

  final appRouter = AppRouter(authBloc, splashBloc);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: splashBloc),
        BlocProvider.value(value: authBloc),
        BlocProvider(create: (_) => CounterBloc()),
        BlocProvider(create: (_) => UserProfileBloc(userProfileRepository)),
        BlocProvider(create: (_) => UserEditFormCubit()),
      ],
      child: MyApp(router: appRouter.router),
    ),
  );
}
