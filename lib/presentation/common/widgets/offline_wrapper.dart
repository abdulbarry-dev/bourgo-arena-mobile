import 'dart:async';
import 'package:bourgo_arena_mobile/presentation/common/screens/offline_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';

class OfflineWrapper extends StatefulWidget {
  final Widget child;

  const OfflineWrapper({super.key, required this.child});

  @override
  State<OfflineWrapper> createState() => _OfflineWrapperState();
}

class _OfflineWrapperState extends State<OfflineWrapper> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isOffline = false;
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    _checkInitialConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  Future<void> _checkInitialConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      // Handle error if necessary
    }
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    if (!mounted) return;

    // Connectivity_plus 5.0+ returns a List<ConnectivityResult>
    final hasNetworkHardware =
        !result.contains(ConnectivityResult.none) || result.length > 1;

    bool isActuallyOffline = true;

    if (hasNetworkHardware) {
      // Even if Wi-Fi/Data is turned on, we must verify actual API data access
      isActuallyOffline = !(await _checkActualApiAccess());
    }

    if (!mounted) return;
    if (_isOffline != isActuallyOffline) {
      setState(() {
        _isOffline = isActuallyOffline;
      });
    }
  }

  Future<bool> _checkActualApiAccess() async {
    try {
      final dio = Dio(BaseOptions(
        baseUrl: locator<ApiClient>().baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ));
      
      // Ping the base URL to verify actual data access
      await dio.get('/');
      return true;
    } catch (e) {
      if (e is DioException && e.response != null) {
        // If we get any HTTP response (even 404, 500), the network data access is working
        return true;
      }
      return false; // Connection timeout, SocketException, etc.
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isOffline) const Positioned.fill(child: OfflineScreen()),
      ],
    );
  }
}
