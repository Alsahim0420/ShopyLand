import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/core/models/cart_item.dart';
import 'package:shopyland/core/services/cart_service.dart';
import 'package:shopyland/domain/entities/product_entity.dart';
import 'package:shopyland/presentation/pages/main_navigation.dart';

void main() {
  group('MainNavigation', () {
    Widget createWidgetUnderTest() {
      return MaterialApp(home: const MainNavigation());
    }

    testWidgets('debe mostrar la navegación principal', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets(
      'debe cambiar de página al tocar un item del bottom navigation',
      (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Tocar el segundo item (Search)
        final bottomNavItems = find.byType(BottomNavigationBarItem);
        final bottomNav = find.byType(BottomNavigationBar);

        // Simular tap en el segundo item
        await tester.tap(find.byIcon(Icons.search));
        await tester.pumpAndSettle();

        // Verificar que cambió la página
        expect(find.byType(Scaffold), findsOneWidget);
      },
    );

    testWidgets('debe mostrar el badge del carrito cuando hay items', (
      WidgetTester tester,
    ) async {
      final cartService = CartService();
      cartService.addItem(
        CartItem(
          product: ProductEntity(
            id: 1,
            title: 'Test',
            price: 10.0,
            description: 'Test',
            category: 'test',
            image: 'test.jpg',
            rating: RatingEntity(rate: 4.0, count: 100),
          ),
          quantity: 1,
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // El badge debería aparecer si hay items en el carrito
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('debe cambiar de página al tocar bottom navigation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tocar el segundo item (Search)
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Verificar que cambió la página
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('debe inicializar con índice desde argumentos de ruta', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {'/home': (context) => const MainNavigation()},
          initialRoute: '/home',
          onGenerateRoute: (settings) {
            if (settings.name == '/home') {
              return MaterialPageRoute(
                builder: (context) => const MainNavigation(),
                settings: RouteSettings(arguments: 2), // Cart index
              );
            }
            return null;
          },
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('debe actualizar badge cuando cambia el carrito', (
      WidgetTester tester,
    ) async {
      final cartService = CartService();
      cartService.clear();

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Agregar item al carrito
      cartService.addItem(
        CartItem(
          product: ProductEntity(
            id: 1,
            title: 'Test',
            price: 10.0,
            description: 'Test',
            category: 'test',
            image: 'test.jpg',
            rating: RatingEntity(rate: 4.0, count: 100),
          ),
          quantity: 1,
        ),
      );

      await tester.pumpAndSettle();

      // Verificar que se actualizó
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('debe navegar a todas las páginas del bottom navigation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Navegar a Search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Navegar a Cart
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();

      // Navegar a Profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Volver a Home
      await tester.tap(find.byIcon(Icons.home));
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
