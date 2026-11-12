import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/screens/task_list_screen.dart';

void main() {
  // LAB 11.2 - Widget Test cho màn hình TaskListScreen
  group('TaskListScreen Widget Tests', () {
    testWidgets('Hien thi thong bao Empty State khi chua co task nao', (WidgetTester tester) async {
      // 1. Arrange & Act: Dựng giao diện màn hình TaskListScreen
      await tester.pumpWidget(
        const MaterialApp(
          home: TaskListScreen(),
        ),
      );

      // 3. Assert: Kiểm tra dòng chữ "No tasks yet. Add one!" có xuất hiện
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);
    });

    testWidgets('Them 1 task moi va kiem tra giao dien cap nhat', (WidgetTester tester) async {
      // 1. Arrange: Dựng màn hình
      await tester.pumpWidget(
        const MaterialApp(
          home: TaskListScreen(),
        ),
      );

      // 2. Act: Nhập chữ vào ô TextField và bấm nút Add
      await tester.enterText(find.byType(TextField), 'Doc sach Flutter');
      await tester.tap(find.text('Add'));
      await tester.pump(); // Vẽ lại frame mới sau khi setState

      // 3. Assert: Dòng thông báo rỗng biến mất và tên task mới xuất hiện
      expect(find.text('No tasks yet. Add one!'), findsNothing);
      expect(find.text('Doc sach Flutter'), findsOneWidget);
    });

    testWidgets('Them 2 task va kiem tra ca 2 deu hien thi tren man hinh', (WidgetTester tester) async {
      // 1. Arrange: Dựng màn hình
      await tester.pumpWidget(
        const MaterialApp(
          home: TaskListScreen(),
        ),
      );

      // 2. Act: Thêm công việc thứ nhất
      await tester.enterText(find.byType(TextField), 'Cong viec 1');
      await tester.tap(find.text('Add'));
      await tester.pump();

      // Thêm tiếp công việc thứ hai
      await tester.enterText(find.byType(TextField), 'Cong viec 2');
      await tester.tap(find.text('Add'));
      await tester.pump();

      // 3. Assert: Kiểm tra cả 2 công việc đều hiển thị trên danh sách
      expect(find.text('Cong viec 1'), findsOneWidget);
      expect(find.text('Cong viec 2'), findsOneWidget);
    });
  });
}

