# Lab10_3_AutoLogin_Logout

## Giới thiệu
Dự án cài đặt cơ chế tự động đăng nhập (Auto Login) và quản lý phiên (Session Management) với `SharedPreferences`:
- `SplashScreen`: Kiểm tra xem token có trong `SharedPreferences` hay không. Nếu có thì tự động vào `HomeScreen`, nếu không thì chuyển hướng vào `LoginScreen`.
- `LoginScreen`: Đăng nhập qua REST API DummyJSON, lưu `token`, `username`, `fullName` vào `SharedPreferences`.
- `HomeScreen`: Hiển thị thông tin phiên làm việc. Nút `Đăng xuất` sẽ xóa token khỏi bộ nhớ cục bộ và đưa người dùng về lại màn hình Login.

## Hướng dẫn chạy
```bash
flutter pub get
flutter run
```

## Tài khoản kiểm thử
- Username: `emilys`
- Password: `emilyspass`

## Thao tác kiểm tra Auto Login
1. Đăng nhập bằng tài khoản trên.
2. Tắt hẳn ứng dụng (Kill app).
3. Mở lại ứng dụng: Màn hình Splash sẽ tự động nhận diện token và đưa thẳng vào Home không cần đăng nhập lại.
4. Bấm `Đăng xuất` rồi tắt mở lại: Ứng dụng sẽ yêu cầu đăng nhập lại vì token đã bị xóa.
