enum ConnectivityState { connected, disconnected }

abstract interface class ConnectivityService {
  ConnectivityState get currentStatus;

  bool get isConnected;

  Stream<ConnectivityState> get onStatusChanged;

  Future<void> initialize();

  Future<void> dispose();
}

