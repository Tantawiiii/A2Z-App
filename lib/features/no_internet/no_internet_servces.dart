import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

StreamController<bool> internetStatusController = StreamController<bool>.broadcast();

Future<bool> checkInternetStatus() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  bool isOnline = connectivityResult != ConnectivityResult.none;
  internetStatusController.add(isOnline);
  return isOnline;
}

class ConnectionChecker {
  static void startListening() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      bool isOnline = result != ConnectivityResult.none;
      internetStatusController.add(isOnline);
    } as void Function(List<ConnectivityResult> event)?);
  }

  static Future<bool> refreshInternetStatus() async {
    return await checkInternetStatus();
  }
}
