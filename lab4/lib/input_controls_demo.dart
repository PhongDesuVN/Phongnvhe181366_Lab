import 'package:flutter/material.dart'; // Thư viện giao diện chuẩn Material của Flutter

// StatefulWidget dùng cho màn hình có dữ liệu thay đổi được
class InputControlsDemo extends StatefulWidget {
  InputControlsDemo({Key? key}) : super(key: key);

  @override
  InputControlsDemoState createState() => InputControlsDemoState(); // Tạo State quản lý dữ liệu
}

// Class quản lý dữ liệu và vẽ giao diện
class InputControlsDemoState extends State<InputControlsDemo> {
  // Biến lưu trạng thái các ô nhập (State)
  double rating = 50;           // Lưu giá trị thanh trượt
  bool isActive = false;        // Lưu trạng thái công tắc
  String genre = 'Action';      // Lưu thể loại phim
  String dateText = 'Chua chon'; // Chuỗi hiển thị ngày, mặc định "Chua chon" để ko null

  // Hàm mở lịch chọn ngày (dùng async/await để đợi chọn xong)
  void chonNgay() async {
    DateTime? date = await showDatePicker(
      context: context,            // Truyền vị trí màn hình hiện tại
      initialDate: DateTime.now(), // Ngày mở lên mặc định là hôm nay
      firstDate: DateTime(2000),   // Năm nhỏ nhất được phép chọn
      lastDate: DateTime(2030),    // Năm lớn nhất được phép chọn
    );


    if (date != null) {
      setState(() {
        // Nối chuỗi ngày/tháng/năm thủ công rồi gán vào dateText
        dateText = date.day.toString() + '/' + date.month.toString() + '/' + date.year.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Khung màn hình chuẩn
      appBar: AppBar( // Thanh tiêu đề trên cùng
        title: Text('Exercise 2 - Input Controls'), // Tên bài hiển thị trên AppBar
      ),
      body: SingleChildScrollView( // Cho phép cuộn trang nếu màn hình bị dài quá
        child: Padding( // Căn lề lùi vào trong
          padding: EdgeInsets.all(10.0), // Lùi vào 10 pixel ở cả 4 cạnh
          child: Column( // Sắp xếp các thành phần theo chiều dọc từ trên xuống
            crossAxisAlignment: CrossAxisAlignment.start,// lùi toàn bộ sang lề trái
            children: [
              // thanh trượt
              Text('Rating (Slider):',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),), // Chữ tiêu đề cho mục Slider
              Slider(
                value: rating, // Giá trị hiện tại của nút trượt
                min: 0,        // Giá trị nhỏ nhất
                max: 100,      // Giá trị lớn nhất
                onChanged: (val) { // hiển thị khi kéo thanh trượt
                  setState(() { // Báo Flutter vẽ lại màn hình với số mới
                    rating = val;
                  });
                },
              ),
              Text('Current value: ' + rating.toInt().toString()), // Đổi số thực sang số nguyên rồi nối chuỗi in ra

              SizedBox(height: 30),

              // công tắc
              Row( // Xếp chữ và công tắc nằm ngang trên cùng 1 hàng
                children: [
                  Text('Active (Switch): ',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Switch(
                    value: isActive, // Trạng thái bật hay tắt (true/false)
                    onChanged: (val) {
                      setState(() {
                        isActive = val;
                      });
                    },
                  ),
                ],
              ),

              SizedBox(height: 30),

              // radio
              Text('Genre (RadioListTile):',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              RadioListTile(
                title: Text('Action'), // Nhãn hiển thị của nút Action
                value: 'Action',       // Giá trị đại diện của nút Action
                groupValue: genre,     // Nếu groupValue bằng value ('Action') thì chấm xanh sáng lên
                onChanged: (val) {    // Bắt sự kiện khi tích chọn
                  setState(() {
                    genre = val.toString(); // Cập nhật biến genre sang 'Action'
                  });
                },
              ),
              RadioListTile(
                title: Text('Comedy'),
                value: 'Comedy',
                groupValue: genre,
                onChanged: (val) {
                  setState(() {
                    genre = val.toString(); // Cập nhật biến genre sang 'Comedy'
                  });
                },
              ),
              Text('Selected genre: ' + genre), // In thể loại đang chọn ra màn hình

              SizedBox(height: 30),

              // chọn ngày
              ElevatedButton(
                onPressed: () {
                  chonNgay(); // Bấm nút thì gọi hàm chonNgay() để mở lịch
                },
                child: Text('Open Date Picker'), // Chữ hiển thị trên nút bấm
              ),
              Text('Date: ' + dateText), // In ngày đã chọn ra màn hình
            ],
          ),
        ),
      ),
    );
  }
}