class User {
  int id;
  String name;
  String? email;
  User({required this.id, required this.name, this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? 'phong',
      email: json['email'],
    );
  }

  void showProfile() {
    String displayEmail = email ?? 'phongdz@fpt.edu.vn';
    print('ID: $id | Tên: $name | Email: $displayEmail');
  }
}

void main() {
  Map<String, dynamic> rawData1 = {
    "id": 1,
    "name": "Nam",
    "email": "nam@fpt.edu.vn"
  };

  Map<String, dynamic> rawData2 = {
    "id": 2,
    "name": null,
    "email": null
  };

  User user1 = User.fromJson(rawData1);
  User user2 = User.fromJson(rawData2);

  print("THÔNG TIN USER 1");
  user1.showProfile();

  print("\nTHÔNG TIN USER 2 (DỮ LIỆU BỊ NULL)");
  user2.showProfile();
}