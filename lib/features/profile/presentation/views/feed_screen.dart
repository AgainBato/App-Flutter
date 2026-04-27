import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fe_mobile/features/community/presentation/viewmodels/feed_viewmodel.dart';
import 'package:fe_mobile/features/community/presentation/views/other_profile_screen.dart';

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
            _buildPostList(context, viewModel.feedPosts, showHeader: true),
            _buildPostList(context, viewModel.followingPosts),
            _buildPostList(context, viewModel.myPosts),
          ],
        ),
      ),
    );
  }

  Widget _buildPostList(BuildContext context, List<PostModel> posts, {bool showHeader = false}) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: posts.length + (showHeader ? 1 : 0),
      itemBuilder: (context, index) {
        if (showHeader && index == 0) return _buildCreatePostHeader(context);
        
        final post = posts[showHeader ? index - 1 : index];
        
        // Tuyệt đối KHÔNG bọc GestureDetector ở đây, cứ trả thẳng Widget ra
        return PostCardWidget(post: post);
      },
    );
  }

  Widget _buildCreatePostHeader(BuildContext context) {
    final viewModel = context.read<FeedViewModel>();
    return GestureDetector(
      onTap: () => _showAddPostBottomSheet(context, viewModel),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[300]!)),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=me_123'),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(width: 12),
            Expanded(child: Text('Bạn có bài tập nào cần hỏi?', style: TextStyle(color: Colors.grey[600], fontSize: 15))),
            const Icon(Icons.image_outlined, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showAddPostBottomSheet(BuildContext context, FeedViewModel viewModel) {
    final contentController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
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
                  CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=me_123')),
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

// ===============================================
// WIDGET BÀI VIẾT TÁCH RỜI
// ===============================================
class PostCardWidget extends StatelessWidget {
  final PostModel post;

  const PostCardWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<FeedViewModel>();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----------------------------------------
          // VÙNG 1: CLICK AVATAR + TÊN ĐỂ VÀO PROFILE
          // ----------------------------------------
          GestureDetector(
            behavior: HitTestBehavior.opaque, // Đảm bảo bấm vào khoảng trắng cũng nhận
            onTap: () {
              if (post.authorId != viewModel.currentUserId) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => OtherProfileScreen(userId: post.authorId, userName: post.authorName)),
                );
              }
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20, 
                  backgroundImage: NetworkImage(post.avatarUrl), 
                  backgroundColor: Colors.grey[300],
                ),
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
          ),
          
          const SizedBox(height: 16),
          
          // ----------------------------------------
          // VÙNG NỘI DUNG (Không click được)
          // ----------------------------------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Text(post.content, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1.4)),
          ),
          
          const SizedBox(height: 16),
          
          // ----------------------------------------
          // VÙNG 2: TƯƠNG TÁC LIKE / COMMENT
          // ----------------------------------------
          Row(
            children: [
              // Nút Like
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => viewModel.toggleLike(post.id),
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, top: 4.0, bottom: 4.0),
                  child: Row(
                    children: [
                      Icon(post.isLikedByMe ? Icons.favorite_rounded : Icons.favorite_border_rounded, size: 24, color: post.isLikedByMe ? Colors.red : Colors.black87),
                      const SizedBox(width: 6),
                      Text('${post.likes}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Nút Comment
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _showCommentsBottomSheet(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline_rounded, size: 22, color: Colors.black87),
                      const SizedBox(width: 6),
                      Text('${post.comments.length}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===============================================
  // BOTTOM SHEET BÌNH LUẬN
  // ===============================================
  void _showCommentsBottomSheet(BuildContext context) {
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6, 
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('${post.comments.length} Bình luận', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const Divider(height: 1),
                
                Expanded(
                  child: Consumer<FeedViewModel>( 
                    builder: (context, viewModel, child) {
                      final currentPost = viewModel.feedPosts.firstWhere((p) => p.id == post.id);
                      
                      if (currentPost.comments.isEmpty) {
                        return const Center(child: Text('Chưa có bình luận nào.\nHãy là người đầu tiên!', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)));
                      }

                      return ListView.builder(
                        itemCount: currentPost.comments.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemBuilder: (context, index) {
                          final comment = currentPost.comments[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(radius: 16, backgroundImage: NetworkImage(comment.avatarUrl), backgroundColor: Colors.grey[200]),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(comment.authorName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                          const SizedBox(width: 8),
                                          Text(comment.timeAgo, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(comment.content, style: const TextStyle(fontSize: 14)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey[300]!))),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 18, backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=me_123'), backgroundColor: Colors.grey[200]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: 'Thêm bình luận...',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                            filled: true,
                            fillColor: const Color(0xFFF3F4F6),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.send_rounded, color: Color(0xFF4A7DFF)),
                        onPressed: () {
                          if (commentController.text.trim().isNotEmpty) {
                            context.read<FeedViewModel>().addComment(post.id, commentController.text.trim());
                            commentController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}