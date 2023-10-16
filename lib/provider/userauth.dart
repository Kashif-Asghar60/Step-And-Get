import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String? _userId;

  void setUserId(String? userId) {
    _userId = userId;

    // Save or clear the user ID in local storage based on the value of userId
    if (userId != null) {
      _saveUserIdToLocalStorage(userId);
    } else {
      _clearUserIdInLocalStorage();
    }

    notifyListeners();
  }

  String? get userId => _userId;

  // Add other user-related data and methods here

  // Load the user ID from local storage when the app starts
  Future<void> initUser() async {
    final userId = await _loadUserIdFromLocalStorage();

    print("loading from local $userId");
    if (userId != null) {
      _userId = userId;
      notifyListeners();
    }
  }

  // Save user ID to local storage
  Future<void> _saveUserIdToLocalStorage(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    print("saving to local $userId");

    await prefs.setString('user_id', userId);
  }

  // Load user ID from local storage
  Future<String?> _loadUserIdFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    print("inside local local $userId");

    return prefs.getString('user_id');
  }

  // Clear user ID from local storage
  Future<void> _clearUserIdInLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    print("clearing user ID in local storage");

    await prefs.remove('user_id');
  }
}
