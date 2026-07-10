import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:self/core/router/route_names.dart';
import 'package:self/feature/user_profile/bloc/user_profile_bloc.dart';
import 'package:self/feature/user_profile/bloc/user_profile_state.dart';
import 'package:self/feature/user_profile/cubit/user_edit_form/user_edit_form_cubit.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state.status == UserStatus.loaded) {
            context.read<UserEditFormCubit>().initialized(
              state.user?.firstName ?? '',
              state.user?.email ?? '',
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    state.status == UserStatus.loading
                        ? 'User Profile is Loading...'
                        : 'Name: ${state.user?.firstName} ${state.user?.lastName}\n Email: ${state.user?.email}',
                  ),
                ),

                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    context.pushNamed(RouteNames.editUserProfile);
                  },
                  child: Text('Navigate to Edit user profile'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
