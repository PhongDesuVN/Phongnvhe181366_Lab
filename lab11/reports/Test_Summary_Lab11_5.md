# LAB 11.5 — TEST SUITE SUMMARY DOCUMENT

**Môn học:** PRM392 - Flutter Mobile Development  
**Ứng dụng:** Taskly App  

---

## 1. Cấu trúc thư mục kiểm thử (Test Suite Structure)
Toàn bộ bộ kiểm thử đã được gom nhóm và phân loại rõ ràng trong thư mục `test/`:

```text
test/
 ├─ unit/
 │   ├─ task_model_test.dart
 │   └─ task_repository_test.dart
 ├─ widget/
 │   ├─ task_list_widget_test.dart
 │   ├─ task_navigation_test.dart
 │   └─ task_integration_test.dart
 └─ integration/
     └─ task_integration_test.dart
```

---

## 2. Thống kê số lượng và phân loại bài test (Number & Types of Tests)
Khi chạy lệnh `flutter test`, toàn bộ **11/11 test cases** đều **PASS (100%)**:

| Loại kiểm thử (Test Type) | File kiểm thử | Số lượng Test Cases | Kết quả |
| :--- | :--- | :---: | :---: |
| **1. Unit Tests** | `test/unit/task_model_test.dart` | 2 | PASS |
| **1. Unit Tests** | `test/unit/task_repository_test.dart` | 3 | PASS |
| **2. Widget Tests** | `test/widget/task_list_widget_test.dart` | 3 | PASS |
| **3. Navigation Tests** | `test/widget/task_navigation_test.dart` | 1 | PASS |
| **4. Integration Tests** | `test/widget/task_integration_test.dart` & `test/integration/task_integration_test.dart` | 2 | PASS |
| **TỔNG CỘNG** | **6 files** | **11 test cases** | **100% PASS** |

---

## 3. Các hành vi đã được kiểm chứng (Behaviors Validated)
1. **Logic dữ liệu thuần (Unit Testing - Mô hình AAA):**
   - Khởi tạo đối tượng `Task` luôn có trạng thái mặc định `completed = false`.
   - Phương thức `toggle()` đảo ngược chính xác trạng thái giữa `false` và `true`.
   - `TaskRepository` thực hiện đúng các thao tác thêm mới (`addTask`), xóa công việc (`deleteTask`) và cập nhật tiêu đề công việc (`updateTask`).
2. **Giao diện người dùng (Widget Testing):**
   - Hiển thị thông báo trạng thái rỗng `"No tasks yet. Add one!"` khi chưa có dữ liệu.
   - Nhập tiêu đề công việc vào `TextField` và bấm nút `Add` giúp cập nhật danh sách ngay lập tức trên màn hình.
   - Thêm nhiều công việc liên tiếp hiển thị đầy đủ từng mục trên `ListView`.
3. **Điều hướng màn hình (Navigation Testing):**
   - Khởi tạo sẵn dữ liệu mẫu (seeded repository), khi người dùng nhấn vào một công việc trong danh sách, ứng dụng chuyển sang màn hình `TaskDetailScreen` có tiêu đề AppBar `"Task Detail"` và ô nhập liệu mang key `Key('detailTitleField')`.
4. **Luồng tích hợp đầu-cuối (End-to-End Integration Testing):**
   - Mô phỏng trọn vẹn thao tác của người dùng: Thêm mới `"Original title"` -> Nhấn mở màn hình chi tiết -> Sửa tên thành `"Updated title"` -> Bấm `"Save"` -> Quay lại màn hình danh sách và xác nhận `"Updated title"` hiển thị thay cho tên cũ.

---

## 4. Hạn chế hiện tại (Known Limitations)
- **Lưu trữ tạm thời (In-Memory Storage):** Dữ liệu công việc hiện chỉ lưu trong bộ nhớ RAM thông qua `List<Task>` của `TaskRepository`. Khi tắt hoàn toàn ứng dụng và mở lại, dữ liệu sẽ bị mất (chưa tích hợp SQLite hoặc SharedPreferences).
- **Chưa kiểm tra dữ liệu trùng lặp hoặc chuỗi chỉ chứa khoảng trắng:** Nếu người dùng chỉ nhập toàn dấu cách (`"   "`), ứng dụng chưa tự động cắt khoảng trắng (`trim()`) trước khi lưu.
- **Quản lý trạng thái đơn giản:** Ứng dụng sử dụng `setState()` cơ bản của `StatefulWidget` thay vì các thư viện quản lý trạng thái nâng cao (như Provider, Bloc, Riverpod), phù hợp với quy mô nhỏ của bài thực hành.

