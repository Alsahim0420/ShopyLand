import 'package:flutter/material.dart';
import 'package:pablito_ds/pablito_ds.dart';

import '../../core/services/cart_service.dart';
import 'home_page.dart';
import 'discover_page.dart';
import 'search_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;
  final CartService _cart = CartService();

  static final _navItems = [
    PabNavBarItem(icon: Icons.home, label: 'Inicio'),
    PabNavBarItem(icon: Icons.category, label: 'Catálogo'),
    PabNavBarItem(icon: Icons.search, label: 'Buscar'),
    PabNavBarItem(icon: Icons.shopping_cart, label: 'Carrito'),
    PabNavBarItem(icon: Icons.person, label: 'Perfil'),
  ];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(onOpenCatalog: () => setState(() => _index = 1)),
      const DiscoverPage(),
      const SearchPage(),
      CartPage(onOpenCatalog: () => setState(() => _index = 1)),
      const ProfilePage(),
    ];
    _cart.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    _cart.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.background,
      body: SafeArea(
        child: Column(
          children: [
            PabAppHeader(
              title: 'ShopyLand',
              actions: _index != 3
                  ? [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_cart_outlined),
                            onPressed: () => setState(() => _index = 3),
                          ),
                          if (_cart.itemCount > 0)
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: DesignTokens.error,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Text(
                                  '${_cart.itemCount}',
                                  style: const TextStyle(
                                    color: DesignTokens.onPrimary,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ]
                  : null,
            ),
            Expanded(
              child: IndexedStack(index: _index, children: _pages),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PabNavBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: _navItems,
      ),
    );
  }
}
