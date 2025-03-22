import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService extends ChangeNotifier {
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  ConnectivityService() {
    // Initial check
    checkConnectivity();
    
    // Listen to connectivity changes
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _isOnline = result != ConnectivityResult.none;
      notifyListeners();
    });
  }

  Future<void> checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    _isOnline = result != ConnectivityResult.none;
    notifyListeners();
  }
} 