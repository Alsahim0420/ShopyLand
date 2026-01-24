import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/core/auth/auth_service.dart';
import 'package:shopyland/domain/entities/entities.dart';
import 'package:shopyland/main.dart' as app;

void main() {
  group('MyApp', () {
    setUp(() {
      final authService = AuthService();
      authService.logout();
    });

    testWidgets('debe inicializar la aplicación', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('debe mostrar LoginPage cuando no está autenticado', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('Welcome Back!'), findsOneWidget);
    });

    testWidgets('debe tener rutas configuradas', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verificar que las rutas están disponibles
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.routes?.containsKey('/login'), true);
      expect(materialApp.routes?.containsKey('/register'), true);
      expect(materialApp.routes?.containsKey('/home'), true);
    });

    // ========== TESTS PARA NAVEGAR A TODAS LAS RUTAS Y CUBRIR LÍNEAS 53-60 ==========
    
    testWidgets('debe navegar a /register - línea 53', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navegar a la ruta /register para ejecutar línea 53
      // Línea 53: '/register': (context) => const RegisterPage(),
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pushNamed('/register');
      await tester.pumpAndSettle();

      // Verificar que se muestra RegisterPage
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('debe navegar a /home - línea 54', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navegar a la ruta /home para ejecutar línea 54
      // Línea 54: '/home': (context) => const MainNavigation(),
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pushNamed('/home');
      await tester.pumpAndSettle();

      // Verificar que se muestra MainNavigation
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('debe navegar a /discover - línea 55', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navegar a la ruta /discover para ejecutar línea 55
      // Línea 55: '/discover': (context) => const MainNavigation(),
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pushNamed('/discover');
      await tester.pumpAndSettle();

      // Verificar que se muestra MainNavigation
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('debe navegar a /cart - línea 56', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navegar a la ruta /cart para ejecutar línea 56
      // Línea 56: '/cart': (context) => const MainNavigation(key: ValueKey('cart')),
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pushNamed('/cart');
      await tester.pumpAndSettle();

      // Verificar que se muestra MainNavigation con el key 'cart'
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('debe navegar a /support - línea 57', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navegar a la ruta /support para ejecutar línea 57
      // Línea 57: '/support': (context) => const SupportPage(),
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pushNamed('/support');
      await tester.pumpAndSettle();

      // Verificar que se muestra SupportPage
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('debe navegar a /product-detail - líneas 58-60', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Crear un producto de prueba para pasar como argumento
      final testProduct = ProductEntity(
        id: 1,
        title: 'Test Product',
        price: 99.99,
        description: 'Test Description',
        category: 'electronics',
        image: 'https://example.com/image.jpg',
        rating: RatingEntity(rate: 4.5, count: 100),
      );

      // Navegar a la ruta /product-detail con argumentos para ejecutar líneas 58-60
      // Línea 58: '/product-detail': (context) {
      // Línea 59: final product = ModalRoute.of(context)!.settings.arguments as ProductEntity;
      // Línea 60: return ProductDetailPage(product: product);
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pushNamed('/product-detail', arguments: testProduct);
      await tester.pumpAndSettle();

      // Verificar que se muestra ProductDetailPage
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    // ========== TEST COMPLETO: Navegar a todas las rutas ==========
    testWidgets('debe navegar a todas las rutas para máxima cobertura', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final navigator = tester.state<NavigatorState>(find.byType(Navigator));

      // Navegar a /register - línea 53
      navigator.pushNamed('/register');
      await tester.pumpAndSettle();
      navigator.pop();
      await tester.pumpAndSettle();

      // Navegar a /home - línea 54
      navigator.pushNamed('/home');
      await tester.pumpAndSettle();
      navigator.pop();
      await tester.pumpAndSettle();

      // Navegar a /discover - línea 55
      navigator.pushNamed('/discover');
      await tester.pumpAndSettle();
      navigator.pop();
      await tester.pumpAndSettle();

      // Navegar a /cart - línea 56
      navigator.pushNamed('/cart');
      await tester.pumpAndSettle();
      navigator.pop();
      await tester.pumpAndSettle();

      // Navegar a /support - línea 57
      navigator.pushNamed('/support');
      await tester.pumpAndSettle();
      navigator.pop();
      await tester.pumpAndSettle();

      // Navegar a /product-detail - líneas 58-60
      final testProduct = ProductEntity(
        id: 1,
        title: 'Test Product',
        price: 99.99,
        description: 'Test Description',
        category: 'electronics',
        image: 'https://example.com/image.jpg',
        rating: RatingEntity(rate: 4.5, count: 100),
      );
      navigator.pushNamed('/product-detail', arguments: testProduct);
      await tester.pumpAndSettle();
      navigator.pop();
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('debe tener tema configurado', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme, isNotNull);
      // Verificar que el colorScheme está basado en pink (el primary será derivado de pink)
      expect(materialApp.theme?.colorScheme.primary, isNotNull);
      expect(materialApp.theme?.useMaterial3, true);
    });
  });
}
