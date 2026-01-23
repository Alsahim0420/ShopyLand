import 'package:flutter/material.dart';
import 'package:pablito_ds/pablito_ds.dart';
import '../../core/di/injection_container.dart';
import '../../core/services/cart_service.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../widgets/product_card.dart';
import '../../core/models/cart_item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final GetProducts _getProducts = InjectionContainer().getProducts;
  final CartService _cartService = CartService();
  final TextEditingController _searchController = TextEditingController();
  
  List<ProductEntity>? _allProducts;
  List<ProductEntity> _filteredProducts = [];
  List<String> _recentSearches = ['iPhone 13 case', "Men's cotton jacket"];
  final List<String> _suggestedCategories = [
    'Electronics',
    'Jewelery',
    "Men's Clothing",
    'Best Sellers 🔥',
  ];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    final result = await _getProducts();
    result.fold(
      (failure) {
        setState(() {
          _errorMessage = failure.message;
          _isLoading = false;
        });
      },
      (productsList) {
        setState(() {
          _allProducts = productsList;
          _isLoading = false;
        });
      },
    );
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredProducts = [];
      });
      return;
    }

    if (_allProducts == null) return;

    setState(() {
      _filteredProducts = _allProducts!.where((product) {
        final searchLower = query.toLowerCase();
        return product.title.toLowerCase().contains(searchLower) ||
            product.description.toLowerCase().contains(searchLower) ||
            product.category.toLowerCase().contains(searchLower);
      }).toList();
    });

    if (!_recentSearches.contains(query) && query.isNotEmpty) {
      setState(() {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 5) {
          _recentSearches = _recentSearches.take(5).toList();
        }
      });
    }
  }

  void _clearRecentSearches() {
    setState(() {
      _recentSearches.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _performSearch('');
                    },
                  )
                : null,
          ),
          onChanged: _performSearch,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {
              // TODO: Implementar filtros
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorView()
              : _searchController.text.isEmpty
                  ? _buildSearchSuggestions()
                  : _buildSearchResults(),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: DesignTokens.error),
          const SizedBox(height: DesignTokens.spacingLG),
          BodyText(
            text: _errorMessage!,
            size: BodyTextSize.medium,
          ),
          const SizedBox(height: DesignTokens.spacingLG),
          PrimaryButton(
            label: 'Reintentar',
            icon: Icons.refresh,
            onPressed: _loadProducts,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Searches',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _clearRecentSearches,
                  child: const Text('Clear All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._recentSearches.map((search) => _buildRecentSearchItem(search)),
            const SizedBox(height: 24),
          ],
          const Text(
            'Suggested for You',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _suggestedCategories.map((category) {
              return Chip(
                label: Text(category),
                onDeleted: null,
                backgroundColor: DesignTokens.primary.withValues(alpha: 0.1),
                labelStyle: TextStyle(color: DesignTokens.primary),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearchItem(String search) {
    return ListTile(
      leading: const Icon(Icons.history, color: Colors.grey),
      title: Text(search),
      trailing: const Icon(Icons.arrow_upward, size: 16, color: Colors.grey),
      onTap: () {
        _searchController.text = search;
        _performSearch(search);
      },
    );
  }

  Widget _buildSearchResults() {
    if (_filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'No results found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "We couldn't find any items matching '${_searchController.text}'. Try searching for something else.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'View Categories',
              icon: Icons.category,
              onPressed: () {
                Navigator.pushNamed(context, '/discover');
              },
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_filteredProducts.length} items found',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton<String>(
                value: 'Most Relevant',
                items: const [
                  DropdownMenuItem(value: 'Most Relevant', child: Text('Most Relevant')),
                  DropdownMenuItem(value: 'Price: Low to High', child: Text('Price: Low to High')),
                  DropdownMenuItem(value: 'Price: High to Low', child: Text('Price: High to Low')),
                ],
                onChanged: (value) {
                  // TODO: Implementar ordenamiento
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              final product = _filteredProducts[index];
              return ProductCard(
                product: product,
                onAddToCart: () {
                  _cartService.addItem(CartItem(product: product));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Producto agregado al carrito'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
