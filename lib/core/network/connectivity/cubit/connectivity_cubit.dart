import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:self/core/network/connectivity/connectivity_service.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit(this._connectivityService)
    : super(_connectivityService.currentStatus) {
    _subscription = _connectivityService.onStatusChanged.listen(
      _onConnectivityChanged,
    );
  }

  final ConnectivityService _connectivityService;

  late final StreamSubscription<ConnectivityState> _subscription;

  void _onConnectivityChanged(ConnectivityState status) {
    switch (status) {
      case ConnectivityState.connected:
        emit(ConnectivityState.connected);

      case ConnectivityState.disconnected:
        emit(ConnectivityState.disconnected);
    }
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
