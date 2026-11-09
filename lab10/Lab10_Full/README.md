# Lab10_Full – Final Integrated Project

## Giới thiệu
Dự án tổng hợp tích hợp toàn bộ các tính năng từ Lab 10.1 đến Lab 10.5 theo yêu cầu môn học PRM392:
1. **SplashScreen Routing & Auto-login (Lab 10.3):**
   - Khởi động kiểm tra token lưu trong `SharedPreferences`.
   - Tự động vào `HomeScreen` nếu đã đăng nhập; chuyển về `LoginScreen` nếu chưa có phiên.
2. **Real REST API Login (Lab 10.2):**
   - Đăng nhập xác thực với DummyJSON (`https://dummyjson.com/auth/login`).
   - Xử lý Form validation đầy đủ, hiển thị loading và bắt lỗi mạng / sai thông tin.
3. **Firebase Google Sign-In (Lab 10.4):**
   - Tích hợp đăng nhập Google bằng `firebase_core`, `firebase_auth`, `google_sign_in`.
   - Có kèm chế độ Demo Google Profile dành cho máy ảo không có Google Play Services.
4. **Local Notification (Lab 10.5 & LO7):**
   - Tự động xin quyền thông báo trên Android 13+ (`POST_NOTIFICATIONS`).
   - **Tự động kích hoạt phát thông báo ngay sau khi đăng nhập thành công** (cả qua API và Google).
   - Có thêm nút phát thông báo thử nghiệm thủ công trên màn hình Home.
5. **Session Management & Logout (Lab 10.3 & 10.4):**
   - Nút Logout thực hiện xóa sạch dữ liệu phiên trong `SharedPreferences`, đồng thời gọi `FirebaseAuth.instance.signOut()` và `GoogleSignIn().signOut()`.

## Hướng dẫn chạy
```bash
flutter pub get
flutter run
```

## Tài khoản kiểm thử (Test Accounts)
- **Tài khoản Real API DummyJSON:**
  - Username: `emilys`
  - Password: `emilyspass`
- **Tài khoản Google:** Bấm nút "Đăng nhập với Google (Firebase)" hoặc bấm nút "Thử nghiệm mẫu Profile Google".
