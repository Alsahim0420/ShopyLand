import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/core/errors/failures.dart';

void main() {
  group('Failures', () {
    test('ServerFailure debe crear correctamente', () {
      const failure = ServerFailure('Error del servidor', 500);

      expect(failure.message, 'Error del servidor');
      expect(failure.statusCode, 500);
    });

    test('ServerFailure debe crear sin statusCode', () {
      const failure = ServerFailure('Error del servidor');

      expect(failure.message, 'Error del servidor');
      expect(failure.statusCode, isNull);
    });

    test('ConnectionFailure debe crear correctamente', () {
      const failure = ConnectionFailure('Error de conexión');

      expect(failure.message, 'Error de conexión');
    });

    test('ParsingFailure debe crear correctamente', () {
      const failure = ParsingFailure('Error al parsear');

      expect(failure.message, 'Error al parsear');
    });

    test('Failure debe tener toString correcto', () {
      const failure = ConnectionFailure('Error de conexión');

      expect(failure.toString(), 'Error de conexión');
    });
  });
}
