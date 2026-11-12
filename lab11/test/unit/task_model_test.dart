import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';

void main() {
  // LAB 11.1 - Unit Test cho Task Model
  group('Task Model Unit Tests', () {
    test('Gia tri mac dinh cua completed phai la false', () {
      // 1. Arrange (Chuẩn bị dữ liệu)
      Task task = Task(title: 'Hoc Flutter');

      // 2. Act (Thực hiện hành động - ở đây chỉ kiểm tra giá trị lúc mới tạo)
      bool defaultStatus = task.completed;

      // 3. Assert (Kiểm tra kết quả)
      expect(defaultStatus, false);
    });

    test('Ham toggle() doi trang thai tu false sang true va nguoc lai', () {
      // 1. Arrange (Chuẩn bị 1 task mới có completed mặc định là false)
      Task task = Task(title: 'Lam bai tap Lab 11');

      // 2. Act & 3. Assert lần 1: Bấm toggle lần đầu (false -> true)
      task.toggle();
      expect(task.completed, true);

      // 2. Act & 3. Assert lần 2: Bấm toggle lần nữa (true -> false)
      task.toggle();
      expect(task.completed, false);
    });
  });
}

