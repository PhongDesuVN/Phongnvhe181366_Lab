import 'dart:async';
void runExercise1() {
  // Khai báo các kiểu dữ liệu cơ bản
  int age = 22;
  double gpa = 3.8;
  String studentName = "Nguyen Van Phong";
  bool isEnrolled = true;

  // In giá trị ra console dùng String Interpolation
  print("Student Name: $studentName");
  print("Age: $age");
  print("GPA: $gpa");
  print("Is Enrolled: $isEnrolled");

  // Sử dụng biểu thức ${expr} trực tiếp trong chuỗi
  print("Age next year: ${age + 1}");
}
void runExercise2() {
  // 1. List (Danh sách có thứ tự)
  List<int> numbers = [10, 20, 30];
  numbers.add(40);        // Thêm phần tử vào cuối List
  numbers.remove(10);     // Xóa giá trị 10 khỏi List
  print("List numbers: $numbers");
  print("First element (index 0): ${numbers[0]}");

  // 2. Toán tử số học, so sánh và toán tử ba ngôi (? :)
  int sum = numbers[0] + numbers[1]; // 20 + 30 = 50
  bool isGreater = numbers[1] > numbers[0]; // 30 > 20
  String status = (sum >= 50) ? "Passed" : "Failed";

  print("Sum of first two elements: $sum");
  print("Is second item greater than first? $isGreater");
  print("Status: $status");

  // 3. Set (Tập hợp giá trị duy nhất, loại bỏ trùng lặp)
  Set<String> categories = {"Flutter", "Dart", "Flutter"}; // "Flutter" bị trùng
  categories.add("Mobile");
  print("Unique Set: $categories");

  // 4. Map (Tập hợp dạng cặp Key-Value)
  Map<String, String> course = {
    "code": "PRM392",
    "title": "Mobile Programming"
  };
  course["room"] = "LAB301"; // Thêm cặp key-value mới
  print("Course Map: $course");
  print("Course Code: ${course['code']}"); // Truy cập qua key
}


// Hàm thông thường (Normal Syntax)
int calculateArea(int width, int height) {
  return width * height;
}

// Hàm mũi tên (Arrow Syntax)
bool isEven(int number) => number % 2 == 0;

void runExercise3() {
  // 1. Kiểm tra score bằng if / else
  int score = 85;
  if (score >= 90) {
    print("Grade: A");
  } else if (score >= 70) {
    print("Grade: B");
  } else {
    print("Grade: C");
  }

  // 2. Switch-case cho ngày trong tuần
  int day = 2;
  switch (day) {
    case 1:
      print("Day: Monday");
      break;
    case 2:
      print("Day: Tuesday");
      break;
    default:
      print("Day: Unknown");
  }

  // 3. Các dạng vòng lặp
  List<String> fruits = ["Apple", "Banana", "Orange"];

  print("-- Standard For Loop --");
  for (int i = 0; i < fruits.length; i++) {
    print("Fruit $i: ${fruits[i]}");
  }

  print("-- For-In Loop --");
  for (var fruit in fruits) {
    print("Fruit item: $fruit");
  }

  print("-- forEach Loop --");
  fruits.forEach((fruit) => print("forEach item: $fruit"));

  // 4. Gọi hàm
  print("Area: ${calculateArea(5, 10)}");
  print("Is 4 even? ${isEven(4)}");
}



// Lớp cha
class Car {
  String brand;

  // Constructor mặc định
  Car(this.brand);

  // Named Constructor (Constructor có tên riêng)
  Car.named(this.brand) {
    print("Creating car with named constructor: $brand");
  }

  // Phương thức của lớp cha
  void drive() {
    print("The $brand car is driving on fuel.");
  }
}

// Lớp con kế thừa từ Car
class ElectricCar extends Car {
  int batteryCapacity;

  // Constructor lớp con gọi constructor lớp cha qua từ khóa 'super'
  ElectricCar(String brand, this.batteryCapacity) : super(brand);

  // Ghi đè phương thức drive() của lớp cha
  @override
  void drive() {
    print("The $brand electric car is driving with $batteryCapacity kWh battery.");
  }
}

void runExercise4() {
  // Khởi tạo từ constructor mặc định
  Car car1 = Car("Toyota");
  car1.drive();

  // Khởi tạo từ named constructor
  Car car2 = Car.named("Honda");
  car2.drive();

  // Khởi tạo lớp con ElectricCar
  ElectricCar tesla = ElectricCar("Tesla", 100);
  tesla.drive(); // Đã được override
}


// Hàm giả lập tải dữ liệu bất đồng bộ bằng Future.delayed
Future<String> fetchUserData() async {
  await Future.delayed(Duration(seconds: 1)); // Tải giả lập trong 1 giây
  return "Data loaded successfully!";
}

// Hàm tạo Stream phát ra 3 số nguyên liên tiếp
Stream<int> generateNumbers() async* {
  for (int i = 1; i <= 3; i++) {
    await Future.delayed(Duration(milliseconds: 500));
    yield i; // Phát giá trị ra Stream
  }
}

Future<void> runExercise5() async {
  // 1. Null Safety operators
  String? nullableName; // Dấu '?' cho phép nhận giá trị null
  print("Nullable name: $nullableName");

  // Toán tử '??' cung cấp giá trị mặc định khi biến bị null
  String nameToDisplay = nullableName ?? "Guest";
  print("Display name (using ??): $nameToDisplay");

  nullableName = "John";
  // Toán tử '!' ép kiểu khẳng định biến không null
  print("Upper name (using !): ${nullableName!.toUpperCase()}");

  // 2. Async/Await & Future
  print("\nFetching data...");
  String data = await fetchUserData(); // Chờ hoàn thành
  print("Result: $data");

  // 3. Stream
  print("\nListening to Stream...");
  await for (int val in generateNumbers()) {
    print("Stream value: $val");
  }
}


void main() async {
  print("================ EXERCISE 1 ================");
  runExercise1();

  print("\n================ EXERCISE 2 ================");
  runExercise2();

  print("\n================ EXERCISE 3 ================");
  runExercise3();

  print("\n================ EXERCISE 4 ================");
  runExercise4();

  print("\n================ EXERCISE 5 ================");
  await runExercise5();
}