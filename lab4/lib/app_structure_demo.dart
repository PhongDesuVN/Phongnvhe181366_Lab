import 'package:flutter/material.dart';

// Bai 4 - App Structure voi Switch doi Dark Mode
class AppStructureDemo extends StatefulWidget {
  @override
  AppStructureDemoState createState() {
    return AppStructureDemoState();
  }
}

class AppStructureDemoState extends State<AppStructureDemo> {
  // Biến lưu trạng thái công tắc (false: Sáng, true: Tối)
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,// Tắt nhãn Debug

      // 1. Cấu hình theme Sáng
      theme: ThemeData(
        brightness: Brightness.light,
      ),

      // 2. Cấu hình theme Tối
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),

      // 3. Chọn theme dựa theo biến isDarkMode
      themeMode: isDarkMode == true ? ThemeMode.dark : ThemeMode.light,

      home: Scaffold(
        appBar: AppBar(
          title: Text('Exercise 4 - App Structure'),
        ),

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Căn giữa toàn bộ màn hình
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Căn giữa công tắc và chữ
                children: [
                  Text(
                    'Dark Mode: ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  //công tắc
                  Switch(
                    value: isDarkMode, // Trạng thái bật/tắt hiện tại
                    onChanged: (bool val) {// Bắt sự kiện khi gạt công tắc, val trả về true/false mới
                      setState(() {
                        isDarkMode = val; // Bấm gạt công tắc để chuyển trạng thái
                      });
                    },
                  ),
                ],
              ),

              SizedBox(height: 10),

              // In ra màn hình chữ trạng thái
              Text('Status: ' + (isDarkMode == true ? 'Turning on Dark Mode' : 'Turning on Light Mode')),
            ],
          ),
        ),

        // Nút nổi FloatingActionButton (FAB) ở góc dưới
        floatingActionButton: FloatingActionButton(
          onPressed: () {// Sự kiện khi bấm vào nút nổi FAB
            setState(() {
              // Bấm nút FAB cũng gạt công tắc đảo ngược trạng thái
              if (isDarkMode == true) {
                isDarkMode = false;
              } else {
                isDarkMode = true;
              }
            });
          },
          child: Icon(Icons.color_lens),
        ),
      ),
    );
  }
}