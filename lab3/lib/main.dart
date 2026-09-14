import 'dart:async';

// ==========================================
// EXERCISE 1: Product Model & Repository
// ==========================================
class Product {
  final int id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});

  @override
  String toString() => 'Product(id: $id, name: $name, price: \$$price)';
}

class ProductRepository {
  final List<Product> _products = [
    Product(id: 1, name: 'Laptop', price: 999.99),
    Product(id: 2, name: 'Mouse', price: 25.50),
  ];

  // StreamController.broadcast để cho phép nhiều subscriber
  final StreamController<Product> _controller = StreamController<Product>.broadcast();

  // Lấy toàn bộ sản phẩm (Giả lập Future)
  Future<List<Product>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _products;
  }

  // Luồng phát sản phẩm mới theo thời gian thực
  Stream<Product> liveAdded() => _controller.stream;

  // Thêm sản phẩm mới và bắn sự kiện ra Stream
  void addProduct(Product product) {
    _products.add(product);
    _controller.sink.add(product);
  }

  void dispose() {
    _controller.close();
  }
}

// ==========================================
// EXERCISE 2: User Repository with JSON
// ==========================================
class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  // Factory constructor chuyển từ JSON Map sang User Object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  @override
  String toString() => 'User(name: $name, email: $email)';
}

class UserRepository {
  Future<List<User>> fetchUsers() async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Giả lập chuỗi dữ liệu JSON nhận từ API
    final List<Map<String, dynamic>> apiResponse = [
      {"name": "Nguyen Van A", "email": "ana@gmail.com"},
      {"name": "Tran Van B", "email": "bob@gmail.com"},
    ];

    return apiResponse.map((json) => User.fromJson(json)).toList();
  }
}

// ==========================================
// EXERCISE 3: Async + Microtask Debugging
// ==========================================
void runExercise3() {
  print("\n--- Exercise 3: Microtask & Event Loop ---");
  print("1. Synchronous Code (Start)");

  // Thêm task vào Event Queue
  Future(() {
    print("4. Event Queue Task (Future)");
  });

  // Thêm task vào Microtask Queue
  scheduleMicrotask(() {
    print("3. Microtask Queue Task (scheduleMicrotask)");
  });

  print("2. Synchronous Code (End)");
  /*
    Giải thích thứ tự in:
    1 & 2: Chạy đồng bộ (Sync) ngay lập tức.
    3: Microtask queue được ưu tiên xử lý ngay sau khi Sync code hoàn tất.
    4: Event queue (Future) chỉ được xử lý sau khi Microtask queue đã trống hoàn toàn.
  */
}

// ==========================================
// EXERCISE 4: Stream Transformation
// ==========================================
Future<void> runExercise4() async {
  print("\n--- Exercise 4: Stream Transformation ---");

  // Tạo stream chứa các số từ 1 đến 5
  final Stream<int> numbersStream = Stream.fromIterable([1, 2, 3, 4, 5]);

  // Biến đổi stream: tính bình phương và chỉ lọc lấy số chẵn
  final transformedStream = numbersStream
      .map((number) => number * number) // Bình phương: 1, 4, 9, 16, 25
      .where((square) => square % 2 == 0); // Lọc số chẵn: 4, 16

  // Lắng nghe và in kết quả từ stream đã biến đổi
  await for (var value in transformedStream) {
    print("Emitted Even Square: $value");
  }
}

// ==========================================
// EXERCISE 5: Factory Constructors & Cache
// ==========================================
class Settings {
  final String theme;

  // Constructor riêng tư
  Settings._internal(this.theme);

  // Biến static lưu trữ bản thể duy nhất (Singleton)
  static Settings? _cache;

  // Factory constructor kiểm tra cache trước khi tạo mới
  factory Settings([String theme = 'Dark']) {
    _cache ??= Settings._internal(theme);
    return _cache!;
  }
}

void runExercise5() {
  print("\n--- Exercise 5: Factory Constructor & Cache ---");

  var settings1 = Settings("Dark Mode");
  var settings2 = Settings("Light Mode"); // Sẽ không tạo mới mà trả về instance cũ

  print("Settings 1 theme: ${settings1.theme}");
  print("Settings 2 theme: ${settings2.theme}");

  // Kiểm tra 2 biến có trỏ cùng 1 vị trí bộ nhớ không
  bool isSame = identical(settings1, settings2);
  print("identical(settings1, settings2) -> $isSame");
}

// ==========================================
// MAIN FUNCTION RUNNING ALL EXERCISES
// ==========================================
void main() async {
  print("================ LAB 3 OUTPUT ================");

  // Run Ex 1
  print("\n--- Exercise 1: Product Model & Repository ---");
  final productRepo = ProductRepository();

  // Đăng ký lắng nghe Stream
  productRepo.liveAdded().listen((product) {
    print("[Live Stream Update] Added: $product");
  });

  List<Product> products = await productRepo.getAll();
  print("All initial products: $products");

  // Phát sự kiện mới vào stream
  productRepo.addProduct(Product(id: 3, name: 'Keyboard', price: 45.0));
  await Future.delayed(const Duration(milliseconds: 100)); // Đợi stream xử lý

  // Run Ex 2
  print("\n--- Exercise 2: User Repository with JSON ---");
  final userRepo = UserRepository();
  List<User> users = await userRepo.fetchUsers();
  print("Parsed Users from JSON: $users");

  // Run Ex 3
  runExercise3();
  await Future.delayed(const Duration(milliseconds: 100));

  // Run Ex 4
  await runExercise4();

  // Run Ex 5
  runExercise5();

  productRepo.dispose();
  print("\n==============================================");
}