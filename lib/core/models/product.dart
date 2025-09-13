class Product {
  final int id;
  final String title;
  final double price;
  final String thumbnail;
  final String category;
  final double rating;
  final int stock;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.category,
    required this.rating,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        title: json['title'],
        price: (json['price'] as num).toDouble(),
        thumbnail: json['thumbnail'],
        category: json['category'],
        rating: (json['rating'] as num).toDouble(),
        stock: json['stock'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'thumbnail': thumbnail,
        'category': category,
        'rating': rating,
        'stock': stock,
      };
}