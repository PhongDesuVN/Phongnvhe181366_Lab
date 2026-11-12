// Model đại diện cho một công việc (Task) trong ứng dụng Taskly
class Task {
  String id;
  String title;
  bool completed;

  // Hàm khởi tạo công việc
  // Thêm thuộc tính id để gắn vào ValueKey(task.id) giúp tối ưu danh sách (Exercise 12.1)
  Task({
    required this.id,
    required this.title,
    this.completed = false,
  });

  // Hàm đổi trạng thái hoàn thành bằng câu lệnh if-else đơn giản
  void toggle() {
    if (completed == true) {
      completed = false;
    } else {
      completed = true;
    }
  }
}

