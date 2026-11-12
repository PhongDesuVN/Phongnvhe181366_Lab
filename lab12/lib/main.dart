import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'screens/task_list_screen.dart';

void main() {
  runApp(
    // Bọc ứng dụng trong ChangeNotifierProvider để cung cấp TaskProvider cho toàn app
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: const TasklyApp(),
    ),
  );
}

// Widget gốc của ứng dụng Taskly (Lab 12)
class TasklyApp extends StatelessWidget {
  const TasklyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Taskly',
      debugShowCheckedModeBanner: false,
      home: TaskListScreen(),
    );
  }
}
