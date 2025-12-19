import 'package:flutter/material.dart';
import '../../data/datasources/datasources.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/usecases/usecases.dart';
import '../widgets/product_list.dart';
import '../widgets/category_list.dart';
import '../widgets/user_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final GetProducts getProducts;
  late final GetCategories getCategories;
  late final GetUsers getUsers;

  @override
  void initState() {
    super.initState();
    // Inyección de dependencias
    final remoteDataSource = RemoteDataSourceImpl();
    final productRepository = ProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );
    final categoryRepository = CategoryRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );
    final userRepository = UserRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );

    // Casos de uso
    getProducts = GetProducts(productRepository);
    getCategories = GetCategories(categoryRepository);
    getUsers = GetUsers(userRepository);
  }

  @override
  Widget build(BuildContext context) {
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
        body: const TabBarView(
          children: [ProductList(), CategoryList(), UserList()],
        ),
      ),
    );
  }
}
