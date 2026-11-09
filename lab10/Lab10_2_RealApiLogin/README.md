# Lab10_2_RealApiLogin

## Giới thiệu
Ứng dụng xác thực người dùng sử dụng REST API thực tế từ DummyJSON (`https://dummyjson.com/auth/login`):
- Gửi HTTP POST request với header `application/json` và body `username`, `password`.
- Quản lý trạng thái loading, parse access token và dữ liệu thông tin người dùng từ API response.
- Xử lý các tình huống lỗi: sai mật khẩu (HTTP 400), lỗi mất kết nối mạng.
- Hiển thị đầy đủ thông tin: Avatar từ API, Họ tên, Email, Username, Access Token.

## Hướng dẫn chạy
```bash
flutter pub get
flutter run
```

## Tài khoản kiểm thử DummyJSON chính thức
- **Tài khoản 1:**
  - Username: `emilys`
  - Password: `emilyspass`
- **Tài khoản 2:**
  - Username: `michaelw`
  - Password: `michaelwpass`
