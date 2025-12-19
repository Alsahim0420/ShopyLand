import '../../domain/entities/entities.dart';

/// Modelo de datos (DTO) para Category
class CategoryModel extends CategoryEntity {
  const CategoryModel({required super.name});

  /// Constructor desde JSON
  /// La API Fake Store devuelve las categorías como una lista de strings
  factory CategoryModel.fromJson(dynamic json) {
    if (json is String) {
      return CategoryModel(name: json);
    }
    if (json is Map<String, dynamic> && json.containsKey('name')) {
      return CategoryModel(name: json['name'] as String);
    }
    throw FormatException('Invalid category format: $json');
  }

  /// Conversión a entidad de dominio
  CategoryEntity toEntity() {
    return CategoryEntity(name: name);
  }

  /// Conversión a JSON
  dynamic toJson() {
    return name;
  }
}
