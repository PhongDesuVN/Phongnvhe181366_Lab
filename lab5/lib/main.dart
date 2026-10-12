import 'package:flutter/material.dart';
import 'movie_app.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Tắt nhãn Debug
      home: HomeScreen(),
    );
  }
}