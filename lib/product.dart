class Product {
  final String name;
  final String image;

  Product(this.name, this.image);
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      json['name'],
      json['image'],
    );
  }
}
