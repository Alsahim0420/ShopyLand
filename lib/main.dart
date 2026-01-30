import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pablito_ds/pablito_ds.dart';
import 'package:conectify/conectify.dart';

import 'core/services/auth_service.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/register_page.dart';
import 'presentation/pages/main_navigation.dart';
import 'presentation/pages/product_detail_page.dart';
import 'presentation/pages/support_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(const ShopyLandApp());
}

class ShopyLandApp extends StatelessWidget {
  const ShopyLandApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    return MaterialApp(
      title: 'ShopyLand',
      debugShowCheckedModeBanner: false,
      theme: DesignTheme.lightTheme,
      initialRoute: auth.isAuthenticated ? '/home' : '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/home': (_) => const MainNavigation(),
        '/support': (_) => const SupportPage(),
        '/product-detail': (ctx) {
          final product = ModalRoute.of(ctx)!.settings.arguments! as Product;
          return ProductDetailPage(product: product);
        },
      },
    );
  }
}
