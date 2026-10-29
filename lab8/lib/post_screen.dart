import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // thư viện gửi yêu cầu lấy dữ liệu từ mạng internet
import 'dart:convert'; // thư viện dùng hàm jsondecode để giải mã chuỗi json

// khuôn mẫu dữ liệu bài viết
class Post {
  int id;
  String title;
  String body;

  Post({
    required this.id,
    required this.title,
    required this.body,
  });

  // factory tạo đối tượng post từ map json
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      title: json['title'].toString(), // ép sang chuỗi cho an toàn
      body: json['body'].toString(),
    );
  }
}

// lớp gọi api lấy dữ liệu
class ApiService {
  // async và future dùng cho hàm xử lý mất thời gian chờ dữ liệu từ mạng
  Future<List<Post>> fetchPosts() async {
    Uri url = Uri.parse('https://jsonplaceholder.typicode.com/posts');

    // await tạm dừng đợi máy chủ phản hồi
    var response = await http.get(url);

    // statuscode == 200 là lấy dữ liệu thành công
    if (response.statusCode == 200) {
      // jsondecode chuyển chuỗi chữ thành danh sách mảng dữ liệu
      List<dynamic> rawList = jsonDecode(response.body);
      List<Post> postList = [];

      // vòng lặp for duyệt từng phần tử và đổi thành đối tượng post
      for (int i = 0; i < rawList.length; i = i + 1) {
        Map<String, dynamic> item = rawList[i];
        Post p = Post.fromJson(item);
        postList.add(p);
      }

      return postList;
    } else {
      // quăng ra lỗi nếu không lấy được dữ liệu
      throw Exception('Failed to load posts');
    }
  }
}

class PostScreen extends StatefulWidget {
  @override
  PostScreenState createState() {
    return PostScreenState();
  }
}

class PostScreenState extends State<PostScreen> {
  ApiService apiService = ApiService();
  late Future<List<Post>> futurePosts; // biến chứa dữ liệu bất đồng bộ cần chờ

  @override
  void initState() {
    super.initState();
    // gọi lấy dữ liệu ngay khi vừa mở màn hình
    futurePosts = apiService.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Posts List'),
      ),
      // futurebuilder tự vẽ giao diện theo từng trạng thái tải dữ liệu
      body: FutureBuilder<List<Post>>(
        future: futurePosts,
        builder: (context, snapshot) {
          // 1. kiểm tra khi ứng dụng đang kết nối mạng tải dữ liệu
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(), // xoay tròn tải dữ liệu
            );
          }

          // 2. kiểm tra nếu bị lỗi kết nối
          if (snapshot.hasError == true) {
            return Center(
              child: Text('Error: ' + snapshot.error.toString()),
            );
          }

          // 3. kiểm tra nếu đã có dữ liệu thành công
          if (snapshot.hasData == true) {
            List<Post> posts = snapshot.data!; // dấu ! khẳng định dữ liệu không null

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                Post post = posts[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(post.id.toString()),
                    ),
                    title: Text(post.title),
                    subtitle: Text(post.body),
                  ),
                );
              },
            );
          }

          return Center(
            child: Text('No data found'),
          );
        },
      ),
    );
  }
}