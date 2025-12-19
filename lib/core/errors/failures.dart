/// Clase base para representar fallos en la aplicación
abstract class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;
}

/// Fallo relacionado con errores de servidor
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(super.message, [this.statusCode]);
}

/// Fallo relacionado con errores de conexión
class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message);
}

/// Fallo relacionado con errores de parsing
class ParsingFailure extends Failure {
  const ParsingFailure(super.message);
}
