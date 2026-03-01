import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required int id,
    required String title,
    required double price,
    required String description,
    required String category,
    required String image,
    required double rating,
    required int ratingCount,
  }) : super(
          id: id,
          title: title,
          price: price,
          description: description,
          category: category,
          image: image,
          rating: rating,
          ratingCount: ratingCount,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rating = json['rating'] ?? {};
    return ProductModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] ?? '',
      price: (json['price'] as num).toDouble(),
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      image: json['image'] ?? '',
      rating: (rating['rate'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (rating['count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'description': description,
        'category': category,
        'image': image,
        'rating': {'rate': rating, 'count': ratingCount},
      };
}
