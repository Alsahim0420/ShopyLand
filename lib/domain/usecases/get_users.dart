import 'package:dartz/dartz.dart';
import '../../core/errors/errors.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Caso de uso para obtener usuarios
class GetUsers {
  final UserRepository repository;

  const GetUsers(this.repository);

  Future<Either<Failure, List<UserEntity>>> call() {
    return repository.getUsers();
  }
}
