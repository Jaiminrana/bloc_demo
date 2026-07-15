import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'connectivity_service.dart';

class ConnectivityServiceImpl implements ConnectivityService {
  ConnectivityServiceImpl({
    required Dio dio,
    required Connectivity connectivity,
  }) : _dio = dio,
       _connectivity = connectivity;

  final Dio _dio;
  final Connectivity _connectivity;

  ConnectivityState _currentStatus = ConnectivityState.disconnected;

  final StreamController<ConnectivityState> _controller =
      StreamController<ConnectivityState>.broadcast();

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool _isChecking = false;

  Future<void>? _initializeFuture;

  @override
  ConnectivityState get currentStatus => _currentStatus;

  @override
  bool get isConnected => _currentStatus == ConnectivityState.connected;

  @override
  Stream<ConnectivityState> get onStatusChanged => _controller.stream;

  @override
  Future<void> initialize() {
    return _initializeFuture ??= _doInitialize();
  }

  Future<void> _doInitialize() async {
    await _checkConnectivity();

    _listenForChanges();
  }

  void _listenForChanges() {
    _subscription = _connectivity.onConnectivityChanged.listen((_) async {
      debugPrint("================>>> Connectivity changed");
      await _checkConnectivity();
    });
  }

  Future<void> _checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();

    // Device has no available network.
    if (results.contains(ConnectivityResult.none)) {
      _updateStatus(ConnectivityState.disconnected);
      return;
    }

    // Device has Wi-Fi/Mobile/Ethernet.
    // Verify that the internet is actually reachable.
    final connected = await _hasInternet();

    _updateStatus(
      connected
          ? ConnectivityState.connected
          : ConnectivityState.disconnected,
    );
  }

  Future<bool> _hasInternet() async {
    if (_isChecking) {
      return isConnected;
    }

    _isChecking = true;

    const endpoints = [
      'https://cp.cloudflare.com/generate_204',
      'https://www.google.com/generate_204',
      'https://www.msftconnecttest.com/connecttest.txt',
    ];

    try {
      for (final endpoint in endpoints) {
        try {
          final response = await _dio.get(
            endpoint,
            options: Options(
              extra: {'skipAuth': true},
              validateStatus: (_) => true,
              sendTimeout: const Duration(seconds: 5),
              receiveTimeout: const Duration(seconds: 5),
            ),
          );

          final statusCode = response.statusCode;
          if (statusCode != null && statusCode >= 200 && statusCode < 300) {
            return true;
          }
        } on DioException {
          // Try the next endpoint.
          // This endpoint failed, continue to the next one.
          debugPrint(
            'This $endpoint endpoint failed, continue to the next one.',
          );
        }
      }

      return false;
    } finally {
      _isChecking = false;
    }
  }

  void _updateStatus(ConnectivityState newStatus) {
    if (_currentStatus == newStatus) return;

    _currentStatus = newStatus;

    _controller.add(newStatus);
  }

  @override
  Future<void> dispose() async {
    await _subscription?.cancel();
    await _controller.close();
  }
}
