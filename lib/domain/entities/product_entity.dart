/// Entidad de dominio para Producto
/// No tiene dependencias externas, solo lógica de negocio
class ProductEntity {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final RatingEntity rating;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductEntity &&
        other.id == id &&
        other.title == title &&
        other.price == price &&
        other.description == description &&
        other.category == category &&
        other.image == image &&
        other.rating == rating;
  }

  @override
  int get hashCode {
    return Object.hash(id, title, price, description, category, image, rating);
  }
}

/// Entidad de dominio para Rating
class RatingEntity {
  final double rate;
  final int count;

  const RatingEntity({required this.rate, required this.count});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RatingEntity && other.rate == rate && other.count == count;
  }

  @override
  int get hashCode => Object.hash(rate, count);
}
