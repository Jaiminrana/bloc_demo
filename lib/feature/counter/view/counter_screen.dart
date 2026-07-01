import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self/feature/counter/cubit/counter_cubit.dart';
import 'package:self/feature/counter/cubit/counter_state.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubitEvent = context.read<CounterCubit>();
    return Scaffold(
      appBar: AppBar(title: Text('Counter Cubit')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: BlocBuilder<CounterCubit, CounterState>(
              builder: (context, state) {
                return Text('${state.count}', style: TextStyle(fontSize: 70));
              },
            ),
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  cubitEvent.increment();
                },
                child: Text('ADD +'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  cubitEvent.reset();
                },
                child: Text('Reset'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  cubitEvent.decrement();
                },
                child: Text('SUBTRACT -'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
