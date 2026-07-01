import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self/feature/counter/cubit/counter_cubit.dart';

import 'app.dart';

void main() {
  runApp(BlocProvider(create: (_) => CounterCubit(), child: const MyApp()));
}
