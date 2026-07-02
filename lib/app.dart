import 'package:flutter/material.dart';
import 'package:self/feature/auth/presentation/auth_screen.dart';

import 'core/network/api_client.dart';
import 'core/network/dio_factory.dart';
import 'feature/auth/data/datasource/auth_remote_datasource.dart';
import 'feature/auth/data/repository/auth_repository.dart';
import 'feature/counter/presentation/counter_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {


    return MaterialApp(home: AuthScreen());
  }
}
