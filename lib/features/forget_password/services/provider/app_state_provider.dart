import 'package:flutter/foundation.dart';

class AppStateProvider with ChangeNotifier {
  String _phoneNumber = '';

  String get phoneNumber => _phoneNumber;

  void setData(String newData) {
    _phoneNumber = newData;
    notifyListeners();
  }
}
