import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self/feature/auth/bloc/auth_bloc.dart';
import 'package:self/feature/auth/data/repository/auth_repository.dart';

import 'app.dart';
import 'core/network/api_client.dart';
import 'core/network/dio_factory.dart';
import 'feature/auth/data/datasource/auth_remote_datasource.dart';

void main() {
  final dio = DioFactory.create();

  final apiClient = ApiClient(dio);

  final remoteDataSource = AuthRemoteDataSourceImpl(apiClient);

  final repository = AuthRepositoryImpl(remoteDataSource);

  final authBloc = AuthBloc(repository);
  runApp(BlocProvider(create: (_) => authBloc, child: const MyApp()));
}
