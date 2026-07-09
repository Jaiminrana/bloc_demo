import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self/feature/auth/bloc/auth_bloc.dart';
import 'package:self/feature/auth/bloc/auth_event.dart';
import 'package:self/feature/auth/bloc/auth_state.dart';
import 'package:self/feature/counter/presentation/counter_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void onLogin() {
    if (!formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
      LoginSubmitted(
        username: emailController.text.trim(),
        password: passwordController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login form')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatusEnum.authenticated) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Login Successful')));

            // TODO: Navigate to Home Screen
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => CounterScreen()),
            );
          }

          if (state.status == AuthStatusEnum.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Login Failed')),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Username is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Password is required';
                    }

                    if (value.length < 6) {
                      return 'Minimum 6 characters';
                    }

                    return null;
                  },
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.status == AuthStatusEnum.loading
                        ? null
                        : onLogin,
                    child: state.status == AuthStatusEnum.loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Login'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
