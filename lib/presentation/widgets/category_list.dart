import 'package:flutter/material.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';

class CategoryList extends StatefulWidget {
  final GetCategories getCategories;

  const CategoryList({super.key, required this.getCategories});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<CategoryEntity>? categories;
  String? errorMessage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final result = await widget.getCategories();
    result.fold(
      (failure) {
        setState(() {
          errorMessage = failure.message;
          isLoading = false;
        });
      },
      (categoriesList) {
        setState(() {
          categories = categoriesList;
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $errorMessage'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCategories,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (categories == null || categories!.isEmpty) {
      return const Center(child: Text('No hay categorías disponibles'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: categories!.length,
      itemBuilder: (context, index) {
        final category = categories![index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.category, color: Colors.blue),
            title: Text(
              category.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }
}
