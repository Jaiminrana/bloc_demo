import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self/feature/counter/bloc/counter_bloc.dart';
import 'package:self/feature/counter/bloc/counter_event.dart';
import 'package:self/feature/counter/bloc/counter_state.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bloc Counter App')),
      body: Center(
        child: BlocBuilder<CounterBloc, CounterState>(
          builder: (context, state) {
            return Text(state.count.toString());
          },
        ),
      ),
      floatingActionButton: Row (
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            heroTag: 'decrement_btn',
            onPressed: () {
              context.read<CounterBloc>().add(DecrementCounter());
            },
            child: const Icon(Icons.delete),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: 'reset_btn',
            onPressed: () {
              context.read<CounterBloc>().add(ResetCounter());
            },
            child: const Icon(Icons.reset_tv),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: 'increment_btn',
            onPressed: () {
              context.read<CounterBloc>().add(IncrementCounter());
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
