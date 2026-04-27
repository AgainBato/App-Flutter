import 'package:flutter/material.dart';

// 1. Cập nhật Model: Dùng DateTime cho cả bắt đầu và kết thúc
class TaskModel {
  final String id;
  final String title;
  bool isCompleted;
  final DateTime startTime; // Ngày & Giờ bắt đầu
  final DateTime? endTime;  // Ngày & Giờ kết thúc (Có thể null)

  TaskModel({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.startTime,
    this.endTime,
  });
}

class TodoViewModel extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now(); 
  int _selectedFilterIndex = 0; 

  DateTime get selectedDate => _selectedDate;
  int get selectedFilterIndex => _selectedFilterIndex;
  
  // Expose toàn bộ tasks để phục vụ tính năng Tìm kiếm toàn cục
  List<TaskModel> get allTasks => _allTasks; 

  late List<TaskModel> _allTasks;

  TodoViewModel() {
    DateTime today = DateTime.now();
    DateTime tomorrow = today.add(const Duration(days: 1));

    _allTasks = [
      TaskModel(id: '1', title: 'Nộp sơ đồ Usecase', startTime: DateTime(today.year, today.month, today.day, 8, 0)),
      TaskModel(id: '2', title: 'Làm quiz Lập trình Flutter', startTime: DateTime(today.year, today.month, today.day, 14, 30), isCompleted: true),
      TaskModel(id: '3', title: 'Học từ vựng Tiếng Nhật', startTime: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 20, 0)),
    ];
  }

  List<DateTime> get currentWeekDays {
    int currentWeekday = _selectedDate.weekday; 
    DateTime monday = _selectedDate.subtract(Duration(days: currentWeekday - 1));
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  List<TaskModel> get filteredTasks {
    var tasksForDay = _allTasks.where((task) => 
      task.startTime.year == _selectedDate.year &&
      task.startTime.month == _selectedDate.month &&
      task.startTime.day == _selectedDate.day
    ).toList();
    
    if (_selectedFilterIndex == 1) return tasksForDay.where((t) => !t.isCompleted).toList();
    if (_selectedFilterIndex == 2) return tasksForDay.where((t) => t.isCompleted).toList();
    return tasksForDay;
  }

  void changeDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void changeFilter(int index) {
    _selectedFilterIndex = index;
    notifyListeners();
  }

  void toggleTaskStatus(String taskId) {
    final taskIndex = _allTasks.indexWhere((t) => t.id == taskId);
    if (taskIndex != -1) {
      _allTasks[taskIndex].isCompleted = !_allTasks[taskIndex].isCompleted;
      notifyListeners();
    }
  }

  // --- TÍNH NĂNG MỚI: Thêm công việc ---
  void addTask(String title, DateTime start, DateTime? end) {
    _allTasks.add(TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      startTime: start,
      endTime: end,
    ));
    notifyListeners();
  }
}