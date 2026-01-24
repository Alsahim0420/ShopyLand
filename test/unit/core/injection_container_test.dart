import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/core/di/injection_container.dart';
import 'package:shopyland/domain/usecases/usecases.dart';

void main() {
  group('InjectionContainer', () {
    test('debe inicializar correctamente', () {
      final container = InjectionContainer();

      expect(container.getProducts, isA<GetProducts>());
      expect(container.getCategories, isA<GetCategories>());
      expect(container.getUsers, isA<GetUsers>());
    });

    test('debe crear instancias de use cases', () {
      final container = InjectionContainer();

      expect(container.getProducts, isNotNull);
      expect(container.getCategories, isNotNull);
      expect(container.getUsers, isNotNull);
    });
  });
}
