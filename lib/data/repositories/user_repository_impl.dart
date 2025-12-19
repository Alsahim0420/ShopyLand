import 'package:dartz/dartz.dart';
import '../../core/errors/errors.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/remote_data_source.dart';

/// Implementación del repositorio de usuarios
class UserRepositoryImpl implements UserRepository {
  final RemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers() async {
    try {
      final models = await remoteDataSource.getUsers();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on ConnectionException catch (e) {
      return Left(ConnectionFailure(e.message));
    } on ParsingException catch (e) {
      return Left(ParsingFailure(e.message));
    } catch (e) {
      return Left(ConnectionFailure('Error inesperado: $e'));
    }
  }
}
