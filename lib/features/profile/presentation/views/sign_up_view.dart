import 'package:flutter/material.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({Key? key}) : super(key: key);

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
      body: SingleChildScrollView( // Thêm scroll để tránh overflow trên màn hình nhỏ
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Đăng ký', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              
              // Danh sách các trường (cite: image_10.png)
              const TextField(decoration: InputDecoration(hintText: 'Full Name')),
              const SizedBox(height: 16),
              const TextField(decoration: InputDecoration(hintText: 'Phone Number')),
              const SizedBox(height: 16),
              const TextField(decoration: InputDecoration(hintText: 'Email')),
              const SizedBox(height: 16),
              const TextField(obscureText: true, decoration: InputDecoration(hintText: 'Password')),
              const SizedBox(height: 16),
              const TextField(obscureText: true, decoration: InputDecoration(hintText: 'Confirm Password')),
              const SizedBox(height: 16),
              const TextField(decoration: InputDecoration(hintText: 'Current Address')),
              const SizedBox(height: 32),
              
              // Nút SIGN UP (cite: image_10.png)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Xử lý logic đăng ký
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text('SIGN UP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}