import '../models/task.dart';

// Lớp quản lý danh sách các công việc (thêm, xóa, sửa)
class TaskRepository {
  // Danh sách lưu các công việc trong bộ nhớ
  List<Task> tasks = [];

  // Lấy toàn bộ danh sách công việc
  List<Task> getTasks() {
    return tasks;
  }

  // Thêm một công việc mới vào danh sách
  void addTask(Task task) {
    tasks.add(task);
  }

  // Xóa một công việc khỏi danh sách bằng vòng lặp cơ bản
  void deleteTask(Task task) {
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i] == task) {
        tasks.removeAt(i);
        break; // Xóa xong thì thoát vòng lặp
      }
    }
  }

  // Cập nhật tên công việc mới dựa vào công việc cũ
  void updateTask(Task oldTask, String newTitle) {
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i] == oldTask) {
        tasks[i].title = newTitle;
        break; // Sửa xong thì thoát vòng lặp
      }
    }
  }
}

