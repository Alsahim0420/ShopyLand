import 'package:flutter/material.dart';
import 'package:pablito_ds/pablito_ds.dart';
import '../../core/di/injection_container.dart';
import '../../core/services/cart_service.dart';
import '../../core/models/cart_item.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../widgets/product_card.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  late final GetProducts _getProducts;
  final CartService _cartService = CartService();

  @override
  void initState() {
    super.initState();
    _getProducts = InjectionContainer().getProducts;
    _loadProducts();
  }
  
  List<ProductEntity>? _products;
  String? _errorMessage;
  bool _isLoading = true;
  String _selectedCategory = 'All';


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
          _products = productsList;
          _isLoading = false;
        });
      },
    );
  }

  List<ProductEntity> get _filteredProducts {
    if (_products == null) return [];
    if (_selectedCategory == 'All') return _products!;
    return _products!.where((p) => p.category == _selectedCategory.toLowerCase()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? _buildErrorView()
                : _buildContent(),
      ),
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

  Widget _buildContent() {
    return CustomScrollView(
      slivers: [
        _buildHeader(),
        _buildPromoBanner(),
        _buildCategoryFilters(),
        _buildSectionTitle(),
        _buildProductsGrid(),
      ],
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discover',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Find your favorite products',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () {
                    Navigator.pushNamed(context, '/home', arguments: 2);
                  },
                ),
                if (_cartService.itemCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: DesignTokens.error,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${_cartService.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return SliverToBoxAdapter(
      child: Container(
        height: 220,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              DesignTokens.primary,
              DesignTokens.secondary,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -50,
              bottom: -50,
              child: Icon(
                Icons.shopping_bag,
                size: 200,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      'SUMMER SALE',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: DesignTokens.fontSizeSM,
                        fontWeight: DesignTokens.fontWeightSemiBold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Flexible(
                    child: Text(
                      '50% Off',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: DesignTokens.fontSizeXXL,
                        fontWeight: DesignTokens.fontWeightBold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    child: Text(
                      'Fashion',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: DesignTokens.fontSizeLG,
                        fontWeight: DesignTokens.fontWeightBold,
                      ),
                    ),
                  ),
                  const SizedBox(height: DesignTokens.spacingMD),
                  PrimaryButton(
                    label: 'Shop Now',
                    onPressed: () {},
                    icon: Icons.shopping_bag,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    final categories = ['All', 'Electronics', 'Jewelery', "Men's", "Women's"];
    
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = _selectedCategory == category;
            return Padding(
              padding: const EdgeInsets.only(right: DesignTokens.spacingMD),
              child: FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                selectedColor: DesignTokens.primary,
                labelStyle: TextStyle(
                  color: isSelected ? DesignTokens.onPrimary : DesignTokens.onSurface,
                  fontWeight: isSelected ? DesignTokens.fontWeightBold : DesignTokens.fontWeightRegular,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedCategory == 'All' 
                  ? 'All Products' 
                  : _selectedCategory,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () {
                    _showFilterDialog(context);
                  },
                  tooltip: 'Filter',
                ),
                DropdownButton<String>(
                  value: 'Most Relevant',
                  items: const [
                    DropdownMenuItem(
                      value: 'Most Relevant',
                      child: Text('Most Relevant'),
                    ),
                    DropdownMenuItem(
                      value: 'Price: Low to High',
                      child: Text('Price: Low to High'),
                    ),
                    DropdownMenuItem(
                      value: 'Price: High to Low',
                      child: Text('Price: High to Low'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      _sortProducts(value);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _sortProducts(String sortBy) {
    if (_products == null) return;

    setState(() {
      switch (sortBy) {
        case 'Price: Low to High':
          _products!.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'Price: High to Low':
          _products!.sort((a, b) => b.price.compareTo(a.price));
          break;
        default:
          // Most Relevant - orden original
          break;
      }
    });
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Products',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Price Range',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            // Aquí puedes agregar más opciones de filtro
            const Text('More filter options coming soon...'),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Apply Filters',
              isFullWidth: true,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsGrid() {
    final products = _filteredProducts;
    
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = products[index];
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
                setState(() {});
              },
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }
}
