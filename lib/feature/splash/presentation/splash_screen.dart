import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self/feature/splash/bloc/splash_bloc.dart';
import 'package:self/feature/splash/bloc/splash_event.dart';
import 'package:self/feature/splash/bloc/splash_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SplashBloc>().add(const SplashEvent.started());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Splash Screen')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: CircularProgressIndicator()),
          BlocBuilder<SplashBloc, SplashState>(
            builder: (context, state) {
              return Text('${state.isCompleted}');
            },
          ),
        ],
      ),
    );
  }
}
