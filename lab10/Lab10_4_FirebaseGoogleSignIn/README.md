# Lab10_4_FirebaseGoogleSignIn

## Giới thiệu
Ứng dụng tích hợp đăng nhập tài khoản Google thông qua Firebase Authentication:
- Sử dụng các thư viện `firebase_core`, `firebase_auth`, `google_sign_in`.
- Triển khai luồng Google Sign-In: Đăng nhập Google, lấy accessToken + idToken, tạo `OAuthCredential` và xác thực với Firebase.
- Hiển thị thông tin hồ sơ người dùng đăng nhập: Ảnh đại diện Google, Tên hiển thị, Email, Firebase UID.
- Chức năng đăng xuất đồng thời khỏi Firebase Auth và GoogleSignIn.
- Có sẵn chế độ Demo/Offline Preview để kiểm tra giao diện khi chạy trên máy ảo chưa cấu hình SHA-1 hoặc thiếu Google Play Services.

## Hướng dẫn chạy
```bash
flutter pub get
flutter run
```

## Cấu hình Firebase
- File `google-services.json` đã được đặt tại thư mục `android/app/google-services.json`.
- Cấu hình FirebaseOptions đã được thiết lập sẵn trong `main.dart`.
