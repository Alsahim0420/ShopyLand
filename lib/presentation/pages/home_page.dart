import 'package:flutter/material.dart';
import '../../core/di/injection_container.dart';
import '../widgets/product_list.dart';
import '../widgets/category_list.dart';
import '../widgets/user_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inyección de dependencias centralizada
    final container = InjectionContainer();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ShopyLand'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.shopping_bag), text: 'Productos'),
              Tab(icon: Icon(Icons.category), text: 'Categorías'),
              Tab(icon: Icon(Icons.people), text: 'Usuarios'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ProductList(getProducts: container.getProducts),
            CategoryList(getCategories: container.getCategories),
            UserList(getUsers: container.getUsers),
          ],
        ),
      ),
    );
  }
}
