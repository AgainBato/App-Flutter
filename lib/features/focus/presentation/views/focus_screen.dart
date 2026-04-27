import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; 
import 'package:provider/provider.dart';

// Đảm bảo fe_mobile đúng với tên project của bạn nhé
import 'package:fe_mobile/features/focus/presentation/viewmodels/focus_viewmodel.dart';
import 'package:fe_mobile/features/task_management/presentation/viewmodels/todo_viewmodel.dart'; 

class FocusScreen extends StatelessWidget {
  const FocusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 10, 
          bottom: const TabBar(
            labelColor: Color(0xFF4A7DFF), 
            unselectedLabelColor: Colors.black87,
            indicatorColor: Color(0xFF4A7DFF),
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            tabs: [Tab(text: 'Hẹn giờ'), Tab(text: 'Bấm giờ')],
          ),
        ),
        body: const TabBarView(
          children: [_CountdownTab(), _StopwatchTab()],
        ),
      ),
    );
  }
}

// Hàm hỗ trợ format thời gian thành 00 : 00 : 00
String _formatDuration(Duration d) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String h = twoDigits(d.inHours);
  String m = twoDigits(d.inMinutes.remainder(60));
  String s = twoDigits(d.inSeconds.remainder(60));
  return "$h : $m : $s";
}

// ==========================================
// 1. TAB HẸN GIỜ (COUNTDOWN)
// ==========================================
class _CountdownTab extends StatelessWidget {
  const _CountdownTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final focusVM = context.watch<FocusViewModel>();
    final todoVM = context.read<TodoViewModel>();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
      physics: const BouncingScrollPhysics(),
      children: [
        Container(
          width: 280, height: 280,
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.orange, width: 4)),
          child: Center(
            child: Text(
              _formatDuration(focusVM.countdownRemaining), 
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: 2)
            )
          ),
        ),
        const SizedBox(height: 40),

        GestureDetector(
          onTap: focusVM.isCountdownRunning ? null : () => _showTimePicker(context, focusVM),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: focusVM.isCountdownRunning ? Colors.grey[100] : Colors.white,
              borderRadius: BorderRadius.circular(30), 
              border: Border.all(color: Colors.red[100]!)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimePickerItem('giờ'), const SizedBox(width: 24),
                _buildTimePickerItem('phút'), const SizedBox(width: 24),
                _buildTimePickerItem('giây'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCircleButton(
              label: 'Hủy', 
              color: const Color(0xFFFFC6C6), 
              textColor: Colors.red[900]!, 
              onTap: () => focusVM.cancelCountdown()
            ),
            _buildCircleButton(
              label: focusVM.isCountdownRunning ? 'Tạm dừng' : 'Bắt đầu', 
              color: focusVM.isCountdownRunning ? Colors.orange[100]! : const Color(0xFFD4FFC6), 
              textColor: focusVM.isCountdownRunning ? Colors.orange[900]! : Colors.green[900]!, 
              onTap: () => focusVM.toggleCountdown()
            ),
          ],
        ),
        const SizedBox(height: 40),

        GestureDetector(
          onTap: focusVM.isCountdownRunning ? null : () => _showLabelPicker(context, focusVM, todoVM),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: focusVM.isCountdownRunning ? Colors.grey[100] : Colors.white,
              borderRadius: BorderRadius.circular(30), 
              border: Border.all(color: Colors.grey[400]!)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Nhãn', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(
                    focusVM.countdownLabel, 
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w500)
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePickerItem(String label) {
    return Row(
      children: [
        Container(width: 20, height: 20, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey[300]!, width: 1.5))),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  void _showTimePicker(BuildContext context, FocusViewModel focusVM) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 250,
          color: Colors.white,
          child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hms,
            initialTimerDuration: focusVM.countdownDuration,
            onTimerDurationChanged: (Duration newDuration) {
              focusVM.setCountdownDuration(newDuration);
            },
          ),
        );
      }
    );
  }

  void _showLabelPicker(BuildContext context, FocusViewModel focusVM, TodoViewModel todoVM) {
    final txtController = TextEditingController(text: focusVM.countdownLabel == 'Hẹn giờ' ? '' : focusVM.countdownLabel);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Chọn hoặc nhập nhãn', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: txtController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Nhập nhãn tùy chỉnh...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.check, color: Color(0xFF4A7DFF)),
                    onPressed: () {
                      focusVM.setCountdownLabel(txtController.text.trim());
                      Navigator.pop(context);
                    },
                  )
                ),
                onSubmitted: (val) {
                  focusVM.setCountdownLabel(val.trim());
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
              const Text('Hoặc chọn công việc từ To-do:', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              SizedBox(
                height: 200, 
                child: ListView.builder(
                  itemCount: todoVM.allTasks.length,
                  itemBuilder: (context, index) {
                    final task = todoVM.allTasks[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.assignment_outlined, color: Colors.grey),
                      title: Text(task.title),
                      onTap: () {
                        focusVM.setCountdownLabel(task.title);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

// ==========================================
// 2. TAB BẤM GIỜ (STOPWATCH)
// ==========================================
class _StopwatchTab extends StatelessWidget {
  const _StopwatchTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final focusVM = context.watch<FocusViewModel>();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
      physics: const BouncingScrollPhysics(),
      children: [
        Container(
          width: 280, height: 280,
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.orange, width: 4)),
          child: Center(
            child: Text(
              _formatDuration(focusVM.stopwatchElapsed), 
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: 2)
            )
          ),
        ),
        const SizedBox(height: 60),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCircleButton(
              label: 'Đặt lại', 
              color: Colors.white, 
              textColor: Colors.black87, 
              borderColor: Colors.grey[400], 
              onTap: () => focusVM.resetStopwatch()
            ),
            _buildCircleButton(
              label: focusVM.isStopwatchRunning ? 'Dừng' : 'Bắt đầu', 
              color: focusVM.isStopwatchRunning ? Colors.orange[100]! : const Color(0xFFD4FFC6), 
              textColor: focusVM.isStopwatchRunning ? Colors.orange[900]! : Colors.green[900]!, 
              onTap: () => focusVM.toggleStopwatch()
            ),
          ],
        ),
      ],
    );
  }
}

// ==========================================
// WIDGET DÙNG CHUNG
// ==========================================
Widget _buildCircleButton({required String label, required Color color, required Color textColor, Color? borderColor, required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 90, height: 90,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color, border: borderColor != null ? Border.all(color: borderColor) : null),
      child: Center(child: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14))),
    ),
  );
}
