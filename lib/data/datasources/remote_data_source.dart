import 'dart:convert';
import 'package:http/http.dart' as http;
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
  final http.Client client;

  RemoteDataSourceImpl({http.Client? client})
    : client = client ?? http.Client();

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final uri = Uri.parse('$baseUrl/products');
      final response = await client.get(uri);

      if (response.statusCode == 200) {
        try {
          final List<dynamic> jsonList = json.decode(response.body);
          return jsonList
              .map(
                (json) => ProductModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        } catch (e) {
          throw ParsingException('Error al parsear productos: $e');
        }
      } else {
        throw ServerException(
          'Error al obtener productos',
          response.statusCode,
        );
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
      final uri = Uri.parse('$baseUrl/products/categories');
      final response = await client.get(uri);

      if (response.statusCode == 200) {
        try {
          final List<dynamic> jsonList = json.decode(response.body);
          return jsonList.map((json) => CategoryModel.fromJson(json)).toList();
        } catch (e) {
          throw ParsingException('Error al parsear categorías: $e');
        }
      } else {
        throw ServerException(
          'Error al obtener categorías',
          response.statusCode,
        );
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
      final uri = Uri.parse('$baseUrl/users');
      final response = await client.get(uri);

      if (response.statusCode == 200) {
        try {
          final List<dynamic> jsonList = json.decode(response.body);
          return jsonList
              .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
              .toList();
        } catch (e) {
          throw ParsingException('Error al parsear usuarios: $e');
        }
      } else {
        throw ServerException('Error al obtener usuarios', response.statusCode);
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
