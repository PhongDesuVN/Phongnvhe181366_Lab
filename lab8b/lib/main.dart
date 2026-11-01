import 'package:flutter/material.dart';
import 'currency_screen.dart'; // import file chứa màn hình đổi tỷ giá vừa tạo

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // tắt nhãn debug ở góc màn hình
      title: 'Currency Rate Helper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CurrencyScreen(), // gọi màn hình tỷ giá làm màn hình chính
    );
  }
}