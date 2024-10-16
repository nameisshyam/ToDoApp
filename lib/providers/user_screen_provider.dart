import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';


class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name') ?? '';
    final email = prefs.getString('email') ?? '';
    final profileImage = prefs.getString('profileImage');
    if (name.isNotEmpty && email.isNotEmpty) {
      _user = User(name: name, email: email, profileImage: profileImage);
    }
    notifyListeners();
  }

  Future<void> updateUser(String name, String email, [String? profileImage]) async {
    _user = User(name: name, email: email, profileImage: profileImage);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    if (profileImage != null) {
      await prefs.setString('profileImage', profileImage);
    }
    notifyListeners();
  }
}
