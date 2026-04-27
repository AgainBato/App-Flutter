import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/feed_viewmodel.dart';

class OtherProfileScreen extends StatelessWidget {
  final String userId;
  final String userName;

  const OtherProfileScreen({super.key, required this.userId, required this.userName});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FeedViewModel>();
    final userPosts = viewModel.getPostsByUser(userId);
    final isFollowing = viewModel.isFollowing(userId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, leading: const BackButton(color: Colors.black)),
      body: Column(
        children: [
          // Header: Avatar, Tên, Nút theo dõi
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const CircleAvatar(radius: 50, backgroundColor: Colors.grey, child: Icon(Icons.person, size: 50, color: Colors.white)),
                const SizedBox(height: 16),
                Text(userName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () => viewModel.toggleFollow(userId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFollowing ? Colors.grey[200] : const Color(0xFF4A7DFF),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(
                      isFollowing ? 'Đang theo dõi' : 'Theo dõi',
                      style: TextStyle(color: isFollowing ? Colors.black87 : Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          // Danh sách bài đăng của họ
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: userPosts.length,
              itemBuilder: (context, index) => PostCardWidget(post: userPosts[index]),
            ),
          ),
        ],
      ),
    );
  }
}

// Tách widget card ra dùng chung (để trong cùng file hoặc file riêng)
class PostCardWidget extends StatelessWidget {
  final PostModel post;
  const PostCardWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 20, backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white)),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(post.authorName, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(post.timeAgo, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ]),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Text(post.content),
          ),
        ],
      ),
    );
  }
}