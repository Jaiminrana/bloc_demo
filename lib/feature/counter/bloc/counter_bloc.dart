import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:self/feature/counter/bloc/counter_event.dart';
import 'package:self/feature/counter/bloc/counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState(0)) {
    on<IncrementCounter>(_onIncrementPressed);
    on<DecrementCounter>(_onDecrementPressed);
    on<ResetCounter>(_onRestPressed);
  }

  FutureOr<void> _onIncrementPressed(
    IncrementCounter event,
    Emitter<CounterState> emit,
  ) {
    emit(state.copyWith(count: state.count + 1));
  }

  FutureOr<void> _onDecrementPressed(
    DecrementCounter event,
    Emitter<CounterState> emit,
  ) {
    emit(state.copyWith(count: state.count - 1));
  }

  FutureOr<void> _onRestPressed(
    ResetCounter event,
    Emitter<CounterState> emit,
  ) {
    emit(state.copyWith(count: 0));
  }
}
