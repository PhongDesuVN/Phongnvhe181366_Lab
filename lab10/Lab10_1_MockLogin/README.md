# Lab10_1_MockLogin

## Giới thiệu
Dự án mô phỏng quá trình đăng nhập (Backend Simulation) với Flutter:
- Form đăng nhập có đầy đủ validation (kiểm tra rỗng, độ dài).
- Giả lập độ trễ mạng với `Future.delayed(Duration(seconds: 2))` và cấp mock token.
- Chuyển hướng sang màn hình Home khi thông tin chính xác, hiển thị lỗi khi sai.

## Hướng dẫn chạy
```bash
flutter pub get
flutter run
```

## Tài khoản kiểm thử (Test Account)
- **Tài khoản hợp lệ:**
  - Email / Username: `student@fpt.edu.vn`
  - Mật khẩu: `password123`
- **Tài khoản không hợp lệ:**
  - Nhập bất kỳ email/mật khẩu nào khác để xem thông báo lỗi hiển thị.
