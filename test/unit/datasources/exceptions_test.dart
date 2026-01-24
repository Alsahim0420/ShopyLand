import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/data/datasources/remote_data_source.dart';

void main() {
  group('Exceptions', () {
    test('ServerException debe crear correctamente', () {
      final exception = ServerException('Error del servidor', 500);

      expect(exception.message, 'Error del servidor');
      expect(exception.statusCode, 500);
    });

    test('ServerException debe crear sin statusCode', () {
      final exception = ServerException('Error del servidor');

      expect(exception.message, 'Error del servidor');
      expect(exception.statusCode, isNull);
    });

    test('ConnectionException debe crear correctamente', () {
      final exception = ConnectionException('Error de conexión');

      expect(exception.message, 'Error de conexión');
    });

    test('ParsingException debe crear correctamente', () {
      final exception = ParsingException('Error al parsear');

      expect(exception.message, 'Error al parsear');
    });
  });
}
