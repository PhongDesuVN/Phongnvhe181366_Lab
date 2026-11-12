import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';
import 'package:lab11/repositories/task_repository.dart';
import 'package:lab11/screens/task_list_screen.dart';

void main() {
  // LAB 11.3 - Navigation Test: Chuyển từ TaskListScreen sang TaskDetailScreen
  testWidgets('Bam vao 1 task se chuyen sang man hinh Task Detail', (WidgetTester tester) async {
    // 1. Arrange: Tạo sẵn repository và thêm trước 1 công việc (seed data)
    TaskRepository seededRepo = TaskRepository();
    seededRepo.addTask(Task(title: 'On thi cuoi ky'));

    // Dựng màn hình TaskListScreen với repository đã có sẵn dữ liệu
    await tester.pumpWidget(
      MaterialApp(
        home: TaskListScreen(repository: seededRepo),
      ),
    );

    // 2. Act: Bấm vào công việc "On thi cuoi ky" và chờ hiệu ứng chuyển màn hình xong
    await tester.tap(find.text('On thi cuoi ky'));
    await tester.pumpAndSettle();

    // 3. Assert: Kiểm tra đã sang màn hình chi tiết chưa
    // - Tiêu đề trên AppBar phải là "Task Detail"
    expect(find.text('Task Detail'), findsOneWidget);
    // - Có ô TextField mang key là 'detailTitleField'
    expect(find.byKey(const Key('detailTitleField')), findsOneWidget);
  });
}

