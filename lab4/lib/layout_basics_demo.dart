import 'package:flutter/material.dart';

// Bai 3 - Layout Basics
class LayoutBasicsDemo extends StatelessWidget {
  // Mảng danh sách tên phim đơn giản
  List<String> dsPhim = [
    'Spider-Man',
    'Avatar 2',
    'Avengers',
    'Batman',
    'Inception',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise 3 - Layout Basics'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái
          children: [
            // 1 Tiêu đề
            Text(
              'Now Playing', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 8),

            // 2 Dùng Row hiển thị thông tin trên 1 hàng
            Row(
              children: [
                Text('The loai: Action |  '),
                Text('Tong so: ' + dsPhim.length.toString()), // Nối chuỗi thủ công
              ],
            ),

            Container(height: 15), // Dùng Container làm khoảng trống kiểu vụng về

            // 3 Tiêu đề mục danh sách
            Text(
              'Phim noi bat:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 8),

            // 4 ListView.builder vẽ danh sách phim
            ListView.builder(
              shrinkWrap: true, // Co ListView vừa khung để không bị lỗi Column
              physics: NeverScrollableScrollPhysics(), // Tắt cuộn riêng của cái listview
              itemCount: dsPhim.length,// khai báo số lượng ô cần vẽ
              itemBuilder: (context, index) { // tự động vẽ
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.movie),
                    title: Text(dsPhim[index]), // Lấy tên phim theo vị trí
                    subtitle: Text('So thu tu: ' + (index + 1).toString()), // Ép kiểu nối chuỗi
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}