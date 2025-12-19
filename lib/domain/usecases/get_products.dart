import 'package:dartz/dartz.dart';
import '../../core/errors/errors.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Caso de uso para obtener productos
/// Encapsula la lógica de negocio
class GetProducts {
  final ProductRepository repository;

  const GetProducts(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call() {
    return repository.getProducts();
  }
}
