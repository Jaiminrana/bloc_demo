import 'package:equatable/equatable.dart';

final class CounterState extends Equatable {
  final int count;

  const CounterState(this.count);

  CounterState copyWith({int? count}) {
    return CounterState(count ?? this.count);
  }

  @override
  List<Object> get props => [count];
}
