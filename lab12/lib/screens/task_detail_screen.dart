import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

// Màn hình chi tiết để xem và sửa tên công việc (kế thừa từ Lab 11)
class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({
    super.key,
    required this.task,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Gán tên hiện tại của công việc vào ô nhập khi mở màn hình
    titleController.text = widget.task.title;
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  // Hàm lưu tên mới của công việc
  void saveTask() {
    String newTitle = titleController.text.trim();
    if (newTitle != '') {
      // Dùng context.read thay vì watch để chỉ gọi hàm mà không gây rebuild thừa
      context.read<TaskProvider>().updateTask(widget.task.id, newTitle);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Edit Task Title:'),
            const SizedBox(height: 8),
            TextField(
              key: const Key('detailTitleField'),
              controller: titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter new title',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              key: const Key('saveButton'),
              onPressed: saveTask,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

