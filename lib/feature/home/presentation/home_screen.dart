import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self/feature/auth/bloc/auth_bloc.dart';
import 'package:self/feature/auth/bloc/auth_event.dart';
import 'package:self/feature/auth/bloc/auth_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User Logged inn'),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthEvent.logoutRequested());
                  },
                  child: state.status == AuthStatusEnum.loading
                      ? CircularProgressIndicator()
                      : Text('Logout'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
