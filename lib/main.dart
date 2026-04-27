import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --- IMPORT VIEWMODELS ---
import 'package:fe_mobile/features/onboarding/presentation/viewmodels/subject_onboarding_viewmodel.dart';
import 'package:fe_mobile/features/task_management/presentation/viewmodels/todo_viewmodel.dart';
import 'package:fe_mobile/features/community/presentation/viewmodels/feed_viewmodel.dart';
import 'package:fe_mobile/features/focus/presentation/viewmodels/focus_viewmodel.dart';
import 'package:fe_mobile/features/profile/presentation/viewmodels/profile_viewmodel.dart';

// --- IMPORT VIEWS ---
import 'package:fe_mobile/features/community/presentation/views/feed_screen.dart';
import 'package:fe_mobile/features/task_management/presentation/views/todo_screen.dart';
import 'package:fe_mobile/features/focus/presentation/views/focus_screen.dart';
import 'package:fe_mobile/features/profile/presentation/views/profile_screen.dart';
import 'package:fe_mobile/features/profile/presentation/views/profile_logged_out_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SubjectOnboardingViewModel()),
        ChangeNotifierProvider(create: (_) => TodoViewModel()),
        ChangeNotifierProvider(create: (_) => FeedViewModel()),
        ChangeNotifierProvider(create: (_) => FocusViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()), // Quản lý đăng nhập
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF4A7DFF),
        scaffoldBackgroundColor: Colors.white,
      ),
      // Màn hình khởi đầu là Layout chứa Bottom Bar
      home: const MainLayoutScreen(), 
    );
  }
}

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({Key? key}) : super(key: key);

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Lắng nghe trạng thái từ ProfileViewModel để biết đã logout hay chưa
    final profileVM = context.watch<ProfileViewModel>();

    // Danh sách màn hình - Tab cuối cùng sẽ thay đổi dựa trên trạng thái đăng nhập
    final List<Widget> screens = [
      const FeedScreen(),
      const TodoScreen(),
      const FocusScreen(),
      profileVM.isLoggedIn ? const ProfileScreen() : const ProfileLoggedOutView(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[300]!, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF4A7DFF),
          unselectedItemColor: Colors.black54,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.view_day_outlined), 
              activeIcon: Icon(Icons.view_day_rounded),
              label: 'Post'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.checklist_rtl_outlined), 
              activeIcon: Icon(Icons.checklist_rtl_rounded),
              label: 'To-do'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.filter_center_focus_outlined), 
              activeIcon: Icon(Icons.filter_center_focus_rounded),
              label: 'Focus'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined), 
              activeIcon: Icon(Icons.account_circle_rounded),
              label: 'Profile'
            ),
          ],
        ),
      ),
    );
  }
}