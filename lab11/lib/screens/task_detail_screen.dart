import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';

// Màn hình chi tiết công việc để xem và sửa tên công việc
class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final TaskRepository repository;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.repository,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  // Controller để lấy và gán chữ trong ô nhập liệu
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Gán tên hiện tại của task vào ô TextField khi mở màn hình
    titleController.text = widget.task.title;
  }

  // Hàm lưu lại tên mới của công việc
  void saveTask() {
    String newTitle = titleController.text;
    if (newTitle.isNotEmpty) {
      widget.repository.updateTask(widget.task, newTitle);
    }
    // Quay lại màn hình danh sách sau khi lưu
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Tiêu đề AppBar bắt buộc phải là "Task Detail" để khớp với bài test 11.3
        title: const Text('Task Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Edit Task Title:'),
            const SizedBox(height: 8),
            // Ô nhập liệu có gắn Key('detailTitleField') theo yêu cầu của Lab 11.3
            TextField(
              key: const Key('detailTitleField'),
              controller: titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter new title',
              ),
            ),
            const SizedBox(height: 16),
            // Nút bấm lưu thay đổi
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

