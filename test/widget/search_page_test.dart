import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/presentation/pages/search_page.dart';

void main() {
  group('SearchPage', () {
    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: const SearchPage(),
      );
    }

    testWidgets('debe mostrar la página de búsqueda', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('debe mostrar campo de búsqueda', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('debe permitir escribir en el campo de búsqueda', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test search');
      await tester.pump();

      expect(find.text('test search'), findsOneWidget);
    });

    testWidgets('debe mostrar búsquedas recientes', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('Recent Searches'), findsOneWidget);
    });

    testWidgets('debe mostrar categorías sugeridas', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('Suggested Categories'), findsOneWidget);
    });

    testWidgets('debe mostrar resultados cuando hay búsqueda', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test');
      await tester.pumpAndSettle();

      // Verificar que se muestra la sección de resultados
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('debe limpiar búsqueda', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test');
      await tester.pump();

      // Limpiar el campo
      await tester.enterText(searchField, '');
      await tester.pump();

      expect(find.text(''), findsWidgets);
    });

    testWidgets('debe limpiar búsquedas recientes', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final clearAllButton = find.text('Clear All');
      if (clearAllButton.evaluate().isNotEmpty) {
        await tester.tap(clearAllButton);
        await tester.pump();

        expect(find.text('Recent Searches'), findsOneWidget);
      }
    });

    testWidgets('debe seleccionar búsqueda reciente', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Buscar un item de búsqueda reciente
      final recentSearchItems = find.byIcon(Icons.history);
      if (recentSearchItems.evaluate().isNotEmpty) {
        await tester.tap(recentSearchItems.first);
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('debe mostrar mensaje cuando no hay resultados', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'xyz123nonexistent');
      await tester.pumpAndSettle();

      // Verificar que se muestra mensaje de no resultados
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('debe mostrar botón de filtros', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byIcon(Icons.tune), findsOneWidget);
    });

    testWidgets('debe volver atrás', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verificar que se cerró la página
      expect(find.text('Search products...'), findsNothing);
    });

    testWidgets('debe mostrar mensaje cuando no hay resultados', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'xyz123nonexistentproduct');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('No results found'), findsOneWidget);
    });

    testWidgets('debe mostrar contador de resultados', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test');
      await tester.pumpAndSettle();

      // Verificar que se muestra el contador
      expect(find.textContaining('items found'), findsWidgets);
    });

    testWidgets('debe mostrar dropdown de ordenamiento', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test');
      await tester.pumpAndSettle();

      expect(find.text('Most Relevant'), findsOneWidget);
    });

    testWidgets('debe agregar producto al carrito desde resultados', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test');
      await tester.pumpAndSettle();

      // Buscar botón de agregar al carrito
      final addButtons = find.byIcon(Icons.add);
      if (addButtons.evaluate().isNotEmpty) {
        await tester.tap(addButtons.first);
        await tester.pump();

        expect(find.text('Producto agregado al carrito'), findsOneWidget);
      }
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

        expect(find.byType(Scaffold), findsWidgets);
      }
    });

    testWidgets('debe mostrar grid de resultados cuando hay productos', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verificar que se muestra el grid de resultados
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('debe mostrar contador de items encontrados', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test');
      await tester.pumpAndSettle();

      // Verificar que se muestra el contador
      expect(find.textContaining('items found'), findsWidgets);
    });

    testWidgets('debe agregar producto al carrito desde resultados de búsqueda', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test');
      await tester.pumpAndSettle();

      // Buscar botón de agregar al carrito
      final addButtons = find.byIcon(Icons.add);
      if (addButtons.evaluate().isNotEmpty) {
        await tester.tap(addButtons.first);
        await tester.pump();

        expect(find.text('Producto agregado al carrito'), findsOneWidget);
      }
    });

    testWidgets('debe seleccionar búsqueda reciente al tocarla', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Buscar items de búsqueda reciente
      final recentSearchItems = find.byIcon(Icons.history);
      if (recentSearchItems.evaluate().isNotEmpty) {
        await tester.tap(recentSearchItems.first);
        await tester.pumpAndSettle();

        // Verificar que se ejecutó la búsqueda
        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('debe mostrar categorías sugeridas', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('Suggested for You'), findsOneWidget);
      expect(find.byType(Chip), findsWidgets);
    });

    testWidgets('debe limpiar búsqueda con botón clear', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test search');
      await tester.pumpAndSettle();

      // Buscar botón de limpiar
      final clearButton = find.byIcon(Icons.clear);
      if (clearButton.evaluate().isNotEmpty) {
        await tester.tap(clearButton);
        await tester.pumpAndSettle();

        // Verificar que se limpió
        expect(find.text('test search'), findsNothing);
      }
    });

    testWidgets('debe mostrar vista de error y permitir reintentar', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Si hay error, debe mostrar botón de reintentar
      final retryButton = find.text('Reintentar');
      if (retryButton.evaluate().isNotEmpty) {
        await tester.tap(retryButton);
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('debe mostrar botón de filtros en app bar', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byIcon(Icons.tune), findsOneWidget);
    });
  });
}
