import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';
import 'package:lab11/repositories/task_repository.dart';

void main() {
  // LAB 11.1 - Unit Test cho TaskRepository
  group('TaskRepository Unit Tests', () {
    test('addTask() them 1 cong viec moi vao danh sach', () {
      // 1. Arrange (Tạo kho chứa rỗng và 1 công việc mới)
      TaskRepository repository = TaskRepository();
      Task newTask = Task(title: 'Mua sua');

      // 2. Act (Gọi hàm thêm công việc)
      repository.addTask(newTask);

      // 3. Assert (Kiểm tra danh sách có 1 phần tử và đúng tên)
      expect(repository.getTasks().length, 1);
      expect(repository.getTasks()[0].title, 'Mua sua');
    });

    test('deleteTask() xoa cong viec khoi danh sach', () {
      // 1. Arrange (Tạo kho chứa và thêm sẵn 1 công việc)
      TaskRepository repository = TaskRepository();
      Task taskToDelete = Task(title: 'Don phong');
      repository.addTask(taskToDelete);

      // 2. Act (Gọi hàm xóa công việc đó)
      repository.deleteTask(taskToDelete);

      // 3. Assert (Kiểm tra danh sách đã trống)
      expect(repository.getTasks().isEmpty, true);
    });

    test('updateTask() cap nhat lai ten cua cong viec', () {
      // 1. Arrange (Tạo kho chứa và thêm sẵn công việc ban đầu)
      TaskRepository repository = TaskRepository();
      Task myTask = Task(title: 'Ten cu');
      repository.addTask(myTask);

      // 2. Act (Gọi hàm sửa tên công việc thành "Ten moi")
      repository.updateTask(myTask, 'Ten moi');

      // 3. Assert (Kiểm tra tên công việc trong danh sách đã đổi thành "Ten moi")
      expect(repository.getTasks()[0].title, 'Ten moi');
    });
  });
}

