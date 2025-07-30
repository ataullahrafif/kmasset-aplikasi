import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class NetworkUtils {
  // Check if device has any connectivity (WiFi or Mobile Data)
  static Future<bool> hasConnectivity() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      return false;
    }
  }

  // Check if device actually has internet connection
  static Future<bool> hasInternetConnection() async {
    try {
      // First check if device has connectivity
      bool hasConnectivityResult = await hasConnectivity();
      debugPrint('Connectivity check result: $hasConnectivityResult');

      if (!hasConnectivityResult) {
        debugPrint('No connectivity, returning false');
        return false;
      }

      // For now, just return true if we have connectivity
      // InternetConnectionChecker can be unreliable in some cases
      debugPrint('Has connectivity, assuming internet is available');
      return true;

      // Uncomment below for strict internet checking
      // bool hasInternet = await InternetConnectionChecker().hasConnection;
      // debugPrint('Internet connection check result: $hasInternet');
      // return hasInternet;
    } catch (e) {
      debugPrint('Error checking internet connection: $e');
      return false;
    }
  }

  // Get current connectivity type
  static Future<String> getConnectivityType() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      switch (connectivityResult) {
        case ConnectivityResult.wifi:
          return 'WiFi';
        case ConnectivityResult.mobile:
          return 'Mobile Data';
        case ConnectivityResult.ethernet:
          return 'Ethernet';
        case ConnectivityResult.vpn:
          return 'VPN';
        case ConnectivityResult.bluetooth:
          return 'Bluetooth';
        case ConnectivityResult.other:
          return 'Other';
        case ConnectivityResult.none:
          return 'No Connection';
      }
    } catch (e) {
      debugPrint('Error getting connectivity type: $e');
      return 'Unknown';
    }
  }

  // Listen to connectivity changes
  static Stream<ConnectivityResult> get connectivityStream {
    return Connectivity().onConnectivityChanged;
  }

  // Check connection quality (basic)
  static Future<String> getConnectionQuality() async {
    try {
      bool hasInternet = await hasInternetConnection();
      if (!hasInternet) {
        return 'No Internet';
      }

      // Basic quality check - in real app, you might want to ping specific servers
      var connectivityResult = await Connectivity().checkConnectivity();
      switch (connectivityResult) {
        case ConnectivityResult.wifi:
          return 'WiFi (Good)';
        case ConnectivityResult.mobile:
          return 'Mobile Data (Fair)';
        default:
          return 'Connected';
      }
    } catch (e) {
      debugPrint('Error checking connection quality: $e');
      return 'Unknown';
    }
  }
}
