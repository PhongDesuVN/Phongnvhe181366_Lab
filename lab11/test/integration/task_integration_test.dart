import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/main.dart';

void main() {
  // LAB 11.4 & 11.5 - Integration Test (nằm trong thư mục test/integration/)
  testWidgets('Full flow: Add Original title -> Open detail -> Edit to Updated title -> Save', (WidgetTester tester) async {
    // 1. Dựng ứng dụng Taskly
    await tester.pumpWidget(const TasklyApp());

    // 2. Nhập "Original title" và bấm nút Add
    await tester.enterText(find.byKey(const Key('taskInputField')), 'Original title');
    await tester.tap(find.text('Add'));
    await tester.pump();

    expect(find.text('Original title'), findsOneWidget);

    // 3. Bấm vào công việc vừa thêm để sang màn hình chi tiết
    await tester.tap(find.text('Original title'));
    await tester.pumpAndSettle();

    // 4. Đổi tên thành "Updated title" ở ô TextField có key 'detailTitleField'
    await tester.enterText(find.byKey(const Key('detailTitleField')), 'Updated title');

    // 5. Bấm Save
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // 6. Xác nhận "Updated title" hiển thị trên màn hình danh sách
    expect(find.text('Updated title'), findsOneWidget);
    expect(find.text('Original title'), findsNothing);
  });
}

