import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self/core/network/connectivity/connectivity_service.dart';
import 'package:self/core/network/connectivity/cubit/connectivity_cubit.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityState>(
      builder: (_, state) {
        if (state == ConnectivityState.connected) {
          return const SizedBox.shrink();
        }

        return Material(
          color: Colors.red,
          child: SafeArea(
            bottom: false,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              child: const Text(
                'No Internet Connection',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}