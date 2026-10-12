import 'package:flutter/material.dart';

// khuôn mẫu dữ liệu phim
class Movie {
  String title;
  int year;
  List<String> genres;
  String posterUrl;
  double rating;

  Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

// mảng dữ liệu phim mẫu
List<Movie> sampleMovies = [
  Movie(
    title: 'Dune: Part Two',
    year: 2024,
    genres: ['Sci-Fi', 'Adventure', 'Drama'],
    posterUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=500',
    rating: 8.6,
  ),
  Movie(
    title: 'Deadpool & Wolverine',
    year: 2024,
    genres: ['Action', 'Comedy'],
    posterUrl: 'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=500',
    rating: 8.3,
  ),
  Movie(
    title: 'The Dark Knight',
    year: 2008,
    genres: ['Action', 'Drama'],
    posterUrl: 'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=500',
    rating: 9.0,
  ),
  Movie(
    title: 'Interstellar',
    year: 2014,
    genres: ['Sci-Fi', 'Drama'],
    posterUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=500',
    rating: 8.7,
  ),
];

class GenreScreen extends StatefulWidget {
  @override
  GenreScreenState createState() {
    return GenreScreenState();
  }
}

class GenreScreenState extends State<GenreScreen> {
  // các biến quản lý trạng thái (state)
  String searchQuery = ''; // lưu chữ nhập từ ô tìm kiếm
  List<String> selectedGenres = []; // lưu danh sách các thể loại được người dùng bấm chọn
  String selectedSort = 'A-Z'; // lưu kiểu sắp xếp hiện tại
  List<String> allGenres = ['Action', 'Drama', 'Comedy', 'Sci-Fi', 'Adventure']; // danh sách tất cả thể loại

  @override
  Widget build(BuildContext context) {
    List<Movie> visibleMovies = []; // danh sách chứa các phim thỏa mãn điều kiện lọc

    //duyệt lần lượt từng bộ phim trong mảng mẫu
    for (int i = 0; i < sampleMovies.length; i = i + 1) {
      Movie m = sampleMovies[i];

      // tolowercase() đổi chữ hoa thành chữ thường, contains() kiểm tra tên phim có chứa chuỗi tìm kiếm không
      bool matchSearch = m.title.toLowerCase().contains(searchQuery.toLowerCase());

      bool matchGenre = false;
      if (selectedGenres.length == 0) {
        matchGenre = true; // chưa chọn thể loại nào thì lấy tất cả phim
      } else {
        // duyệt từng thể loại bên trong bộ phim hiện tại
        for (int j = 0; j < m.genres.length; j = j + 1) {
          // contains() kiểm tra thể loại của phim có nằm trong mảng thể loại đang chọn không
          if (selectedGenres.contains(m.genres[j]) == true) {
            matchGenre = true;
          }
        }
      }

      // thỏa mãn cả điều kiện tìm kiếm và thể loại thì thêm vào danh sách hiển thị
      if (matchSearch == true && matchGenre == true) {
        visibleMovies.add(m);
      }
    }

    // sort() là hàm sắp xếp mảng, compareto() so sánh hai giá trị a và b để xếp thứ tự
    if (selectedSort == 'A-Z') {
      visibleMovies.sort((a, b) => a.title.compareTo(b.title));
    } else if (selectedSort == 'Z-A') {
      visibleMovies.sort((a, b) => b.title.compareTo(a.title));
    } else if (selectedSort == 'Year') {
      visibleMovies.sort((a, b) => b.year.compareTo(a.year)); // so sánh năm phát hành
    } else if (selectedSort == 'Rating') {
      visibleMovies.sort((a, b) => b.rating.compareTo(a.rating)); // so sánh điểm đánh giá
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Find a Movie'),
      ),
      // safearea giúp giao diện tự động tránh phần tai thỏ hoặc camera của điện thoại
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ô nhập từ khóa tìm kiếm
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search movie title...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                // onchanged là hàm tự động chạy mỗi khi người dùng gõ hoặc xóa 1 ký tự
                onChanged: (value) {
                  // setstate thông báo cho flutter biết dữ liệu đã đổi và cần vẽ lại màn hình
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),

              SizedBox(height: 10),

              // wrap là widget tự động xuống dòng cho các phần tử con khi hết chiều rộng màn hình
              Wrap(
                spacing: 8,
                // vòng lặp map: duyệt mảng allgenres và biến mỗi chuỗi g thành một widget filterchip
                children: allGenres.map((g) {
                  bool isSelected = selectedGenres.contains(g);
                  // filterchip là nút dạng thẻ hỗ trợ bật/tắt trạng thái chọn
                  return FilterChip(
                    label: Text(g),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected == true) {
                          selectedGenres.add(g); // thêm thể loại vào mảng
                        } else {
                          selectedGenres.remove(g); // xóa thể loại khỏi mảng
                        }
                      });
                    },
                  );
                }).toList(), // tolist() chuyển kết quả từ map thành một danh sách widget
              ),

              SizedBox(height: 10),

              // menu chọn kiểu sắp xếp
              Row(
                children: [
                  Text('Sort by: '),
                  // dropdownbutton là menu dạng danh sách thả xuống khi bấm vào
                  DropdownButton<String>(
                    value: selectedSort,
                    // vòng lặp map chuyển danh sách chuỗi thành các item dropdownmenuitem
                    items: ['A-Z', 'Z-A', 'Year', 'Rating'].map((s) {
                      return DropdownMenuItem(
                        value: s,
                        child: Text(s),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSort = value!;
                      });
                    },
                  ),
                ],
              ),

              SizedBox(height: 10),

              // expanded ép widget bên trong chiếm toàn bộ khoảng trống còn lại của chiều cao màn hình
              Expanded(
                // layoutbuilder là widget đo kích thước thực tế (chiều rộng/chiều cao) của khung chứa
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // constraints.maxwidth lấy chiều rộng tối đa hiện tại của thiết bị
                    if (constraints.maxWidth < 800) {
                      // màn hình nhỏ dưới 800px (điện thoại) hiện dạng cuộn 1 cột
                      return ListView.builder(
                        itemCount: visibleMovies.length,
                        itemBuilder: (context, index) {
                          Movie movie = visibleMovies[index];
                          return Card(
                            child: ListTile(
                              leading: Image.network(
                                movie.posterUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(movie.title + ' (' + movie.year.toString() + ')'),
                              subtitle: Text('☆ ' + movie.rating.toString() + ' • ' + movie.genres.join(', ')),
                            ),
                          );
                        },
                      );
                    } else {
                      // màn hình to từ 800px trở lên (máy tính bảng / web) hiện dạng lưới gridview 2 cột
                      return GridView.count(
                        crossAxisCount: 2, // chia thành 2 cột
                        childAspectRatio: 3, // tỷ lệ chiều rộng trên chiều cao của từng ô trong lưới
                        // vòng lặp map duyệt mảng phim đã lọc để trả về danh sách các card
                        children: visibleMovies.map((movie) {
                          return Card(
                            child: ListTile(
                              leading: Image.network(
                                movie.posterUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(movie.title + ' (' + movie.year.toString() + ')'),
                              subtitle: Text('☆ ' + movie.rating.toString() + ' • ' + movie.genres.join(', ')),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}