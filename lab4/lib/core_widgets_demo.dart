import 'package:flutter/material.dart';

class CoreWidgetsDemo extends StatelessWidget {
  // Constructor
  CoreWidgetsDemo({ Key? key }) : super(key: key);

  @override
  // Scaffold: khung màn hình tiêu chuẩn
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise 1 – Core Widgets'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0), // Lùi vào 16 pixel
        child: Column(
          children: [
            // Dòng tiêu đề
            Text(
              'Welcome to GYM',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 30, // Cỡ chữ
                fontWeight: FontWeight.bold, // Đổi nét chữ thành in đậm
              ),
            ),
            SizedBox(height: 20), // Khoảng trống 20 pixel

            // Icon hình cái phim
            Icon(
              Icons.downhill_skiing,
              size: 80,
              color: Colors.blue,
            ),
            SizedBox(height: 20),

            // Ảnh
            Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRk1tt22QGeCFdBodfb6QKniqelxERJ3sM7FzZHIQJyQA&s=10',
              height: 400,
              width: 350,
              fit: BoxFit.cover, // Cắt bớt mép dư và bao phủ ảnh
            ),
            SizedBox(height: 50),

            // Thẻ Card chứa thông tin
            Card(
              child: ListTile( // Đặt một dòng thông tin vào trong thẻ
                leading: Icon(Icons.star, color: Colors.amber),
                title: Text('Movie Item',
                style: TextStyle(
                   fontSize: 20,
                ),),
                subtitle: Text('My name is David Laid',
                style: TextStyle(
                  color: Colors.pink,
                  fontSize: 15,
                ),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}