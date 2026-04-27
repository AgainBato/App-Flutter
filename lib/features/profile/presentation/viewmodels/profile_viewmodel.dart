import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  // Trạng thái mặc định ban đầu là chưa đăng nhập
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  // Giả lập Đăng nhập
  void login(String email, String password) {
    if (email.isNotEmpty && password.isNotEmpty) {
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  // Giả lập Đăng ký
  void signUp(String name, String email, String password) {
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  // Đăng xuất
  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}