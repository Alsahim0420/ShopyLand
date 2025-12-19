import 'package:dartz/dartz.dart';
import '../../core/errors/errors.dart';
import '../entities/entities.dart';

/// Interfaz del repositorio de categorías
abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
}
