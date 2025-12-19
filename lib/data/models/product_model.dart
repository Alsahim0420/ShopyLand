import '../../domain/entities/entities.dart';

/// Modelo de datos (DTO) para Product
/// Extiende la entidad de dominio y agrega serialización
class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.category,
    required super.image,
    required super.rating,
  });

  /// Constructor desde JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      rating: RatingModel.fromJson(json['rating'] as Map<String, dynamic>),
    );
  }

  /// Conversión a entidad de dominio
  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
      rating: (rating as RatingModel).toEntity(),
    );
  }

  /// Conversión a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': (rating as RatingModel).toJson(),
    };
  }
}

/// Modelo de datos para Rating
class RatingModel extends RatingEntity {
  const RatingModel({required super.rate, required super.count});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      rate: (json['rate'] as num).toDouble(),
      count: json['count'] as int,
    );
  }

  RatingEntity toEntity() {
    return RatingEntity(rate: rate, count: count);
  }

  Map<String, dynamic> toJson() {
    return {'rate': rate, 'count': count};
  }
}
