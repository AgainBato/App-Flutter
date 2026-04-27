import 'package:flutter/material.dart';

class SubjectModel {
  final String id;
  final String name;
  final String iconPath;
  SubjectModel({required this.id, required this.name, required this.iconPath});

  @override
  bool operator ==(Object other) => identical(this, other) || other is SubjectModel && id == other.id;
  @override
  int get hashCode => id.hashCode;
}

class SubjectOnboardingViewModel extends ChangeNotifier {
  final List<SubjectModel> _allSubjects = [
    SubjectModel(id: '1', name: 'Toán học Cao cấp', iconPath: '🧮'),
    SubjectModel(id: '2', name: 'Lập trình Flutter', iconPath: '💻'),
    SubjectModel(id: '3', name: 'Tiếng Nhật N3', iconPath: '🇯🇵'),
    SubjectModel(id: '4', name: 'Cơ kết cấu', iconPath: '🏗️'),
  ];

  List<SubjectModel> _addedSubjects = [];
  bool _isProcessing = false;

  List<SubjectModel> get popularSubjects => _allSubjects;
  List<SubjectModel> get addedSubjects => _addedSubjects;
  bool get isProcessing => _isProcessing;
  bool get hasAddedSubjects => _addedSubjects.isNotEmpty;

  void addSubject(SubjectModel subject) {
    if (!_addedSubjects.contains(subject)) {
      _addedSubjects.add(subject);
      notifyListeners();
    }
  }

  void removeSubject(SubjectModel subject) {
    _addedSubjects.remove(subject);
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _isProcessing = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1)); // Giả lập lưu vào DB
    _isProcessing = false;
    notifyListeners();
  }
}