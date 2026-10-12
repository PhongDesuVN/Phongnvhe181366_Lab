import 'package:flutter/material.dart';

// Bài 5: Debug & Sửa các lỗi UI phổ biến
class DebugFixDemo extends StatefulWidget {
  @override
  DebugFixDemoState createState() {
    return DebugFixDemoState(); // Tạo State quản lý dữ liệu
  }
}

class DebugFixDemoState extends State<DebugFixDemo> {
  // Dữ liệu Task 1: Danh sách tên phim
  List<String> movieList = [
    'Movie A',
    'Movie B',
    'Movie C',
    'Movie D',
  ];

  // Dữ liệu Task 2: Danh sách chữ dài để demo sửa lỗi tràn viền (Overflow)
  List<String> rowItems = [
    'Long content item 1 (No Overflow Error)',
    'Long content item 2 (No Overflow Error)',
  ];

  // Dữ liệu Task 3: Biến đếm số
  int count = 0;

  // Dữ liệu Task 4: Biến lưu ngày đã chọn
  String selectedDate = 'No date selected';

  // Hàm Task 3: Bọc trong setState để giao diện vẽ lại khi tăng số
  void increaseCount() {
    setState(() {
      count = count + 1;
    });
  }

  // Hàm Task 4: Gọi showDatePicker bằng context hợp lệ từ StatefulWidget
  void pickDate() async {
    DateTime? date = await showDatePicker(
      context: context, // Context chuẩn của Widget Tree
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    // Nếu người dùng chọn ngày thì cập nhật biến
    if (date != null) {
      setState(() {
        selectedDate = date.day.toString() + '/' + date.month.toString() + '/' + date.year.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise 5 – Common UI...'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // task 1:  lỗi listview
            Text(
              'Correct ListView inside Column using Expanded',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 8),

            // Sửa lỗi Unbounded Height: Bọc ListView vào Expanded để tự co giãn
            Expanded(// Bọc Expanded để giới hạn chiều cao ListView
              child: ListView.builder(  // Dựng danh sách cuộn tự động
                itemCount: movieList.length,  // Số lượng ô = số phần tử mảng movieList
                itemBuilder: (context, index) {  // Hàm lặp vẽ từng ô theo vị trí index
                  return ListTile(
                    leading: Icon(Icons.movie),
                    title: Text(movieList[index]),
                  );
                },
              ),
            ),

            SizedBox(height: 10),

            // task 2: lỗi tràn màn hình (overflow)
            Text(
              '2. Fix Overflow using SingleChildScrollView:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 5),

            // Sửa lỗi Overflow: Bọc SingleChildScrollView chứa dữ liệu rowItems
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Cuộn theo chiều ngang
              child: Row(
                children: [
                  Container(
                    color: Colors.blue[100],
                    padding: EdgeInsets.all(8), // Căn lề trong
                    child: Text(rowItems[0]), // In chuỗi thứ 1 trong mảng
                  ),
                  SizedBox(width: 8),
                  Container(
                    color: Colors.green[100],
                    padding: EdgeInsets.all(8),
                    child: Text(rowItems[1]), // In chuỗi thứ 2 trong mảng
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            // task 3: lỗi cập nhập giao diện (setstate)
            Text(
              '3. Fix State Update (setState):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            Row(
              children: [
                Text('Count: ' + count.toString() + '  '),
                ElevatedButton(
                  onPressed: () {
                    increaseCount(); // Nút bấm gọi hàm có setState
                  },
                  child: Text('Add Count'),
                ),
              ],
            ),

            SizedBox(height: 10),

            // task 4: lỗi datepicker
            Text(
              '4. Fix DatePicker Context:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    pickDate(); // Nút bấm mở lịch từ context chuẩn
                  },
                  child: Text('Pick Date'),
                ),
                SizedBox(width: 10),
                Text(selectedDate),
              ],
            ),
          ],
        ),
      ),
    );
  }
}