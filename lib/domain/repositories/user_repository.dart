import 'package:dartz/dartz.dart';
import '../../core/errors/errors.dart';
import '../entities/entities.dart';

/// Interfaz del repositorio de usuarios
abstract class UserRepository {
  Future<Either<Failure, List<UserEntity>>> getUsers();
}
