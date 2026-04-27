import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  bool _isLoggedIn = true; // Mặc định để true để bạn test giao diện Profile hiện tại
  
  bool get isLoggedIn => _isLoggedIn;

  // Logic Đăng xuất
  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  // Logic Đăng nhập (Dùng cho các màn login sau này)
  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }
}