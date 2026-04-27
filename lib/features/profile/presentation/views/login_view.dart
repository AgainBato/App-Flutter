import 'package:flutter/material.dart';
import 'package:fe_mobile/features/profile/presentation/views/sign_up_view.dart'; // Đổi fe_mobile thành tên dự án của bạn
import 'package:fe_mobile/features/profile/presentation/views/forgot_password_view.dart'; // Đổi fe_mobile thành tên dự án của bạn

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4A7DFF);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Đăng nhập', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            
            // Trường 'Phone or Email' (cite: image_11.png)
            const TextField(
              decoration: InputDecoration(
                hintText: 'Phone or Email',
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
            ),
            const SizedBox(height: 16),
            
            // Trường 'Password' (cite: image_11.png)
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
            ),
            const SizedBox(height: 32),
            
            // Nút LOGIN (cite: image_11.png)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý logic đăng nhập
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('LOGIN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
            
            // Forgot Password? (cite: image_11.png)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ForgotPasswordView()),
                  );
                },
                child: const Text('Forgot Password?', style: TextStyle(color: primaryColor)),
              ),
            ),
            
            const Spacer(), // Đẩy phần 'Don't have an account?' xuống cuối
            
            // Don't have an account? Sign up (cite: image_11.png)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don’t have an account?', style: TextStyle(color: Colors.grey)),
                TextButton(
                  onPressed: () {
                    // Chuyển sang màn hình Đăng ký
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpView()),
                    );
                  },
                  child: const Text('Sign up', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}