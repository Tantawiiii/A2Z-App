import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _accessTokenKey = 'access_token';

  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_accessTokenKey);
    if (kDebugMode) {
      print('Retrieved token: Success');
    }
    return token;
  }

  Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
  }
}
