import 'package:flutter/material.dart';
import 'package:fe_mobile/features/profile/presentation/views/login_view.dart';

class ProfileLoggedOutView extends StatelessWidget {
  const ProfileLoggedOutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: const Color(0xFF4A7DFF).withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.lock_outline_rounded, size: 80, color: Color(0xFF4A7DFF)),
              ),
              const SizedBox(height: 32),
              const Text('Bạn chưa đăng nhập', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 12),
              const Text('Đăng nhập để xem hồ sơ cá nhân,\nbài viết và các mục đã lưu của bạn.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16, height: 1.5)),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    // Mở màn hình Đăng nhập
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginView()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A7DFF),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Đăng nhập ngay', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}