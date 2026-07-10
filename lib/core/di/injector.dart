import 'package:dio/dio.dart';
import 'package:self/core/di/service_locator.dart';
import 'package:self/core/network/api_client.dart';
import 'package:self/core/network/dio_factory.dart';
import 'package:self/core/router/app_router.dart';
import 'package:self/core/storage/secure_storage_service.dart';
import 'package:self/feature/auth/bloc/auth_bloc.dart';
import 'package:self/feature/auth/data/datasource/auth_local_data_source.dart';
import 'package:self/feature/auth/data/datasource/auth_remote_datasource.dart';
import 'package:self/feature/auth/data/repository/auth_repository.dart';
import 'package:self/feature/splash/bloc/splash_bloc.dart';
import 'package:self/feature/user_profile/bloc/user_profile_bloc.dart';
import 'package:self/feature/user_profile/data/data_source/user_profile_remote_data_source.dart';
import 'package:self/feature/user_profile/data/repository/user_profile_repository.dart';

Future<void> configureDependencies() async {
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(getIt<SecureStorageService>()),
  );

  getIt.registerLazySingleton<Dio>(
    () => DioFactory.create(getIt<AuthLocalDataSource>()),
  );

  getIt.registerLazySingleton<ApiClient>(() => ApiClient(getIt<Dio>()));

  getIt.registerLazySingleton<AuthBloc>(
    () => AuthBloc(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<UserProfileRemoteDataSource>(
    () => UserProfileRemoteDataSourceImpl(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<AuthLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton<UserProfileRepository>(
    () => UserProfileRepositoryImpl(getIt<UserProfileRemoteDataSource>()),
  );

  getIt.registerLazySingleton<SplashBloc>(() => SplashBloc());
  getIt.registerLazySingleton<UserProfileBloc>(() => UserProfileBloc(getIt<UserProfileRepository>()));

  getIt.registerLazySingleton<AppRouter>(
    () => AppRouter(getIt<AuthBloc>(), getIt<SplashBloc>()),
  );
}
