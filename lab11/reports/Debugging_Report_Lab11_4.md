# LAB 11.4 (PART B) — DEBUGGING REPORT (FLUTTER DEVTOOLS)

**Môn học:** PRM392 - Flutter Mobile Development  
**Ứng dụng:** Taskly App  

---

## 1. Giới thiệu
Trong quá trình chạy ứng dụng **Taskly** ở chế độ Debug (`flutter run`) và kiểm tra bằng công cụ **Flutter DevTools** (bao gồm **Widget Inspector** và **Performance Timeline**), em đã phân tích cây Widget cũng như hiệu năng render khung hình (frame) và ghi nhận 2 vấn đề tiềm ẩn thường gặp khi mới lập trình Flutter.

---

## 2. Một vấn đề tiềm ẩn về bố cục (Potential Layout Issue)
- **Mô tả vấn đề:**  
  Ở khu vực nhập công việc mới trên màn hình `TaskListScreen`, thanh nhập liệu (`TextField`) và nút bấm (`ElevatedButton` "Add") được đặt chung trong một `Row`. Nếu người dùng mới học quên bọc `TextField` trong widget `Expanded` (hoặc khi tên công việc hiển thị trong `Row` quá dài mà không giới hạn kích thước), Flutter sẽ báo lỗi tràn viền vàng đen (**RenderFlex overflowed**) do `TextField` mặc định muốn chiếm chiều ngang vô hạn bên trong `Row`.
- **Cách phát hiện bằng DevTools & Widget Test:**  
  - **Widget Inspector (DevTools):** Khi bật chế độ *Select Widget Mode* và mở tab *Layout Explorer*, ta có thể xem trực tiếp các ràng buộc kích thước (`constraints`: `w`, `h`, `flex factor`) của từng phần tử con trong `Row`. Nhờ đó phát hiện ngay widget nào chưa có `Expanded` hoặc đang vượt quá chiều rộng màn hình.
  - **Widget Test:** Khi chạy `pumpWidget()` trên kích thước màn hình nhỏ, Flutter Test sẽ lập tức báo lỗi `A RenderFlex overflowed by ... pixels` nếu bố cục bị tràn.

---

## 3. Một vấn đề tiềm ẩn về hiệu năng (Potential Performance Issue)
- **Mô tả vấn đề:**  
  Trong `TaskListScreen`, mỗi khi thêm công việc mới, đánh dấu hoàn thành (`Checkbox`), hoặc xóa công việc, hàm `setState(() {})` được gọi ở cấp toàn màn hình (`_TaskListScreenState`). Điều này khiến toàn bộ hàm `build()` của màn hình — bao gồm cả `AppBar`, ô nhập `TextField`, nút `Add` và toàn bộ danh sách `ListView.builder` — đều bị vẽ lại (rebuild), dù thực tế chỉ có một dòng công việc hoặc danh sách bên dưới thay đổi. Khi số lượng công việc lên tới hàng trăm hoặc hàng nghìn mục, việc gọi `setState()` toàn màn hình dễ gây sụt giảm tốc độ khung hình (jank / frame drop).
- **Cách phát hiện bằng DevTools & Test:**  
  - **Performance Timeline & Rebuild Stats (DevTools):** Khi bật tùy chọn **Track Widget Rebuilds** trong Flutter DevTools và bấm vào một `Checkbox`, ta thấy bộ đếm số lần rebuild của cả `TaskListScreen`, `Row`, `TextField` đều tăng lên cùng lúc thay vì chỉ riêng `ListTile` được bấm. Trên biểu đồ **Frame Chart**, các thao tác lặp lại liên tục sẽ làm cột thời gian *UI thread* cao hơn bình thường.
  - **Integration Test:** Khi mô phỏng thao tác thêm và sửa nhiều công việc liên tục, ta có thể đo thời gian phản hồi và kiểm tra độ mượt của chuyển cảnh bằng `pumpAndSettle()`.

---

## 4. Hướng dẫn chụp 2 ảnh màn hình DevTools để nộp bài
1. Chạy ứng dụng ở chế độ Debug:
   ```bash
   flutter run -d chrome
   # hoặc chạy trên máy ảo Android / Windows
   ```
2. Nhấn vào đường link **Flutter DevTools** hiện trên Terminal (ví dụ: `http://127.0.0.1:9100/...`).
3. **Ảnh 1 (`widget_inspector.png`):** Mở tab **Flutter Inspector**, bấm vào `TaskListScreen` -> `Scaffold` -> `Column` -> `ListView` để hiện cây Widget và khung **Layout Explorer**, sau đó chụp màn hình.
4. **Ảnh 2 (`performance_timeline.png`):** Mở tab **Performance**, bấm thêm/sửa vài công việc trên app để biểu đồ **Flutter Frames Chart** hiện các cột frame, bấm chọn 1 frame và chụp màn hình.

