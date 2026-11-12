import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'task_detail_screen.dart';
import 'task_tile.dart';

// Màn hình chính hiển thị danh sách công việc đã được tối ưu hiệu năng (Lab 12)
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // Controller quản lý ô nhập tên công việc mới
  TextEditingController taskController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Exercise 12.2: Pre-cache hình ảnh icon dùng thường xuyên vào bộ nhớ đệm
    // để khi hiển thị danh sách không bị trễ hoặc giật hình
    precacheImage(const AssetImage('assets/task_icon.png'), context);
  }

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  // Hàm xử lý khi bấm nút thêm công việc mới
  void addNewTask() {
    String text = taskController.text.trim();
    if (text != '') {
      // Dùng context.read thay vì context.watch để không làm rebuild cả màn hình
      context.read<TaskProvider>().addTask(text);
      taskController.clear(); // Xóa trắng ô nhập sau khi thêm
    }
  }

  @override
  Widget build(BuildContext context) {
    // Đã xóa/comment lệnh print() kiểm tra rebuild để chuẩn bị bản Release (Exercise 12.4)
    // debugPrint('Rebuild toàn bộ TaskListScreen');

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Hiển thị ảnh icon 128x128 đã được tối ưu kích thước (Exercise 12.2)
            Image.asset(
              'assets/task_icon.png',
              width: 28,
              height: 28,
            ),
            const SizedBox(width: 10),
            const Text('Taskly - Task List'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Phần ô nhập công việc: Tách biệt hoàn toàn, không bị rebuild khi danh sách thay đổi
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('taskInputField'),
                    controller: taskController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a new task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  key: const Key('addTaskButton'),
                  onPressed: addNewTask,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Exercise 12.1: Dùng Selector<TaskProvider, List<Task>> thay cho context.watch
          // để chỉ vẽ lại đúng phần danh sách khi danh sách tasks thay đổi
          Expanded(
            child: Selector<TaskProvider, List<Task>>(
              selector: (context, provider) => provider.tasks,
              builder: (context, tasks, child) {
                if (tasks.isEmpty) {
                  return const Center(
                    child: Text('No tasks yet. Add one!'),
                  );
                }

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    Task currentTask = tasks[index];

                    // Exercise 12.1: Dùng widget TaskTile đã tách riêng và gắn ValueKey(task.id)
                    return TaskTile(
                      key: ValueKey(currentTask.id),
                      task: currentTask,
                      onToggleCompleted: () {
                        context
                            .read<TaskProvider>()
                            .toggleTask(currentTask.id);
                      },
                      onDelete: () {
                        context
                            .read<TaskProvider>()
                            .deleteTask(currentTask.id);
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailScreen(
                              task: currentTask,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

