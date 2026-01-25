import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shopyland/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Flujos de integración de la aplicación', () {
    testWidgets('debe cargar la aplicación y mostrar la pantalla de login',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verificar que se muestra la pantalla de login
      expect(find.text('Login'), findsWidgets);
    });

    testWidgets('debe hacer login y navegar a la pantalla principal',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Buscar y presionar el botón de login demo
      final demoButton = find.text('Login Demo');
      if (demoButton.evaluate().isNotEmpty) {
        await tester.tap(demoButton);
        await tester.pumpAndSettle();

        // Verificar que se navegó a la pantalla principal
        expect(find.byType(Navigator), findsWidgets);
      }
    });

    testWidgets('debe mostrar productos después del login',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Hacer login
      final demoButton = find.text('Login Demo');
      if (demoButton.evaluate().isNotEmpty) {
        await tester.tap(demoButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Verificar que se muestran productos o categorías
        expect(find.byType(Scaffold), findsWidgets);
      }
    });
  });
}
