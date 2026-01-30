import 'package:flutter/material.dart';
import 'package:pablito_ds/pablito_ds.dart';
import 'package:conectify/conectify.dart';

import '../../core/services/cart_service.dart';
import '../../core/models/cart_item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final CartService _cart = CartService();
  final TextEditingController _query = TextEditingController();
  List<Product> _all = [];
  List<Product> _results = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
    _query.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _query.removeListener(_onQueryChanged);
    _query.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    final q = _query.text.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() => _results = []);
      return;
    }
    setState(() {
      _results = _all.where((p) {
        return p.title.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q);
      }).toList();
    });
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await Conectify.getProducts();
      setState(() {
        _all = list;
        _loading = false;
      });
      _onQueryChanged();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingMD),
          child: PabSearchBar(
            hint: 'Buscar por nombre o descripción',
            controller: _query,
            onChanged: (_) => _onQueryChanged(),
            onClear: () {
              _query.clear();
              _onQueryChanged();
            },
          ),
        ),
        Expanded(
          child: _loading
              ? Center(
                  child: CircularProgressIndicator(color: DesignTokens.primary),
                )
              : _error != null
              ? Center(
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
                )
              : _query.text.trim().isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PabIcon(
                        icon: Icons.search,
                        predefinedSize: IconSize.xlarge,
                        color: DesignTokens.primary,
                      ),
                      const SizedBox(height: DesignTokens.spacingMD),
                      PabBodyText(
                        text: 'Escribe para buscar productos',
                        size: BodyTextSize.medium,
                      ),
                    ],
                  ),
                )
              : _results.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PabIcon(
                        icon: Icons.search_off,
                        predefinedSize: IconSize.xlarge,
                        color: DesignTokens.secondary,
                      ),
                      const SizedBox(height: DesignTokens.spacingMD),
                      const PabHeading(
                        text: 'Sin resultados',
                        level: HeadingLevel.h4,
                      ),
                      const SizedBox(height: DesignTokens.spacingSM),
                      PabBodyText(
                        text: 'No hay productos para "${_query.text}"',
                        size: BodyTextSize.medium,
                      ),
                    ],
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final pad = DesignTokens.spacingMD;
                    final isWide = constraints.maxWidth > 600;
                    return GridView.builder(
                      padding: EdgeInsets.all(pad),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isWide ? 3 : 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: pad,
                        mainAxisSpacing: pad,
                      ),
                      itemCount: _results.length,
                      itemBuilder: (_, i) {
                        final p = _results[i];
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: PabBodyText(
                                            text: 'Añadido al carrito',
                                            size: BodyTextSize.medium,
                                          ),
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
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
