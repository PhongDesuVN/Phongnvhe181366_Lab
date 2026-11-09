# Lab10_5_Notification

## Giới thiệu
Ứng dụng demo tích hợp Local Notification trên Flutter (chuẩn đầu ra LO7):
- Sử dụng package `flutter_local_notifications`.
- Khai báo quyền `POST_NOTIFICATIONS` trong `AndroidManifest.xml`.
- Tự động gọi xin quyền thông báo lúc khởi chạy ứng dụng trên Android 13+ (API 33+).
- Cung cấp giao diện kiểm tra quyền và form kích hoạt thông báo thủ công (Manual Trigger) với tiêu đề và nội dung tùy chỉnh.
- Hiển thị thông báo trên khay hệ thống (System Notification Tray) với channel ID, tầm quan trọng cao (`Importance.max`), ưu tiên cao (`Priority.high`).

## Hướng dẫn chạy
```bash
flutter pub get
flutter run
```

## Các bước kiểm thử (Testing)
1. Mở ứng dụng. Nếu máy/giả lập là Android 13 trở lên, popup xin quyền thông báo sẽ xuất hiện -> Chọn "Allow" / "Cho phép".
2. Nhập tiêu đề và nội dung thông báo (hoặc để mặc định).
3. Bấm nút **"KÍCH HOẠT THÔNG BÁO (MANUAL TRIGGER)"**.
4. Kéo thanh Notification của Android xuống để kiểm tra thông báo xuất hiện.
