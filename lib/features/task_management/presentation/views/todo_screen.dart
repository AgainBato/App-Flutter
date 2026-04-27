import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Đảm bảo bạn đã chạy: flutter pub add intl
import '../viewmodels/todo_viewmodel.dart';
import 'todo_components.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({Key? key}) : super(key: key);

  // Nhãn các thứ trong tuần để hiển thị trên dải ngày
  final List<String> _weekDayLabels = const ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF4A7DFF);
    // Lắng nghe sự thay đổi từ TodoViewModel
    final viewModel = context.watch<TodoViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        // Nút Avatar màu xanh
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            color: primaryBlue,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'Avata',
            style: TextStyle(
              color: Colors.white, 
              fontSize: 16, 
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.black, size: 28),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          
          // 1. HEADER: Chọn tháng (DatePicker) & Nút tìm kiếm, thêm mới
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nút chọn Tháng/Năm
                GestureDetector(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: viewModel.selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(primary: primaryBlue),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) viewModel.changeDate(picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Tháng ${viewModel.selectedDate.month}', 
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down, size: 18),
                      ],
                    ),
                  ),
                ),
                
                // Cụm icon Tìm kiếm & Thêm mới
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.format_list_bulleted_rounded, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.search, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          // Gọi chức năng tìm kiếm toàn cục
                          showSearch(context: context, delegate: TaskSearchDelegate(viewModel));
                        },
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.add, size: 22),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          // Mở form thêm công việc mới
                          showAddTaskBottomSheet(context, viewModel);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. DẢI NGÀY TRONG TUẦN (Đã logic hóa theo ViewModel)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                DateTime dayInWeek = viewModel.currentWeekDays[index];
                bool isSelected = dayInWeek.day == viewModel.selectedDate.day && 
                                  dayInWeek.month == viewModel.selectedDate.month;
                
                return GestureDetector(
                  onTap: () => viewModel.changeDate(dayInWeek),
                  child: Column(
                    children: [
                      Text(
                        _weekDayLabels[index], 
                        style: TextStyle(
                          fontSize: 13, 
                          fontWeight: FontWeight.w600, 
                          color: isSelected ? primaryBlue : Colors.grey[600]
                        )
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${dayInWeek.day}', 
                        style: TextStyle(
                          fontSize: 20, 
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, 
                          color: isSelected ? primaryBlue : Colors.black87
                        )
                      ),
                      const SizedBox(height: 4),
                      if (isSelected) 
                        Container(
                          width: 30, 
                          height: 4, 
                          decoration: BoxDecoration(
                            color: primaryBlue.withOpacity(0.2), 
                            borderRadius: BorderRadius.circular(2)
                          )
                        ) 
                      else 
                        const SizedBox(height: 4),
                    ],
                  ),
                );
              }),
            ),
          ),
          
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 16),

          // 3. TIÊU ĐỀ & BỘ LỌC TRẠNG THÁI
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lịch trình hôm nay', 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _FilterChip(
                      label: 'Tất cả', 
                      index: 0, 
                      selectedIndex: viewModel.selectedFilterIndex, 
                      onTap: () => viewModel.changeFilter(0)
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Chưa xong', 
                      index: 1, 
                      selectedIndex: viewModel.selectedFilterIndex, 
                      onTap: () => viewModel.changeFilter(1)
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Đã hoàn thành', 
                      index: 2, 
                      selectedIndex: viewModel.selectedFilterIndex, 
                      onTap: () => viewModel.changeFilter(2)
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 4. DANH SÁCH CÔNG VIỆC ĐÃ LỌC
          Expanded(
            child: viewModel.filteredTasks.isEmpty 
              ? const Center(child: Text('Không có việc cần làm!'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: viewModel.filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = viewModel.filteredTasks[index];
                    return TaskCardWidget(
                      task: task, 
                      onToggle: () => viewModel.toggleTaskStatus(task.id)
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// WIDGET HỖ TRỢ: Nút lọc (Filter Chip)
// ==========================================
class _FilterChip extends StatelessWidget {
  final String label;
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label, 
    required this.index, 
    required this.selectedIndex, 
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4A7DFF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF4A7DFF) : Colors.grey[300]!),
        ),
        child: Text(
          label, 
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87, 
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal, 
            fontSize: 13
          )
        ),
      ),
    );
  }
}

// ==========================================
// WIDGET HỖ TRỢ: Thẻ công việc (Task Card)
// ==========================================
class TaskCardWidget extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onToggle;

  const TaskCardWidget({Key? key, required this.task, required this.onToggle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6), 
        borderRadius: BorderRadius.circular(16)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nút Checkbox động
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: task.isCompleted ? const Color(0xFF4A7DFF) : Colors.grey[400]!, 
                  width: 1.5
                ),
                color: task.isCompleted ? const Color(0xFF4A7DFF) : Colors.white,
              ),
              child: task.isCompleted 
                ? const Icon(Icons.check, size: 16, color: Colors.white) 
                : null,
            ),
          ),
          const SizedBox(width: 16),
          // Thông tin tên và giờ giấc
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: task.isCompleted ? Colors.grey : Colors.black87,
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null, 
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('HH:mm').format(task.startTime), 
                  style: const TextStyle(fontSize: 13, color: Colors.black54)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}