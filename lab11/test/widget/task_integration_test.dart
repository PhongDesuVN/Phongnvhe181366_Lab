import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/main.dart';

void main() {
  // LAB 11.4 - Integration Test: Kiểm tra luồng hoạt động từ đầu đến cuối
  testWidgets('Luong day du: Them task -> Mo chi tiet -> Sua ten -> Luu lai', (WidgetTester tester) async {
    // 1. Khởi chạy toàn bộ ứng dụng Taskly
    await tester.pumpWidget(const TasklyApp());

    // 2. Thêm công việc mới với tên "Original title"
    await tester.enterText(find.byKey(const Key('taskInputField')), 'Original title');
    await tester.tap(find.text('Add'));
    await tester.pump();

    // Kiểm tra "Original title" đã hiện lên danh sách
    expect(find.text('Original title'), findsOneWidget);

    // 3. Bấm vào công việc "Original title" để mở màn hình Task Detail
    await tester.tap(find.text('Original title'));
    await tester.pumpAndSettle();

    // 4. Sửa tên trong ô nhập liệu detailTitleField thành "Updated title"
    Finder detailInput = find.byKey(const Key('detailTitleField'));
    expect(detailInput, findsOneWidget);
    await tester.enterText(detailInput, 'Updated title');

    // 5. Bấm nút Save để lưu lại và quay về màn hình danh sách
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // 6. Kiểm tra tên mới "Updated title" xuất hiện trong danh sách và tên cũ không còn
    expect(find.text('Updated title'), findsOneWidget);
    expect(find.text('Original title'), findsNothing);
  });
}

