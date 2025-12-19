/// Entidad de dominio para Categoría
class CategoryEntity {
  final String name;

  const CategoryEntity({required this.name});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryEntity && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
