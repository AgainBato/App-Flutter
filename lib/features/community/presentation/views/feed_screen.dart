// lib/features/community/presentation/views/feed_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/feed_viewmodel.dart';
import 'other_profile_screen.dart'; // Đảm bảo bạn đã tạo file này ở bước trước

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FeedViewModel>();
    const primaryColor = Color(0xFF4A7DFF);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 16,
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(4)),
            child: const Text('Avata', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          actions: [
            IconButton(icon: const Icon(Icons.notifications_none_rounded, color: Colors.black, size: 28), onPressed: () {}),
            const SizedBox(width: 8),
          ],
          bottom: const TabBar(
            labelColor: primaryColor,
            unselectedLabelColor: Colors.black87,
            indicatorColor: primaryColor,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            tabs: [Tab(text: 'Bảng tin'), Tab(text: 'Theo dõi'), Tab(text: 'Của tôi')],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Tất cả
            _buildPostList(context, viewModel.feedPosts, showHeader: true),
            // Tab 2: Người đang theo dõi
            _buildPostList(context, viewModel.followingPosts),
            // Tab 3: Bài viết của tôi
            _buildPostList(context, viewModel.myPosts),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // HÀM XÂY DỰNG DANH SÁCH BÀI VIẾT
  // (Đã được đặt đúng vị trí ngoài hàm build)
  // ==========================================
  Widget _buildPostList(BuildContext context, List<PostModel> posts, {bool showHeader = false}) {
    final viewModel = context.read<FeedViewModel>();
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: posts.length + (showHeader ? 1 : 0),
      itemBuilder: (context, index) {
        if (showHeader && index == 0) return _buildCreatePostHeader(context, viewModel);
        
        final post = posts[showHeader ? index - 1 : index];
        return GestureDetector(
          onTap: () {
            // Chuyển sang trang Profile người khác nếu không phải bài của mình
            if (post.authorId != viewModel.currentUserId) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OtherProfileScreen(userId: post.authorId, userName: post.authorName),
                ),
              );
            }
          },
          child: _PostCard(post: post, onLike: () => viewModel.toggleLike(post.id)),
        );
      },
    );
  }

  // ==========================================
  // KHUNG ĐĂNG BÀI (Ở TRÊN CÙNG)
  // ==========================================
  Widget _buildCreatePostHeader(BuildContext context, FeedViewModel viewModel) {
    return GestureDetector(
      onTap: () => _showAddPostBottomSheet(context, viewModel),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFFF3F4F6),
              child: Icon(Icons.person, color: Colors.grey),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Bạn có bài tập nào cần hỏi?',
                style: TextStyle(color: Colors.grey[600], fontSize: 15),
              ),
            ),
            const Icon(Icons.image_outlined, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // BOTTOM SHEET: SOẠN BÀI VIẾT MỚI
  // ==========================================
  void _showAddPostBottomSheet(BuildContext context, FeedViewModel viewModel) {
    final contentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20, right: 20, top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tạo bài viết', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    onPressed: () {
                      if (contentController.text.trim().isNotEmpty) {
                        viewModel.addPost(contentController.text.trim());
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A7DFF), elevation: 0),
                    child: const Text('Đăng', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  CircleAvatar(radius: 18, backgroundColor: Color(0xFFF3F4F6), child: Icon(Icons.person, color: Colors.grey, size: 20)),
                  SizedBox(width: 12),
                  Text('Thiên Bảo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                autofocus: true,
                maxLines: 5,
                decoration: const InputDecoration(hintText: 'Nhập nội dung bài viết...', border: InputBorder.none),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

// ==========================================
// CARD BÀI VIẾT
// ==========================================
class _PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback onLike;

  const _PostCard({required this.post, required this.onLike});

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Text(post.authorName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(post.timeAgo, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                ]
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Text(post.content, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1.4)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              GestureDetector(
                onTap: onLike,
                child: Row(
                  children: [
                    Icon(post.isLikedByMe ? Icons.favorite_rounded : Icons.favorite_border_rounded, size: 24, color: post.isLikedByMe ? Colors.red : Colors.black87),
                    const SizedBox(width: 6),
                    Text('${post.likes}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Row(
                children: [
                  const Icon(Icons.chat_bubble_outline_rounded, size: 22, color: Colors.black87),
                  const SizedBox(width: 6),
                  Text('${post.comments}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}