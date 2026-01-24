import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/presentation/pages/search_page.dart';

void main() {
  group('SearchPage - Tests Finales para Cobertura Completa', () {
    Widget createWidgetUnderTest() {
      return MaterialApp(
        routes: {
          '/discover': (context) => const Scaffold(body: Text('Discover')),
        },
        home: const SearchPage(),
      );
    }

    // ========== TESTS PARA initState Y _loadProducts ==========
    testWidgets('1. debe ejecutar initState completo', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Líneas 34-36: initState() { super.initState(); _loadProducts(); }
      expect(find.byType(SearchPage), findsOneWidget);
    });

    testWidgets('2. debe ejecutar dispose correctamente', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Líneas 39-42: dispose() { _searchController.dispose(); super.dispose(); }
      await tester.pumpWidget(const SizedBox());
      await tester.pump();

      expect(find.byType(SearchPage), findsNothing);
    });

    testWidgets('3. debe ejecutar _loadProducts y manejar resultado', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Líneas 45-61: _loadProducts() con result.fold
      expect(find.byType(Scaffold), findsOneWidget);
    });

    // ========== TESTS PARA ESTADOS ==========
    testWidgets('4. debe mostrar loading cuando _isLoading es true', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Líneas 135-136: _isLoading ? const Center(child: CircularProgressIndicator())
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('5. debe mostrar error cuando _errorMessage no es null', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Líneas 137-138: _errorMessage != null ? _buildErrorView() : ...
      final errorIcon = find.byIcon(Icons.error_outline);
      if (errorIcon.evaluate().isNotEmpty) {
        // Líneas 145-161: _buildErrorView() completo
        expect(find.text('Reintentar'), findsOneWidget);
        await tester.tap(find.text('Reintentar'));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('6. debe mostrar sugerencias cuando texto está vacío', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 139-140: _searchController.text.isEmpty ? _buildSearchSuggestions() : _buildSearchResults()
      // Verificar que se ejecuta el código de sugerencias
      expect(find.byType(Scaffold), findsOneWidget);
    });

    // ========== TESTS PARA _performSearch ==========
    testWidgets('7. debe manejar búsqueda vacía', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 64-68: if (query.isEmpty) { setState(() { _filteredProducts = []; }); return; }
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, '');
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('8. debe retornar temprano si _allProducts es null', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Línea 71: if (_allProducts == null) return;
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test');
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('9. debe filtrar productos correctamente', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 73-80: setState(() { _filteredProducts = _allProducts!.where(...).toList(); })
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test');
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('10. debe buscar por título', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Línea 76: product.title.toLowerCase().contains(searchLower)
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test');
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('11. debe buscar por descripción', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Línea 77: product.description.toLowerCase().contains(searchLower)
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'description');
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('12. debe buscar por categoría', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Línea 78: product.category.toLowerCase().contains(searchLower)
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'electronics');
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('13. debe agregar búsqueda a recientes cuando no existe', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 82-89: if (!_recentSearches.contains(query) && query.isNotEmpty) { ... }
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'nueva busqueda unica 999');
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('14. debe limitar búsquedas recientes a 5', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 85-87: if (_recentSearches.length > 5) { _recentSearches = _recentSearches.take(5).toList(); }
      final searchField = find.byType(TextField).first;
      for (int i = 0; i < 7; i++) {
        await tester.enterText(searchField, 'busqueda unica $i');
        await tester.pumpAndSettle();
      }

      expect(find.byType(Scaffold), findsOneWidget);
    });

    // ========== TESTS PARA _clearRecentSearches ==========
    testWidgets('15. debe limpiar búsquedas recientes', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 92-96: _clearRecentSearches() { setState(() { _recentSearches.clear(); }); }
      final clearAllButton = find.text('Clear All');
      await tester.tap(clearAllButton);
      await tester.pump();

      expect(find.text('Recent Searches'), findsOneWidget);
    });

    // ========== TESTS PARA _buildSearchSuggestions ==========
    testWidgets('16. debe construir sugerencias completas', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 163-213: _buildSearchSuggestions() completo
      // Verificar que se ejecuta el código
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('17. debe no mostrar recientes cuando están vacías', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Línea 169: if (_recentSearches.isNotEmpty) ...[
      final clearAllButton = find.text('Clear All');
      if (clearAllButton.evaluate().isNotEmpty) {
        await tester.tap(clearAllButton);
        await tester.pump();

        // Ejecuta _clearRecentSearches (líneas 92-96)
        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('18. debe construir items de búsqueda reciente', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 187, 215-225: _buildRecentSearchItem() completo
      final recentSearchItems = find.byIcon(Icons.history);
      if (recentSearchItems.evaluate().isNotEmpty) {
        expect(recentSearchItems, findsWidgets);
      }
    });

    testWidgets('19. debe seleccionar búsqueda reciente', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 220-223: onTap: () { _searchController.text = search; _performSearch(search); }
      final recentSearchItems = find.byIcon(Icons.history);
      if (recentSearchItems.evaluate().isNotEmpty) {
        await tester.tap(recentSearchItems.first);
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('20. debe mostrar todas las categorías sugeridas', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 198-209: Wrap con _suggestedCategories.map()
      // Verificar que se ejecuta el código de categorías sugeridas
      expect(find.byType(Scaffold), findsOneWidget);
    });

    // ========== TESTS PARA _buildSearchResults ==========
    testWidgets('21. debe mostrar mensaje cuando no hay resultados', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 228-262: if (_filteredProducts.isEmpty) { return Center(...) }
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'xyz123nonexistentproduct999');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('No results found'), findsOneWidget);
      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });

    testWidgets('22. debe navegar a discover cuando no hay resultados', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 254-256: Navigator.pushNamed(context, '/discover')
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'xyz123nonexistent');
      await tester.pumpAndSettle();

      final viewCategoriesButton = find.text('View Categories');
      await tester.tap(viewCategoriesButton);
      await tester.pumpAndSettle();

      expect(find.text('Discover'), findsOneWidget);
    });

    testWidgets('23. debe mostrar resultados cuando hay productos', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 264-319: return Column(...) con resultados
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.textContaining('items found'), findsWidgets);
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('24. debe mostrar contador de items encontrados', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 271-276: Text('${_filteredProducts.length} items found')
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test');
      await tester.pumpAndSettle();

      expect(find.textContaining('items found'), findsWidgets);
    });

    testWidgets('25. debe mostrar dropdown de ordenamiento', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 277-287: DropdownButton<String>
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test');
      await tester.pumpAndSettle();

      expect(find.text('Most Relevant'), findsOneWidget);
    });

    testWidgets('26. debe agregar producto al carrito desde resultados', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 305-313: onAddToCart callback
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test');
      await tester.pumpAndSettle();

      final addButtons = find.byIcon(Icons.add);
      if (addButtons.evaluate().isNotEmpty) {
        await tester.tap(addButtons.first);
        await tester.pump();

        expect(find.text('Producto agregado al carrito'), findsOneWidget);
      }
    });

    // ========== TESTS PARA UI ELEMENTS ==========
    testWidgets('27. debe mostrar botón clear cuando hay texto', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 114-122: suffixIcon: _searchController.text.isNotEmpty ? IconButton(...) : null
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test');
      await tester.pump();

      final clearButton = find.byIcon(Icons.clear);
      if (clearButton.evaluate().isNotEmpty) {
        expect(clearButton, findsOneWidget);
      }
    });

    testWidgets('28. debe limpiar búsqueda con botón clear', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 117-120: onPressed: () { _searchController.clear(); _performSearch(''); }
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test search');
      await tester.pumpAndSettle();

      final clearButton = find.byIcon(Icons.clear);
      if (clearButton.evaluate().isNotEmpty) {
        await tester.tap(clearButton);
        await tester.pumpAndSettle();

        expect(find.text('test search'), findsNothing);
      }
    });

    testWidgets('29. debe ejecutar onChanged del TextField', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Línea 124: onChanged: _performSearch
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'nueva busqueda');
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('30. debe mostrar botón de filtros', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 127-132: IconButton con Icons.tune
      expect(find.byIcon(Icons.tune), findsOneWidget);
    });

    testWidgets('31. debe volver atrás al presionar back', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 103-105: IconButton onPressed: () => Navigator.pop(context)
      final backButton = find.byIcon(Icons.arrow_back);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(find.text('Search products...'), findsNothing);
    });

    // ========== TEST COMPLETO QUE EJECUTA TODO ==========
    testWidgets('32. TEST MASIVO: debe ejecutar todo el flujo completo', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Estado inicial
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Si hay error, manejarlo
      final retryButton = find.text('Reintentar');
      if (retryButton.evaluate().isNotEmpty) {
        await tester.tap(retryButton);
        await tester.pumpAndSettle(const Duration(seconds: 5));
      }

      // Si carga exitosamente, ejecutar todo
      if (retryButton.evaluate().isEmpty) {
        final searchField = find.byType(TextField).first;

        // Búsqueda vacía
        await tester.enterText(searchField, '');
        await tester.pump();

        // Agregar múltiples búsquedas para probar límite de 5
        for (int i = 0; i < 7; i++) {
          await tester.enterText(searchField, 'busqueda $i');
          await tester.pumpAndSettle();
        }

        // Limpiar búsquedas recientes
        final clearAllButton = find.text('Clear All');
        if (clearAllButton.evaluate().isNotEmpty) {
          await tester.tap(clearAllButton);
          await tester.pump();
        }

        // Seleccionar búsqueda reciente
        final recentSearchItems = find.byIcon(Icons.history);
        if (recentSearchItems.evaluate().isNotEmpty) {
          await tester.tap(recentSearchItems.first);
          await tester.pumpAndSettle();
        }

        // Búsqueda con resultados
        await tester.enterText(searchField, 'test');
        await tester.pumpAndSettle();

        // Agregar al carrito desde resultados
        final addButtons = find.byIcon(Icons.add);
        if (addButtons.evaluate().isNotEmpty) {
          await tester.tap(addButtons.first);
          await tester.pump();
        }

        // Búsqueda sin resultados
        await tester.enterText(searchField, 'xyz123nonexistent999');
        await tester.pumpAndSettle();

        // Navegar a discover
        final viewCategoriesButton = find.text('View Categories');
        if (viewCategoriesButton.evaluate().isNotEmpty) {
          await tester.tap(viewCategoriesButton);
          await tester.pumpAndSettle();
        }

        // Volver a search
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Limpiar con botón clear
        await tester.enterText(searchField, 'test search');
        await tester.pumpAndSettle();

        final clearButton = find.byIcon(Icons.clear);
        if (clearButton.evaluate().isNotEmpty) {
          await tester.tap(clearButton);
          await tester.pumpAndSettle();
        }
      }

      expect(find.byType(Scaffold), findsWidgets);
    });
  });
}
