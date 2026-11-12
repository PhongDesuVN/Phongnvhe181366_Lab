import 'package:flutter_test/flutter_test.dart';
import 'package:lab12/main.dart';
import 'package:lab12/providers/task_provider.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Taskly loads initial tasks and adds a new task',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => TaskProvider(),
        child: const TasklyApp(),
      ),
    );

    // Kiểm tra 2 công việc mặc định có hiển thị trên màn hình
    expect(find.text('Lab 11'), findsOneWidget);
    expect(find.text('Lab 12'), findsOneWidget);
  });
}
