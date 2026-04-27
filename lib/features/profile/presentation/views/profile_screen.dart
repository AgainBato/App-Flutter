import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fe_mobile/features/profile/presentation/viewmodels/profile_viewmodel.dart';
import 'package:fe_mobile/features/community/presentation/viewmodels/feed_viewmodel.dart';
import 'package:fe_mobile/features/community/presentation/views/other_profile_screen.dart'; // Nơi chứa PostCardWidget

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileVM = context.read<ProfileViewModel>();
    final feedVM = context.watch<FeedViewModel>();
    const primaryColor = Color(0xFF4A7DFF);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Hồ sơ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=me_123'),
              backgroundColor: Color(0xFFF3F4F6),
            ),
            const SizedBox(height: 16),
            const Text('Tống Thiên Bảo', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Sinh viên HUCE', style: TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 40),

            _buildMenuTile(
              icon: Icons.article_outlined,
              label: 'Bài viết đã đăng',
              onTap: () => _navigateToPosts(context, 'Bài viết của tôi', feedVM.myPosts),
              iconColor: primaryColor,
            ),
            _buildMenuTile(
              icon: Icons.favorite_border_rounded,
              label: 'Quan tâm',
              onTap: () => _navigateToPosts(context, 'Bài viết đã thích', feedVM.likedPosts),
              iconColor: primaryColor,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Divider(height: 32, color: Color(0xFFEEEEEE)),
            ),
            _buildMenuTile(
              icon: Icons.logout_rounded,
              label: 'Đăng xuất',
              onTap: () => profileVM.logout(), // Bấm cái là tự động văng ra màn LoggedOut
              iconColor: Colors.red,
              textColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color textColor = Colors.black87,
    Color iconColor = const Color(0xFF4A7DFF),
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: textColor)),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _navigateToPosts(BuildContext context, String title, List<PostModel> posts) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(title, style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
            backgroundColor: Colors.white,
            elevation: 0,
            leading: const BackButton(color: Colors.black),
          ),
          body: posts.isEmpty 
            ? const Center(child: Text('Chưa có bài viết nào', style: TextStyle(color: Colors.grey, fontSize: 16)))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: posts.length,
                itemBuilder: (context, index) => PostCardWidget(post: posts[index]),
              ),
        ),
      ),
    );
  }
}