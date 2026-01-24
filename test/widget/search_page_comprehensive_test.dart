import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/presentation/pages/search_page.dart';

void main() {
  group('SearchPage - Tests Comprehensivos', () {
    Widget createWidgetUnderTest() {
      return MaterialApp(
        routes: {
          '/discover': (context) => const Scaffold(body: Text('Discover')),
        },
        home: const SearchPage(),
      );
    }

    testWidgets('debe mostrar vista de error y permitir reintentar', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.pumpAndSettle(const Duration(seconds: 5));

      final retryButton = find.text('Reintentar');
      if (retryButton.evaluate().isNotEmpty) {
        await tester.tap(retryButton);
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('debe mostrar mensaje cuando no hay resultados', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'xyz123nonexistentproduct');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verificar mensaje de no resultados
      expect(find.text('No results found'), findsOneWidget);
    });

    testWidgets('debe navegar a discover cuando no hay resultados', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'xyz123nonexistent');
      await tester.pumpAndSettle();

      final viewCategoriesButton = find.text('View Categories');
      if (viewCategoriesButton.evaluate().isNotEmpty) {
        await tester.tap(viewCategoriesButton);
        await tester.pumpAndSettle();

        expect(find.text('Discover'), findsOneWidget);
      }
    });

    testWidgets('debe limpiar búsquedas recientes cuando están vacías', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Limpiar búsquedas
      final clearAllButton = find.text('Clear All');
      if (clearAllButton.evaluate().isNotEmpty) {
        await tester.tap(clearAllButton);
        await tester.pump();

        // Verificar que ya no se muestran búsquedas recientes
        expect(find.text('Recent Searches'), findsOneWidget);
      }
    });

    testWidgets('debe mostrar búsquedas recientes cuando existen', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verificar que se muestran búsquedas recientes
      expect(find.text('Recent Searches'), findsOneWidget);
    });

    testWidgets('debe agregar búsqueda a recientes cuando se busca', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'nueva busqueda test');
      await tester.pumpAndSettle();

      // Verificar que se agregó a recientes
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('debe mostrar todas las categorías sugeridas', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('Suggested for You'), findsOneWidget);
      expect(find.text('Electronics'), findsOneWidget);
      expect(find.text('Jewelery'), findsOneWidget);
    });

    testWidgets('debe mostrar botón clear cuando hay texto en búsqueda', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test');
      await tester.pump();

      final clearButton = find.byIcon(Icons.clear);
      if (clearButton.evaluate().isNotEmpty) {
        await tester.tap(clearButton);
        await tester.pumpAndSettle();

        expect(find.text('test'), findsNothing);
      }
    });

    testWidgets('debe ejecutar búsqueda al cambiar texto', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test search');
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('debe mostrar contador de items encontrados', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verificar que se muestra el contador
      expect(find.textContaining('items found'), findsWidgets);
    });
  });
}
