import 'package:flutter/material.dart';

// 1. lớp dữ liệu phim đơn giản
class Movie {
  int id;
  String title;
  String posterUrl;
  double rating;
  List<String> genres;
  String overview;
  List<String> trailers;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.rating,
    required this.genres,
    required this.overview,
    required this.trailers,
  });
}

// 2. danh sách dữ liệu mẫu
List<Movie> sampleMovies = [
  Movie(
    id: 1,
    title: 'Dune: Part Two',
    posterUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=500',
    rating: 8.6,
    genres: ['Sci-Fi', 'Adventure', 'Drama'],
    overview: 'Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family.',
    trailers: ['Official Trailer #1', 'IMAX Sneak Peek'],
  ),
  Movie(
    id: 2,
    title: 'Deadpool & Wolverine',
    posterUrl: 'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=500',
    rating: 8.3,
    genres: ['Action', 'Comedy'],
    overview: 'The multiverse gets messy when Wade Wilson teams up with Wolverine for a not-so-family-friendly mission.',
    trailers: ['Red Band Trailer', 'Behind the Scenes'],
  ),
];

// 3. màn hình 1: danh sách phim
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
      ),
      // danh sách cuộn hiển thị các bộ phim
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: sampleMovies.length, // số lượng phim trong danh sách
        itemBuilder: (context, index) {
          Movie movie = sampleMovies[index]; // lấy phim theo vị trí index

          return Card(
            child: ListTile(
              // ảnh poster bên trái
              leading: Image.network(
                movie.posterUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,// cắt ảnh vừa khung
              ),
              // tên phim
              title: Text(
                movie.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // điểm đánh giá và thể loại
              subtitle: Text(
                '☆ ' + movie.rating.toString() + ' • ' + movie.genres.join(', '),
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              // bấm chuyển sang màn hình chi tiết và truyền đối tượng phim
              onTap: () {  // sự kiện khi bấm vào dòng phim
                Navigator.push(  // chuyển màn hình mới
                  context,  // ngữ cảnh giao diện hiện tại
                  MaterialPageRoute(  // tạo đường dẫn chuyển trang kiểu material
                    builder: (context) => MovieDetailScreen(selectedMovie: movie),// mở màn hình chi tiết và truyền đối tượng movie
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// 4. màn hình 2: chi tiết phim
class MovieDetailScreen extends StatefulWidget {
  final Movie selectedMovie; // biến nhận dữ liệu phim truyền sang

  MovieDetailScreen({required this.selectedMovie});

  @override
  MovieDetailScreenState createState() {
    return MovieDetailScreenState();
  }
}

class MovieDetailScreenState extends State<MovieDetailScreen> {
  // biến lưu trạng thái nút yêu thích
  bool isFavorite = false;
  bool isRated = false;

  @override
  Widget build(BuildContext context) {
    Movie movie = widget.selectedMovie; // lấy dữ liệu phim ra dùng

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title), // tiêu đề appbar là tên phim
      ),
      // bọc cuộn trang để không bị lỗi tràn màn hình
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. ảnh banner phim
            Image.network(
              movie.posterUrl,
              width: double.infinity, // chiều rộng tràn hết màn hình
              height: 200,
              fit: BoxFit.cover,  // cắt ảnh phủ kín khung
            ),

            SizedBox(height: 10),

            // 2. tên phim và các thẻ thể loại
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  // chứa các thẻ chip thể loại
                  Wrap(
                    spacing: 8,
                    children: movie.genres.map((g) {
                      return Chip(label: Text(g));
                    }).toList(),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            // 3. nội dung tóm tắt phim
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                movie.overview,
                style: TextStyle(fontSize: 15),
              ),
            ),

            SizedBox(height: 15),

            // 4. hàng nút tương tác
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // nút favorite dùng setstate để cập nhật giao diện
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        isFavorite == true ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite == true ? Colors.red : Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          // đảo trạng thái bật tắt thủ công
                          if (isFavorite == true) {
                            isFavorite = false;
                          } else {
                            isFavorite = true;
                          }
                        });
                      },
                    ),
                    Text('Favorite'),
                  ],
                ),

                // nút rate
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        isRated == true ? Icons.star : Icons.star_border, // kiểm tra true hiện sao hoặc false hiện sao rỗng
                        color: isRated == true ? Colors.amber : Colors.black, // true màu vàng amber false màu đen
                      ),
                      onPressed: () {
                        setState(() {
                          // đảo trạng thái bật tắt thủ công
                          if (isRated == true) {
                            isRated = false;
                          } else {
                            isRated = true;
                          }
                        });
                      },
                    ),
                    Text('Rate'),
                  ],
                ),

                // nút share
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () {},
                    ),
                    Text('Share'),
                  ],
                ),
              ],
            ),

            SizedBox(height: 15),

            // 5. danh sách trailer
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Trailers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // hiển thị từng dòng trailer từ danh sách
            Column(
              children: movie.trailers.map((t) {
                return ListTile(
                  leading: Icon(Icons.play_circle_fill),
                  title: Text(t),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}