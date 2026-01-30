import 'package:flutter/material.dart';
import 'package:pablito_ds/pablito_ds.dart';
import 'package:conectify/conectify.dart';

import '../../core/services/cart_service.dart';
import '../../core/models/cart_item.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final CartService _cart = CartService();
  List<Product> _products = [];
  List<Category> _categories = [];
  String _selectedCategory = 'all';
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final prods = await Conectify.getProducts();
      final cats = await Conectify.getCategories();
      setState(() {
        _products = prods;
        _categories = cats;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  List<Product> get _filtered {
    if (_selectedCategory == 'all') return _products;
    return _products
        .where(
          (p) => p.category.toLowerCase() == _selectedCategory.toLowerCase(),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(color: DesignTokens.primary),
      );
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingMD),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PabAlert(
                message: _error!,
                variant: AlertVariant.error,
                onClose: () => setState(() => _error = null),
              ),
              const SizedBox(height: DesignTokens.spacingLG),
              PabPrimaryButton(
                label: 'Reintentar',
                onPressed: _load,
                icon: Icons.refresh,
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final pad = DesignTokens.spacingMD;
        final isWide = constraints.maxWidth > 600;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: pad),
                children: [
                  _CategoryChip(
                    label: 'Todos',
                    selected: _selectedCategory == 'all',
                    onTap: () => setState(() => _selectedCategory = 'all'),
                  ),
                  ..._categories.map(
                    (c) => _CategoryChip(
                      label: c.name,
                      selected: _selectedCategory == c.name.toLowerCase(),
                      onTap: () => setState(
                        () => _selectedCategory = c.name.toLowerCase(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMD),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(pad),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isWide ? 3 : 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: pad,
                  mainAxisSpacing: pad,
                ),
                itemCount: _filtered.length,
                itemBuilder: (_, i) {
                  final p = _filtered[i];
                  return PabCard(
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/product-detail',
                      arguments: p,
                    ),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusMD,
                          ),
                          child: Image.network(
                            p.image,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 120,
                              color: DesignTokens.surfaceVariant,
                              child: const PabIcon(
                                icon: Icons.image_not_supported,
                                predefinedSize: IconSize.large,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: DesignTokens.spacingSM),
                        PabBodyText(
                          text: p.title,
                          size: BodyTextSize.small,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: DesignTokens.spacingXS),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PabHeading(
                              text: '\$${p.price.toStringAsFixed(2)}',
                              level: HeadingLevel.h5,
                              color: DesignTokens.primary,
                            ),
                            IconButton(
                              icon: const PabIcon(
                                icon: Icons.add_shopping_cart,
                                predefinedSize: IconSize.medium,
                              ),
                              onPressed: () {
                                _cart.addItem(CartItem(product: p));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: PabBodyText(
                                      text: 'Añadido al carrito',
                                      size: BodyTextSize.medium,
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: DesignTokens.spacingSM),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingMD,
            vertical: DesignTokens.spacingSM,
          ),
          decoration: BoxDecoration(
            color: selected
                ? DesignTokens.primary
                : DesignTokens.surfaceVariant,
            borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
          ),
          child: Center(
            child: PabBodyText(
              text: label,
              size: BodyTextSize.small,
              color: selected ? DesignTokens.onPrimary : DesignTokens.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
