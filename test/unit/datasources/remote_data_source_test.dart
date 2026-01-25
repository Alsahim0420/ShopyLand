import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/data/datasources/remote_data_source.dart';
import 'package:shopyland/data/models/models.dart';

void main() {
  group('RemoteDataSourceImpl', () {
    late RemoteDataSourceImpl dataSource;

    setUp(() {
      dataSource = RemoteDataSourceImpl();
    });

    test('debe tener la URL base correcta', () {
      expect(RemoteDataSourceImpl.baseUrl, 'https://fakestoreapi.com');
    });

    test('debe crear instancia con cliente por defecto', () {
      final instance = RemoteDataSourceImpl();
      expect(instance, isNotNull);
    });

    test('debe crear instancia con cliente personalizado', () {
      // Este test verifica que se puede pasar un cliente personalizado
      // aunque no lo usemos directamente, verifica que el constructor funciona
      final instance = RemoteDataSourceImpl(client: null);
      expect(instance, isNotNull);
    });

    // Nota: Los tests de getProducts, getCategories, getUsers requieren
    // conexión a internet y se prueban en los tests de integración
  });
}
