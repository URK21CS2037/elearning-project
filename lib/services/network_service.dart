import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final networkStateProvider = StreamProvider<ConnectionState>((ref) {
  return NetworkService().connectionStateStream;
});

class NetworkService {
  final _connectivity = Connectivity();

  Stream<ConnectionState> get connectionStateStream {
    return _connectivity.onConnectivityChanged.map((status) {
      switch (status) {
        case ConnectivityResult.none:
          return ConnectionState.offline;
        case ConnectivityResult.mobile:
          return ConnectionState.mobile;
        case ConnectivityResult.wifi:
          return ConnectionState.wifi;
        default:
          return ConnectionState.offline;
      }
    });
  }

  Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}

enum ConnectionState {
  offline,
  mobile,
  wifi
} 