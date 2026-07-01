import 'package:bloc/bloc.dart';
import 'package:self/feature/counter/cubit/counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(CounterState(count: 0));

  void increment() {
    emit(state.copyWith(state.count + 1));
  }

  void decrement() {
    emit(state.copyWith(state.count - 1));
  }

  void reset() {
    emit(state.copyWith(0));
  }
}
