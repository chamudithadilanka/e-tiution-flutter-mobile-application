import 'dart:convert';
import 'package:frontend/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';

  // Save user data
  static Future<bool> saveUser(UserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  // Save auth token
  static Future<bool> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_tokenKey, token);
  }

  // Get user data
  static Future<UserModel?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userStr = prefs.getString(_userKey);

    if (userStr != null) {
      return UserModel.fromJson(jsonDecode(userStr));
    }
    return null;
  }

  // Get auth token
  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Clear all saved data (for logout)
  static Future<bool> clearUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    return prefs.remove(_userKey);
  }
}
