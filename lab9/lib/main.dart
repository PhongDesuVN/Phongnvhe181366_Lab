import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // dùng rootBundle để đọc file trong assets
import 'package:path_provider/path_provider.dart'; // lấy đường dẫn bộ nhớ máy
import 'dart:convert'; // giải mã và mã hóa JSON
import 'dart:io'; // làm việc với File

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 9 Local JSON',
      home: LocalJsonScreen(),
    );
  }
}

// 1. Model dữ liệu
class Item {
  int id;
  String title;
  String desc;

  Item({
    required this.id,
    required this.title,
    required this.desc,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as int,
      title: json['title'].toString(),
      desc: json['desc'].toString(),
    );
  }

  // Chuyển đối tượng Item thành Map để lưu vào JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
    };
  }
}

// 2. Màn hình chính
class LocalJsonScreen extends StatefulWidget {
  @override
  LocalJsonScreenState createState() {
    return LocalJsonScreenState();
  }
}

class LocalJsonScreenState extends State<LocalJsonScreen> {
  List<Item> items = [];
  bool isLoading = true;

  TextEditingController searchController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  String searchText = '';

  @override
  void initState() {
    super.initState();
    loadData(); // đọc dữ liệu khi mở ứng dụng
  }

  // Hàm lấy file lưu trữ trên thiết bị
  Future<File> getLocalFile() async {
    Directory dir = await getApplicationDocumentsDirectory();
    return File(dir.path + '/data.json');
  }

  // Hàm đọc dữ liệu (Ưu tiên đọc file bộ nhớ máy, nếu chưa có thì đọc file Assets)
  Future<void> loadData() async {
    try {
      File file = await getLocalFile();
      String jsonString = '';

      // Kiểm tra nếu file ở bộ nhớ máy đã tồn tại
      if (await file.exists() == true) {
        jsonString = await file.readAsString();
      } else {
        // Lab 9.1: Đọc từ Assets nếu chưa có file local
        jsonString = await rootBundle.loadString('assets/items.json');
        await file.writeAsString(jsonString); // Tạo luôn file ở bộ nhớ máy
      }

      List<dynamic> rawList = jsonDecode(jsonString);
      List<Item> loadedItems = [];

      for (int i = 0; i < rawList.length; i = i + 1) {
        Map<String, dynamic> map = rawList[i];
        loadedItems.add(Item.fromJson(map));
      }

      setState(() {
        items = loadedItems;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Hàm lưu danh sách vào file JSON local
  Future<void> saveData() async {
    File file = await getLocalFile();
    List<dynamic> mapList = []; // dùng List<dynamic> để tránh lỗi kiểu dữ liệu

    // Tạo Map thủ công cho từng item bằng vòng lặp for
    for (int i = 0; i < items.length; i = i + 1) {
      Map<String, dynamic> itemMap = {
        'id': items[i].id,
        'title': items[i].title,
        'desc': items[i].desc,
      };
      mapList.add(itemMap);
    }

    // Mã hóa mảng thành chuỗi JSON và ghi vào file
    String jsonString = jsonEncode(mapList);
    await file.writeAsString(jsonString);
  }

  // Thêm mới 1 item
  void addItem() {
    if (titleController.text.isEmpty == true) {
      return;
    }

    int newId = 1;
    if (items.length > 0) {
      newId = items[items.length - 1].id + 1; // Tạo ID tự tăng
    }

    Item newItem = Item(
      id: newId,
      title: titleController.text,
      desc: descController.text,
    );

    setState(() {
      items.add(newItem);
    });

    saveData(); // Tự động lưu sau khi thêm
    titleController.clear();
    descController.clear();
    Navigator.pop(context);
  }

  // Sửa item
  void editItem(int index) {
    setState(() {
      items[index].title = titleController.text;
      items[index].desc = descController.text;
    });

    saveData(); // Tự động lưu sau khi sửa
    titleController.clear();
    descController.clear();
    Navigator.pop(context);
  }

  // Xóa item
  void deleteItem(int id) {
    // Tìm vị trí item cần xóa bằng vòng lặp for
    int removeIndex = -1;
    for (int i = 0; i < items.length; i = i + 1) {
      if (items[i].id == id) {
        removeIndex = i;
        break;
      }
    }

    if (removeIndex != -1) {
      setState(() {
        items.removeAt(removeIndex);
      });
      saveData(); // Tự động lưu sau khi xóa
    }
  }

  // Hiện hộp thoại thêm/sửa
  void showFormDialog(Item? item, int? index) {
    if (item != null) {
      titleController.text = item.title;
      descController.text = item.desc;
    } else {
      titleController.clear();
      descController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item == null ? 'Thêm công việc' : 'Sửa công việc'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Tiêu đề'),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(labelText: 'Mô tả'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                if (item == null) {
                  addItem();
                } else {
                  editItem(index!);
                }
              },
              child: Text(item == null ? 'Thêm' : 'Lưu'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách theo từ khóa tìm kiếm (Lab 9.3)
    List<Item> filteredItems = [];
    for (int i = 0; i < items.length; i = i + 1) {
      String titleLower = items[i].title.toLowerCase();
      String searchLower = searchText.toLowerCase();
      if (titleLower.contains(searchLower) == true) {
        filteredItems.add(items[i]);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('JSON Local CRUD (Lab 9)'),
      ),
      body: isLoading == true
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Thanh tìm kiếm (Lab 9.3)
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Tìm kiếm tiêu đề...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                setState(() {
                  searchText = text;
                });
              },
            ),
            SizedBox(height: 16),

            // Danh sách hiển thị
            Expanded(
              child: filteredItems.isEmpty == true
                  ? Center(child: Text('Không có dữ liệu'))
                  : ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  Item item = filteredItems[index];

                  // Tìm chỉ số index thật trong mảng items để sửa
                  int realIndex = -1;
                  for (int i = 0; i < items.length; i = i + 1) {
                    if (items[i].id == item.id) {
                      realIndex = i;
                      break;
                    }
                  }

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(item.id.toString()),
                      ),
                      title: Text(item.title),
                      subtitle: Text(item.desc),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Nút sửa
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              showFormDialog(item, realIndex);
                            },
                          ),
                          // Nút xóa
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              deleteItem(item.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showFormDialog(null, null);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}