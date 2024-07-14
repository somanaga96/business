class User {
  String userName;
  String password;

  User({required this.userName, required this.password});

  factory User.fromMap(String id, Map<String, dynamic> map) {
    // Updated factory constructor
    return User(
        // Assigning Firebase document ID
        userName: map['userName'],
        password: map['password']);
  }
}
