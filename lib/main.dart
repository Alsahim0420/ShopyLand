import 'package:flutter/material.dart';
import 'package:pablito_ds/pablito_ds.dart' show DesignTheme;
import 'core/auth/auth_service.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/register_page.dart';
import 'presentation/pages/main_navigation.dart';
import 'presentation/pages/product_detail_page.dart';
import 'presentation/pages/support_page.dart';
import 'domain/entities/entities.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    
    return MaterialApp(
      title: 'ShopyLand',
      debugShowCheckedModeBanner: false,
      theme: DesignTheme.lightTheme,
      darkTheme: DesignTheme.darkTheme,
      initialRoute: authService.isAuthenticated ? '/home' : '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const MainNavigation(),
        '/discover': (context) => const MainNavigation(),
        '/cart': (context) => const MainNavigation(key: ValueKey('cart')),
        '/support': (context) => const SupportPage(),
        '/product-detail': (context) {
          final product = ModalRoute.of(context)!.settings.arguments as ProductEntity;
          return ProductDetailPage(product: product);
        },
      },
    );
  }
}
