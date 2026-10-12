import 'package:flutter/material.dart';
import 'core_widgets_demo.dart';
import 'input_controls_demo.dart';
import 'layout_basics_demo.dart';
import 'app_structure_demo.dart';
import 'debug_fix_demo.dart';
void main() {
  runApp(MyApp());
}

// MyApp tạo vỏ ngoài cho toàn bộ ứng dụng
class MyApp extends StatelessWidget {

  @override

  //MateralApp là cái vỏ bọc ngoài cùng của cả app
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false, // Tắt nhãn "DEBUG" ở góc màn hình
      // home: CoreWidgetsDemo(),//  Bài 1
      // home: InputControlsDemo(),//  Bài 2
      // home: LayoutBasicsDemo(),// Bài 3
      // home: AppStructureDemo(),// Bài 4
      home: DebugFixDemo(),
    );
  }
}