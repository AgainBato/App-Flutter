import 'package:flutter/material.dart';

class PostModel {
  final String id;
  final String authorId; // Thêm ID tác giả
  final String authorName;
  final String timeAgo;
  final String content;
  int likes;
  int comments;
  bool isLikedByMe;

  PostModel({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.timeAgo,
    required this.content,
    this.likes = 0,
    this.comments = 0,
    this.isLikedByMe = false,
  });
}

class FeedViewModel extends ChangeNotifier {
  List<PostModel> get likedPosts => _allPosts.where((p) => p.isLikedByMe).toList();
  final String currentUserId = 'me_123'; // ID của Thiên Bảo
  final List<String> _followingUserIds = []; // Danh sách ID đang theo dõi

  final List<PostModel> _allPosts = [
    PostModel(
      id: '1', authorId: 'user_456', authorName: 'Đức Anh',
      timeAgo: '29 phút trước', content: 'Nội dung tại đây', likes: 36, comments: 36,
    ),
    PostModel(
      id: '2', authorId: 'user_789', authorName: 'Lan Hương',
      timeAgo: '2 giờ trước', content: 'Có ai đi học nhóm thư viện không?', likes: 10, comments: 2,
    ),
  ];

  // Tab 1: Tất cả bài viết
  List<PostModel> get feedPosts => _allPosts;

  // Tab 2: Chỉ những người mình theo dõi
  List<PostModel> get followingPosts => _allPosts.where((p) => _followingUserIds.contains(p.authorId)).toList();

  // Tab 3: Chỉ bài của mình (Thiên Bảo)
  List<PostModel> get myPosts => _allPosts.where((p) => p.authorId == currentUserId).toList();

  bool isFollowing(String userId) => _followingUserIds.contains(userId);

  void toggleFollow(String userId) {
    if (_followingUserIds.contains(userId)) {
      _followingUserIds.remove(userId);
    } else {
      _followingUserIds.add(userId);
    }
    notifyListeners();
  }

  void addPost(String content) {
    _allPosts.insert(0, PostModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorId: currentUserId,
      authorName: 'Thiên Bảo',
      timeAgo: 'Vừa xong',
      content: content,
    ));
    notifyListeners();
  }

  void toggleLike(String postId) {
    final index = _allPosts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      _allPosts[index].isLikedByMe = !_allPosts[index].isLikedByMe;
      _allPosts[index].likes += _allPosts[index].isLikedByMe ? 1 : -1;
      notifyListeners();
    }
  }

  // Lấy bài viết của một user cụ thể (dùng cho trang cá nhân người khác)
  List<PostModel> getPostsByUser(String userId) => _allPosts.where((p) => p.authorId == userId).toList();
}