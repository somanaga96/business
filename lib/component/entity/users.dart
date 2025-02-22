class Users {
  String id;
  String name;

  Users({required this.id, required this.name});

  factory Users.fromMap(String id, Map<String, dynamic> map) {
    // Updated factory constructor
    return Users(
        // Assigning Firebase document ID
        name: map['name'],
        id: id);
  }
}
