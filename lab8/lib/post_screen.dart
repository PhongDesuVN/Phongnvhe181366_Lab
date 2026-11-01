import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // thư viện gọi API
import 'dart:convert'; // thư viện giải mã JSON

// 1. Model dữ liệu
class Post {
  int id;
  String title;
  String body;

  Post({
    required this.id,
    required this.title,
    required this.body,
  });

  // factory khởi tạo đối tượng từ Map JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      title: json['title'].toString(),
      body: json['body'].toString(),
    );
  }
}

// 2. Class gọi API (Service Layer)
class ApiService {
  Future<List<Post>> fetchPosts() async {
    Uri url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> rawList = jsonDecode(response.body); // giải mã chuỗi JSON
      List<Post> postList = [];

      // duyệt mảng JSON thô và chuyển thành List<Post>
      for (int i = 0; i < rawList.length; i = i + 1) {
        Map<String, dynamic> item = rawList[i];
        Post p = Post.fromJson(item);
        postList.add(p);
      }

      return postList;
    } else {
      throw Exception('Failed to load posts');
    }
  }
}

// 3. Màn hình danh sách
class PostScreen extends StatefulWidget {
  @override
  PostScreenState createState() {
    return PostScreenState();
  }
}

class PostScreenState extends State<PostScreen> {
  ApiService apiService = ApiService();
  late Future<List<Post>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = apiService.fetchPosts(); // gọi API 1 lần duy nhất khi mở màn hình
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Posts List'),
      ),
      // FutureBuilder tự động vẽ UI theo 3 trạng thái bất đồng bộ
      body: FutureBuilder<List<Post>>(
        future: futurePosts,
        builder: (context, snapshot) {
          // Trạng thái 1: Đang tải
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Trạng thái 2: Bị lỗi
          if (snapshot.hasError == true) {
            return Center(
              child: Text('Error: ' + snapshot.error.toString()),
            );
          }

          // Trạng thái 3: Có dữ liệu thành công
          if (snapshot.hasData == true) {
            List<Post> posts = snapshot.data!;

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
                    subtitle: Text(
                      post.body,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Chuyển dữ liệu sang màn hình chi tiết
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return PostDetailScreen(post: post);
                          },
                        ),
                      );
                    },
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

// 4. Màn hình chi tiết
class PostDetailScreen extends StatelessWidget {
  final Post post;

  PostDetailScreen({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Detail #' + post.id.toString()),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Đã sửa tên đúng CrossAxisAlignment
          children: [
            Text(
              post.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              post.body,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}