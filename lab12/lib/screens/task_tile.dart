import 'package:flutter/material.dart';
import '../models/task.dart';

// Tách riêng từng dòng công việc thành một StatelessWidget độc lập (Exercise 12.1)
// Giúp khi 1 công việc thay đổi thì không phải vẽ lại toàn bộ màn hình
class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleCompleted;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  // Sử dụng const constructor để tối ưu hiệu năng (Exercise 12.1 & 12.4)
  const TaskTile({
    super.key,
    required this.task,
    required this.onToggleCompleted,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Đã tắt log debug khi đóng gói bản Release theo yêu cầu Exercise 12.4:
    // debugPrint('Rebuild TaskTile: ${task.title}');

    return ListTile(
      leading: Checkbox(
        value: task.completed,
        onChanged: (value) {
          onToggleCompleted();
        },
      ),
      title: Row(
        children: [
          // Hiển thị ảnh icon đã được thu nhỏ 128x128 và pre-cache (Exercise 12.2)
          Image.asset(
            'assets/task_icon.png',
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              task.title,
              style: TextStyle(
                // Nếu đã hoàn thành thì gạch ngang chữ cho dễ nhìn
                decoration: task.completed == true
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: onDelete,
      ),
      onTap: onTap,
    );
  }
}

