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
          elevation: 0,
          title: const Row(
            children: [
              Icon(Icons.shopping_cart, color: Colors.white),
              SizedBox(width: 8),
              Text(
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
              color: Colors.white,
              child: const TabBar(
                indicatorColor: Colors.blue,
                indicatorWeight: 3,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                tabs: [
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
                Colors.blue[50]!.withValues(alpha: 0.3),
                Colors.white,
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
