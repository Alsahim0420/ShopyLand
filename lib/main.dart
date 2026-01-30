import 'package:flutter/material.dart';
import 'package:pablito_ds/pablito_ds.dart';
import 'package:conectify/conectify.dart';

import 'presentation/pages/login_page.dart';
import 'presentation/pages/register_page.dart';
import 'presentation/pages/main_navigation.dart';
import 'presentation/pages/support_page.dart';
import 'presentation/pages/product_detail_page.dart';

void main() {
  runApp(const ShopyLandApp());
}

class ShopyLandApp extends StatelessWidget {
  const ShopyLandApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopyLand',
      debugShowCheckedModeBanner: false,
      theme: DesignTheme.lightTheme,
      darkTheme: DesignTheme.darkTheme,
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/home': (_) => const MainNavigation(),
        '/support': (_) => const SupportPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/product-detail') {
          final product = settings.arguments as Product?;
          if (product == null) return null;
          return MaterialPageRoute<void>(
            builder: (_) => ProductDetailPage(product: product),
          );
        }
        return null;
      },
    );
  }
}
