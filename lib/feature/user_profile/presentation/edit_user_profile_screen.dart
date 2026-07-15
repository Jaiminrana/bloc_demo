import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self/core/errors/failure_message_mapper.dart';
import 'package:self/feature/user_profile/bloc/user_profile_bloc.dart';
import 'package:self/feature/user_profile/bloc/user_profile_event.dart';
import 'package:self/feature/user_profile/bloc/user_profile_state.dart';
import 'package:self/feature/user_profile/cubit/user_edit_form/user_edit_form_cubit.dart';
import 'package:self/feature/user_profile/cubit/user_edit_form/user_edit_form_state.dart';

class EditUserProfileScreen extends StatefulWidget {
  const EditUserProfileScreen({super.key});

  @override
  State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();

    final user = context.read<UserEditFormCubit>().state;

    _nameController = TextEditingController(text: user.originalName);
    _emailController = TextEditingController(text: user.originalEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocConsumer<UserProfileBloc, UserProfileState>(
          listener: (context, state) {
            if (state.status == UserStatus.loaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User details updated successfully')),
              );
            } else if (state.status == UserStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(FailureMessageMapper.map(state.failure!)),
                ),
              );
            }
          },
          builder: (context, userProfileState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: BlocConsumer<UserEditFormCubit, UserEditFormState>(
                    listener: (context, state) {
                      if (state.name != _nameController.text) {
                        _nameController.text = state.name ?? '';
                      } else if (state.email != _emailController.text) {
                        _emailController.text = state.email ?? '';
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              label: Text('Name'),
                              errorText: state.nameError,
                            ),
                            controller: _nameController,
                            onChanged: context
                                .read<UserEditFormCubit>()
                                .nameChange,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              label: Text('Email'),
                              errorText: state.emailError,
                            ),
                            controller: _emailController,
                            onChanged: context
                                .read<UserEditFormCubit>()
                                .emailChanged,
                          ),
                          ElevatedButton(
                            onPressed: !state.canSubmit
                                ? null
                                : () {
                                    final user = context
                                        .read<UserProfileBloc>();
                                    user.add(
                                      UserProfileEvent.updateUser(
                                        updatedUser: user.state.user!.copyWith(
                                          firstName: state.name ?? '',
                                          email: state.email ?? '',
                                        ),
                                      ),
                                    );
                                  },
                            child:
                                userProfileState.status == UserStatus.updating
                                ? CircularProgressIndicator()
                                : Text('Update'),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
