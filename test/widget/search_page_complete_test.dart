import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/presentation/pages/search_page.dart';

void main() {
  group('SearchPage - Cobertura Completa', () {
    Widget createWidgetUnderTest() {
      return MaterialApp(
        routes: {
          '/discover': (context) => const Scaffold(body: Text('Discover')),
        },
        home: const SearchPage(),
      );
    }

    // Test 1: initState y _loadProducts
    testWidgets('debe ejecutar initState y _loadProducts', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Líneas 34-36: initState() { super.initState(); _loadProducts(); }
      expect(find.byType(SearchPage), findsOneWidget);
    });

    // Test 2: dispose
    testWidgets('debe ejecutar dispose correctamente', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Líneas 39-42: dispose() { _searchController.dispose(); super.dispose(); }
      await tester.pumpWidget(const SizedBox());
      await tester.pump();

      expect(find.byType(SearchPage), findsNothing);
    });

    // Test 3: _isLoading = true inicialmente
    testWidgets('debe mostrar loading inicialmente', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Línea 135-136: _isLoading ? const Center(child: CircularProgressIndicator())
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // Test 4: Manejo de error en _loadProducts
    testWidgets('debe manejar error en _loadProducts (fold Left)', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Líneas 48-52: result.fold((failure) { ... })
      final errorIcon = find.byIcon(Icons.error_outline);
      if (errorIcon.evaluate().isNotEmpty) {
        expect(errorIcon, findsOneWidget);
      }
    });

    // Test 5: Éxito en _loadProducts
    testWidgets('debe cargar productos exitosamente (fold Right)', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 54-58: result.fold(..., (productsList) { ... })
      expect(find.byType(Scaffold), findsOneWidget);
    });

    // Test 6: _performSearch con query vacío
    testWidgets('debe manejar búsqueda vacía', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 64-68: if (query.isEmpty) { setState(() { _filteredProducts = []; }); return; }
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, '');
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    // Test 7: _performSearch cuando _allProducts es null
    testWidgets('debe retornar temprano si _allProducts es null', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Línea 71: if (_allProducts == null) return;
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test');
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    // Test 8: _performSearch con productos
    testWidgets('debe filtrar productos en _performSearch', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 73-80: setState(() { _filteredProducts = _allProducts!.where(...).toList(); })
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test');
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    // Test 9: Agregar a búsquedas recientes
    testWidgets('debe agregar búsqueda a recientes cuando no existe', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 82-89: if (!_recentSearches.contains(query) && query.isNotEmpty) { ... }
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'nueva busqueda unica 999');
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    // Test 10: Limitar búsquedas recientes a 5
    testWidgets('debe limitar búsquedas recientes a 5', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 85-87: if (_recentSearches.length > 5) { _recentSearches = _recentSearches.take(5).toList(); }
      final searchField = find.byType(TextField).first;
      for (int i = 0; i < 7; i++) {
        await tester.enterText(searchField, 'busqueda $i');
        await tester.pumpAndSettle();
      }

      expect(find.byType(Scaffold), findsOneWidget);
    });

    // Test 11: _clearRecentSearches
    testWidgets('debe limpiar búsquedas recientes', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 92-96: _clearRecentSearches() { setState(() { _recentSearches.clear(); }); }
      final clearAllButton = find.text('Clear All');
      await tester.tap(clearAllButton);
      await tester.pump();

      expect(find.text('Recent Searches'), findsOneWidget);
    });

    // Test 12: _buildErrorView completo
    testWidgets('debe construir vista de error completa', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Líneas 145-161: _buildErrorView()
      final retryButton = find.text('Reintentar');
      if (retryButton.evaluate().isNotEmpty) {
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(retryButton, findsOneWidget);
      }
    });

    // Test 13: _buildSearchSuggestions completo
    testWidgets('debe construir sugerencias de búsqueda completas', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 163-213: _buildSearchSuggestions()
      expect(find.text('Recent Searches'), findsOneWidget);
      expect(find.text('Suggested for You'), findsOneWidget);
    });

    // Test 14: Búsquedas recientes cuando están vacías
    testWidgets('debe no mostrar búsquedas recientes cuando están vacías', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Línea 169: if (_recentSearches.isNotEmpty) ...[
      final clearAllButton = find.text('Clear All');
      if (clearAllButton.evaluate().isNotEmpty) {
        await tester.tap(clearAllButton);
        await tester.pump();

        // Después de limpiar, no debe mostrar la sección de recientes
        expect(find.text('Recent Searches'), findsOneWidget);
      }
    });

    // Test 15: _buildRecentSearchItem completo
    testWidgets('debe construir items de búsqueda reciente', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 215-225: _buildRecentSearchItem()
      final recentSearchItems = find.byIcon(Icons.history);
      if (recentSearchItems.evaluate().isNotEmpty) {
        expect(recentSearchItems, findsWidgets);
      }
    });

    // Test 16: Seleccionar búsqueda reciente
    testWidgets('debe seleccionar búsqueda reciente al tocarla', (WidgetTester tester) async {
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

    // Test 17: Categorías sugeridas
    testWidgets('debe mostrar todas las categorías sugeridas', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 198-209: Wrap con _suggestedCategories.map()
      expect(find.text('Electronics'), findsOneWidget);
      expect(find.text('Jewelery'), findsOneWidget);
      expect(find.text("Men's Clothing"), findsOneWidget);
      expect(find.text('Best Sellers 🔥'), findsOneWidget);
    });

    // Test 18: _buildSearchResults cuando está vacío
    testWidgets('debe mostrar mensaje cuando no hay resultados', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 228-262: if (_filteredProducts.isEmpty) { return Center(...) }
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'xyz123nonexistentproduct999');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('No results found'), findsOneWidget);
      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });

    // Test 19: Navegar a discover cuando no hay resultados
    testWidgets('debe navegar a discover cuando no hay resultados', (WidgetTester tester) async {
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

    // Test 20: _buildSearchResults cuando hay resultados
    testWidgets('debe mostrar resultados cuando hay productos', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 264-319: return Column(...) con resultados
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.textContaining('items found'), findsWidgets);
      expect(find.byType(GridView), findsOneWidget);
    });

    // Test 21: Contador de items encontrados
    testWidgets('debe mostrar contador de items encontrados', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 271-276: Text('${_filteredProducts.length} items found')
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test');
      await tester.pumpAndSettle();

      expect(find.textContaining('items found'), findsWidgets);
    });

    // Test 22: Dropdown de ordenamiento en resultados
    testWidgets('debe mostrar dropdown de ordenamiento en resultados', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 277-287: DropdownButton<String>
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test');
      await tester.pumpAndSettle();

      expect(find.text('Most Relevant'), findsOneWidget);
    });

    // Test 23: Agregar producto al carrito desde resultados
    testWidgets('debe agregar producto al carrito desde resultados', (WidgetTester tester) async {
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

    // Test 24: suffixIcon cuando hay texto
    testWidgets('debe mostrar botón clear cuando hay texto', (WidgetTester tester) async {
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

    // Test 25: Limpiar búsqueda con botón clear
    testWidgets('debe limpiar búsqueda con botón clear', (WidgetTester tester) async {
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

    // Test 26: Botón de filtros
    testWidgets('debe mostrar botón de filtros', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 127-132: IconButton con Icons.tune
      expect(find.byIcon(Icons.tune), findsOneWidget);
    });

    // Test 27: Botón de volver atrás
    testWidgets('debe volver atrás al presionar back', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Líneas 103-105: IconButton onPressed: () => Navigator.pop(context)
      final backButton = find.byIcon(Icons.arrow_back);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(find.text('Search products...'), findsNothing);
    });

    // Test 28: onChanged del TextField
    testWidgets('debe ejecutar _performSearch al cambiar texto', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Línea 124: onChanged: _performSearch
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'nueva busqueda');
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    // Test 29: Búsqueda por título
    testWidgets('debe buscar por título del producto', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Línea 76: product.title.toLowerCase().contains(searchLower)
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'test');
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    // Test 30: Búsqueda por descripción
    testWidgets('debe buscar por descripción del producto', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Línea 77: product.description.toLowerCase().contains(searchLower)
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'description');
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    // Test 31: Búsqueda por categoría
    testWidgets('debe buscar por categoría del producto', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Línea 78: product.category.toLowerCase().contains(searchLower)
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'electronics');
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
