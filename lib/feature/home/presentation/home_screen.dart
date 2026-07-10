import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:self/core/router/route_names.dart';
import 'package:self/feature/auth/bloc/auth_bloc.dart';
import 'package:self/feature/auth/bloc/auth_event.dart';
import 'package:self/feature/auth/bloc/auth_state.dart';
import 'package:self/feature/user_profile/bloc/user_profile_bloc.dart';
import 'package:self/feature/user_profile/bloc/user_profile_event.dart';

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
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage ?? "\$\$\$")),
                );
              },
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

            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.read<UserProfileBloc>().add(
                  UserProfileEvent.fetchUser(1),
                );
                context.pushNamed(RouteNames.userProfile);
              },
              child: Text('Navigate to UserProfile'),
            ),
          ],
        ),
      ),
    );
  }
}
