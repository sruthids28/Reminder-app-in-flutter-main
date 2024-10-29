// lib/services/auth_service.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  String? _username;
  bool _isAuthenticated = false;

  String? get username => _username;
  bool get isAuthenticated => _isAuthenticated;

  // Register a new user
  Future<bool> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user_$username')) {
      // User already exists
      return false;
    }
    await prefs.setString('user_$username', password);
    return true;
  }

  // Login user
  Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_$username') == password) {
      _username = username;
      _isAuthenticated = true;
      await prefs.setString('current_user', username);
      notifyListeners();
      return true;
    }
    return false;
  }

  // Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
    _username = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  // Check if user is already logged in
  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('current_user')) {
      return;
    }
    final username = prefs.getString('current_user');
    if (username == null) {
      return;
    }
    _username = username;
    _isAuthenticated = true;
    notifyListeners();
  }
}
