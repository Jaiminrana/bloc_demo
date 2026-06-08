import 'package:bloc/bloc.dart';
import 'package:self/feature/counter/bloc/counter_event.dart';
import 'package:self/feature/counter/bloc/counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState(0)) {
    on<IncrementCounter>((event, emit) => emit(CounterState(state.count + 1)));
    on<DecrementCounter>((event, emit) => emit(CounterState(state.count - 1)));
    on<ResetCounter>((event, emit) => emit(CounterState(0)));
  }
}
