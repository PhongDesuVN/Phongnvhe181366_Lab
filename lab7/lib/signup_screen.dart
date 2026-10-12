import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  @override
  SignupScreenState createState() {
    return SignupScreenState(); // tạo trạng thái cho màn hình đăng ký
  }
}

class SignupScreenState extends State<SignupScreen> {
  // globalkey quản lý trạng thái form và gọi kiểm tra lỗi toàn bộ các ô
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // texteditingcontroller dùng để đọc và lấy chuỗi người dùng gõ vào ô
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // focusnode quản lý con trỏ bàn phím và điều hướng qua lại giữa các ô
  FocusNode focusName = FocusNode();
  FocusNode focusEmail = FocusNode();
  FocusNode focusPassword = FocusNode();
  FocusNode focusConfirmPassword = FocusNode();

  // biến cờ đánh dấu trạng thái đang tải dữ liệu kiểm tra server giả lập
  bool isChecking = false;

  // hàm xử lý kiểm tra và gửi dữ liệu
  void submitForm() async {
    // validate() kích hoạt hàm validator của tất cả textformfield trong form
    if (formKey.currentState!.validate() == true) {
      setState(() {
        isChecking = true; // bật vòng xoay tròn tải dữ liệu
      });

      // future.delayed tạm dừng 2 giây để giả lập kết nối máy chủ
      await Future.delayed(Duration(seconds: 2));

      // startswith() kiểm tra xem email có bắt đầu bằng từ taken hay không
      if (emailController.text.startsWith('taken') == true) {
        // hiển thị thanh thông báo lỗi email đã bị trùng
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('This email is already taken!')),
        );
      } else {
        // hiển thị thanh thông báo đăng ký thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup success!')),
        );
      }

      setState(() {
        isChecking = false; // tắt vòng xoay tròn tải dữ liệu
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // gesturedetector bắt sự kiện chạm tay vào màn hình
    return GestureDetector(
      onTap: () {
        // unfocus() đóng bàn phím ảo khi người dùng bấm ra ngoài ô nhập
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Signup'), // tiêu đề thanh ứng dụng
        ),
        // singlechildscrollview giúp cuộn trang tránh lỗi tràn màn hình khi bật bàn phím
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          // form bao bọc và quản lý tập hợp các ô nhập liệu
          child: Form(
            key: formKey, // gán key quản lý form
            // autovalidatemode.onuserinteraction tự động báo lỗi ngay khi gõ từng ký tự
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                // ô nhập họ và tên
                TextFormField(
                  controller: nameController,
                  focusNode: focusName,
                  textInputAction: TextInputAction.next, // đổi nút enter thành nút next trên bàn phím
                  onFieldSubmitted: (value) {
                    // requestfocus chuyển con trỏ nhập liệu sang ô email
                    FocusScope.of(context).requestFocus(focusEmail);
                  },
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(), // vẽ khung viền xung quanh ô
                  ),
                  validator: (value) {
                    // isempty kiểm tra xem ô có bị bỏ trống không
                    if (value == null || value.isEmpty == true) {
                      return 'Name is required';
                    }
                    return null; // trả về null là dữ liệu hợp lệ
                  },
                ),

                SizedBox(height: 12),

                // ô nhập email
                TextFormField(
                  controller: emailController,
                  focusNode: focusEmail,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(focusPassword);
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty == true) {
                      return 'Email is required';
                    }
                    // contains() kiểm tra xem chuỗi có chứa ký tự @ và dấu . hay không
                    if (value.contains('@') == false || value.contains('.') == false) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 12),

                // ô nhập mật khẩu
                TextFormField(
                  controller: passwordController,
                  focusNode: focusPassword,
                  obscureText: true, // ẩn nội dung mật khẩu thành các dấu chấm tròn
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(focusConfirmPassword);
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty == true) {
                      return 'Password is required';
                    }
                    // length đếm số ký tự của chuỗi
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    // regexp kiểm tra mật khẩu có chứa ít nhất 1 chữ số từ 0 đến 9 hay không
                    if (RegExp(r'[0-9]').hasMatch(value) == false) {
                      return 'Password must contain at least 1 digit';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 12),

                // ô nhập lại mật khẩu
                TextFormField(
                  controller: confirmPasswordController,
                  focusNode: focusConfirmPassword,
                  obscureText: true,
                  textInputAction: TextInputAction.done, // đổi nút bàn phím thành nút done hoàn thành
                  onFieldSubmitted: (value) {
                    submitForm(); // bấm nút done trên bàn phím thì tự động gửi form
                  },
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty == true) {
                      return 'Confirm password is required';
                    }
                    // so sánh trực tiếp chuỗi với nội dung trong ô mật khẩu
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),

                // nút gửi form đăng ký
                ElevatedButton(
                  // gán onpressed = null để vô hiệu hóa nút bấm khi đang chạy kiểm tra
                  onPressed: isChecking == true ? null : submitForm,
                  child: isChecking == true
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2), // xoay tròn tải dữ liệu
                  )
                      : Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}