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
    return PabDashboardLayout(
      title: 'ShopyLand',
      currentNavIndex: _index,
      onNavTap: (i) => setState(() => _index = i),
      navItems: _navItems,
      headerActions: _index != 3
          ? [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const PabIcon(
                      icon: Icons.shopping_cart_outlined,
                      predefinedSize: IconSize.medium,
                    ),
                    onPressed: () => setState(() => _index = 3),
                  ),
                  if (_cart.itemCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(DesignTokens.spacingXS),
                        decoration: const BoxDecoration(
                          color: DesignTokens.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Center(
                          child: PabBodyText(
                            text: '${_cart.itemCount}',
                            size: BodyTextSize.small,
                            color: DesignTokens.onPrimary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ]
          : null,
      body: SafeArea(
        child: IndexedStack(index: _index, children: _pages),
      ),
    );
  }
}
