// Model đại diện cho một công việc (Task) trong ứng dụng Taskly
class Task {
  String title;
  bool completed;

  // Hàm khởi tạo, mặc định completed sẽ là false (chưa hoàn thành)
  Task({
    required this.title,
    this.completed = false,
  });

  // Hàm đổi trạng thái công việc: từ true sang false và ngược lại
  void toggle() {
    if (completed == true) {
      completed = false;
    } else {
      completed = true;
    }
  }
}

