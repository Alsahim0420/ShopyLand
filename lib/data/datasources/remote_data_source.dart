import 'package:conectify/conectify.dart';
import '../models/models.dart';

/// Excepciones personalizadas para la capa de datos
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException(this.message, [this.statusCode]);
}

class ConnectionException implements Exception {
  final String message;

  ConnectionException(this.message);
}

class ParsingException implements Exception {
  final String message;

  ParsingException(this.message);
}

/// Fuente de datos remota para la API Fake Store
abstract class RemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<List<CategoryModel>> getCategories();
  Future<List<UserModel>> getUsers();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  static const String baseUrl = 'https://fakestoreapi.com';
  final ConectifyClient client;

  RemoteDataSourceImpl({ConectifyClient? client})
      : client = client ??
            ConectifyClient(
              baseUrl: baseUrl,
            );

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final List<dynamic> jsonList = await client.getList('/products');
      try {
        return jsonList
            .map(
              (json) => ProductModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } catch (e) {
        throw ParsingException('Error al parsear productos: $e');
      }
    } on ServerException {
      rethrow;
    } on ParsingException {
      rethrow;
    } catch (e) {
      throw ConnectionException('Error de conexión: $e');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final List<dynamic> jsonList =
          await client.getList('/products/categories');
      try {
        return jsonList.map((json) => CategoryModel.fromJson(json)).toList();
      } catch (e) {
        throw ParsingException('Error al parsear categorías: $e');
      }
    } on ServerException {
      rethrow;
    } on ParsingException {
      rethrow;
    } catch (e) {
      throw ConnectionException('Error de conexión: $e');
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final List<dynamic> jsonList = await client.getList('/users');
      try {
        return jsonList
            .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (e) {
        throw ParsingException('Error al parsear usuarios: $e');
      }
    } on ServerException {
      rethrow;
    } on ParsingException {
      rethrow;
    } catch (e) {
      throw ConnectionException('Error de conexión: $e');
    }
  }
}
