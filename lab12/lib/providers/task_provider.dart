import 'package:flutter/material.dart';
import '../models/task.dart';

// Provider quản lý danh sách công việc và thông báo khi dữ liệu thay đổi (Exercise 12.1)
class TaskProvider extends ChangeNotifier {
  // Danh sách công việc ban đầu
  List<Task> tasks = [
    Task(id: '1', title: 'Lab 11', completed: false),
    Task(id: '2', title: 'Lab 12', completed: false),
  ];

  // Biến đếm thủ công để tự tăng id khi thêm công việc mới
  int countId = 3;

  // Hàm thêm công việc mới vào danh sách
  void addTask(String title) {
    Task newTask = Task(
      id: countId.toString(),
      title: title,
      completed: false,
    );
    countId = countId + 1;

    // Tạo danh sách mới bằng vòng lặp cơ bản để Selector nhận biết có sự thay đổi
    List<Task> newList = [];
    for (int i = 0; i < tasks.length; i++) {
      newList.add(tasks[i]);
    }
    newList.add(newTask);

    tasks = newList;
    notifyListeners(); // Thông báo cho Selector vẽ lại phần danh sách
  }

  // Hàm đổi trạng thái hoàn thành của công việc dựa theo id
  void toggleTask(String id) {
    List<Task> newList = [];
    for (int i = 0; i < tasks.length; i++) {
      Task item = tasks[i];
      if (item.id == id) {
        // Đảo ngược trạng thái completed thủ công
        bool newStatus = false;
        if (item.completed == false) {
          newStatus = true;
        }
        newList.add(Task(
          id: item.id,
          title: item.title,
          completed: newStatus,
        ));
      } else {
        newList.add(item);
      }
    }

    tasks = newList;
    notifyListeners();
  }

  // Hàm xóa một công việc ra khỏi danh sách dựa theo id
  void deleteTask(String id) {
    List<Task> newList = [];
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].id != id) {
        newList.add(tasks[i]);
      }
    }

    tasks = newList;
    notifyListeners();
  }

  // Hàm sửa tên công việc dựa theo id
  void updateTask(String id, String newTitle) {
    List<Task> newList = [];
    for (int i = 0; i < tasks.length; i++) {
      Task item = tasks[i];
      if (item.id == id) {
        newList.add(Task(
          id: item.id,
          title: newTitle,
          completed: item.completed,
        ));
      } else {
        newList.add(item);
      }
    }

    tasks = newList;
    notifyListeners();
  }
}

