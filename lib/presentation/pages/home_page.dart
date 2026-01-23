import 'package:flutter/material.dart';
import 'package:pablito_ds/pablito_ds.dart';
import '../../core/di/injection_container.dart';
import '../widgets/product_list.dart';
import '../widgets/category_list.dart';
import '../widgets/user_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Inyección de dependencias centralizada
    final container = InjectionContainer();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Row(
            children: [
              Icon(Icons.shopping_cart, color: cs.onPrimary),
              const SizedBox(width: DesignTokens.spacingSM),
              const Text(
                'ShopyLand',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              color: cs.surface,
              child: TabBar(
                indicatorColor: cs.primary,
                indicatorWeight: 3,
                labelColor: cs.primary,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.shopping_bag),
                    text: 'Productos',
                  ),
                  Tab(
                    icon: Icon(Icons.category),
                    text: 'Categorías',
                  ),
                  Tab(
                    icon: Icon(Icons.people),
                    text: 'Usuarios',
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                cs.primary.withValues(alpha: 0.05),
                cs.surface,
              ],
            ),
          ),
          child: TabBarView(
            children: [
              ProductList(getProducts: container.getProducts),
              CategoryList(getCategories: container.getCategories),
              UserList(getUsers: container.getUsers),
            ],
          ),
        ),
      ),
    );
  }
}
