sealed class CounterEvent{
  const CounterEvent();
}

final class IncrementCounter extends CounterEvent{}

final class DecrementCounter extends CounterEvent{}

final class ResetCounter extends CounterEvent{}