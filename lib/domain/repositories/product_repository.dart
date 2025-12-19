import 'package:dartz/dartz.dart';
import '../../core/errors/errors.dart';
import '../entities/entities.dart';

/// Interfaz del repositorio de productos
/// Define el contrato sin implementación concreta
abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts();
}
