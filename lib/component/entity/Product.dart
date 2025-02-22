class Product {
  String id;
  String name;

  Product({required this.id, required this.name});

  factory Product.fromMap(String id, Map<String, dynamic> map) {
    // Updated factory constructor
    return Product(
      // Assigning Firebase document ID
        name: map['name'],
        id: id);
  }
}
