import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import 'task_detail_screen.dart';

// Màn hình chính hiển thị danh sách công việc
class TaskListScreen extends StatefulWidget {
  final TaskRepository? repository;

  const TaskListScreen({super.key, this.repository});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late TaskRepository repo;
  TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Nếu có truyền repository từ ngoài vào (ví dụ khi test) thì dùng nó,
    // còn không thì tự tạo mới một TaskRepository
    if (widget.repository != null) {
      repo = widget.repository!;
    } else {
      repo = TaskRepository();
    }
  }

  // Hàm xử lý khi người dùng bấm nút thêm công việc
  void addNewTask() {
    String text = taskController.text;
    if (text != '') {
      Task newTask = Task(title: text);
      setState(() {
        repo.addTask(newTask);
        taskController.clear(); // Xóa trắng ô nhập sau khi thêm xong
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Task> taskList = repo.getTasks();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskly'),
      ),
      body: Column(
        children: [
          // Phần nhập tên công việc mới và nút Add
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('taskInputField'),
                    controller: taskController,
                    decoration: const InputDecoration(
                      hintText: 'Enter task name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  key: const Key('addTaskButton'),
                  onPressed: addNewTask,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
          ),

          // Phần hiển thị danh sách công việc bên dưới
          Expanded(
            child: taskList.isEmpty
                // Khi danh sách rỗng thì hiện dòng chữ đúng theo yêu cầu Lab 11.2
                ? const Center(
                    child: Text('No tasks yet. Add one!'),
                  )
                : ListView.builder(
                    itemCount: taskList.length,
                    itemBuilder: (context, index) {
                      Task currentTask = taskList[index];
                      return ListTile(
                        leading: Checkbox(
                          value: currentTask.completed,
                          onChanged: (value) {
                            setState(() {
                              currentTask.toggle();
                            });
                          },
                        ),
                        title: Text(currentTask.title),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              repo.deleteTask(currentTask);
                            });
                          },
                        ),
                        // Khi bấm vào 1 công việc thì chuyển sang màn hình TaskDetailScreen
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskDetailScreen(
                                task: currentTask,
                                repository: repo,
                              ),
                            ),
                          ).then((value) {
                            // Cập nhật lại giao diện sau khi từ màn hình chi tiết quay về
                            setState(() {});
                          });
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

