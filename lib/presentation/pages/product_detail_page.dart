import 'package:flutter/material.dart';
import 'package:pablito_ds/pablito_ds.dart';
import 'package:conectify/conectify.dart';

import '../../core/services/cart_service.dart';
import '../../core/models/cart_item.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final CartService _cart = CartService();
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return PabBaseLayout(
      title: 'Detalle',
      onAppBarBack: () => Navigator.pop(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(DesignTokens.radiusLG),
            child: Image.network(
              p.image,
              height: 280,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 280,
                color: DesignTokens.surfaceVariant,
                child: const Icon(Icons.image_not_supported, size: 64),
              ),
            ),
          ),
          const SizedBox(height: DesignTokens.spacingLG),
          Row(
            children: [
              PabBadge(
                label: p.category,
                variant: BadgeVariant.primary,
                size: BadgeSize.small,
              ),
              const SizedBox(width: DesignTokens.spacingSM),
              PabBadge(
                label: '★ ${p.rating.rate} (${p.rating.count})',
                variant: BadgeVariant.warning,
                size: BadgeSize.small,
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingMD),
          PabHeading(text: p.title, level: HeadingLevel.h3),
          const SizedBox(height: DesignTokens.spacingSM),
          PabHeading(
            text: '\$${p.price.toStringAsFixed(2)}',
            level: HeadingLevel.h2,
            color: DesignTokens.primary,
          ),
          const SizedBox(height: DesignTokens.spacingLG),
          const PabHeading(text: 'Descripción', level: HeadingLevel.h5),
          const SizedBox(height: DesignTokens.spacingSM),
          PabBodyText(
            text: p.description,
            size: BodyTextSize.medium,
          ),
          const SizedBox(height: DesignTokens.spacingXL),
          Row(
            children: [
              const PabBodyText(text: 'Cantidad:', size: BodyTextSize.medium),
              const SizedBox(width: DesignTokens.spacingMD),
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: _qty > 1 ? () => setState(() => _qty--) : null,
              ),
              PabBodyText(text: '$_qty', size: BodyTextSize.medium),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => setState(() => _qty++),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingLG),
          PabPrimaryButton(
            label: 'Añadir al carrito',
            onPressed: () {
              _cart.addItem(CartItem(product: p, quantity: _qty));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${p.title} añadido al carrito')),
              );
            },
            icon: Icons.add_shopping_cart,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }
}
