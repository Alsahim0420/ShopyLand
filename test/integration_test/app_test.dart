import 'dart:nativewrappers/_internal/vm/bin/vmservice_io.dart' as app;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Flujos de integración de la aplicación', () {
    testWidgets('debe cargar la aplicación y mostrar la pantalla de login', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('ShopyLand'), findsWidgets);
      expect(find.text('Iniciar sesión'), findsOneWidget);
      expect(find.text('Crear cuenta'), findsOneWidget);
    });

    testWidgets('debe navegar a registro al pulsar Crear cuenta', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.text('Crear cuenta'));
      await tester.pumpAndSettle();

      expect(find.byType(Form), findsWidgets);
    });

    testWidgets('debe hacer login con credenciales válidas y navegar a home', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.enterText(find.byType(TextField).first, 'test@test.com');
      await tester.enterText(find.byType(TextField).last, '123456');
      await tester.tap(find.text('Iniciar sesión'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('ShopyLand'), findsWidgets);
      expect(find.text('Inicio'), findsOneWidget);
    });
  });
}
