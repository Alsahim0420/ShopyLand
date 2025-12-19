import 'package:dartz/dartz.dart';
import '../../core/errors/errors.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Caso de uso para obtener categorías
class GetCategories {
  final CategoryRepository repository;

  const GetCategories(this.repository);

  Future<Either<Failure, List<CategoryEntity>>> call() {
    return repository.getCategories();
  }
}
