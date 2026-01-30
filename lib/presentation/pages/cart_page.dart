import 'package:flutter/material.dart';
import 'package:pablito_ds/pablito_ds.dart';

import '../../core/services/cart_service.dart';
import '../../core/models/cart_item.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key, this.onOpenCatalog});

  final VoidCallback? onOpenCatalog;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cart = CartService();

  @override
  void initState() {
    super.initState();
    _cart.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    _cart.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final items = _cart.items;
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingLG),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PabIcon(
                icon: Icons.shopping_cart_outlined,
                predefinedSize: IconSize.xlarge,
                color: DesignTokens.secondary,
              ),
              const SizedBox(height: DesignTokens.spacingLG),
              const PabHeading(text: 'Carrito vacío', level: HeadingLevel.h4),
              const SizedBox(height: DesignTokens.spacingSM),
              PabBodyText(
                text: 'Añade productos para continuar',
                size: BodyTextSize.medium,
              ),
              const SizedBox(height: DesignTokens.spacingXL),
              PabPrimaryButton(
                label: 'Ver catálogo',
                onPressed: widget.onOpenCatalog,
                icon: Icons.shopping_bag,
              ),
            ],
          ),
        ),
      );
    }

    final subtotal = _cart.totalPrice;
    final tax = subtotal * 0.08;
    final total = subtotal + tax;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(DesignTokens.spacingMD),
            itemCount: items.length,
            itemBuilder: (_, i) => _CartItemRow(
              item: items[i],
              onRemove: () {
                _cart.removeItem(items[i].product.id);
              },
              onUpdateQty: (q) {
                _cart.updateQuantity(items[i].product.id, q);
              },
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(DesignTokens.spacingMD),
          decoration: BoxDecoration(
            color: DesignTokens.surface,
            border: Border(
              top: BorderSide(color: DesignTokens.border),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const PabBodyText(text: 'Subtotal', size: BodyTextSize.medium),
                    PabBodyText(
                      text: '\$${subtotal.toStringAsFixed(2)}',
                      size: BodyTextSize.medium,
                    ),
                  ],
                ),
                const SizedBox(height: DesignTokens.spacingSM),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PabBodyText(
                      text: 'Impuesto (8%)',
                      size: BodyTextSize.medium,
                    ),
                    PabBodyText(
                      text: '\$${tax.toStringAsFixed(2)}',
                      size: BodyTextSize.medium,
                    ),
                  ],
                ),
                const PabDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const PabHeading(text: 'Total', level: HeadingLevel.h5),
                    PabHeading(
                      text: '\$${total.toStringAsFixed(2)}',
                      level: HeadingLevel.h5,
                      color: DesignTokens.primary,
                    ),
                  ],
                ),
                const SizedBox(height: DesignTokens.spacingMD),
                Row(
                  children: [
                    PabSecondaryButton(
                      label: 'Vaciar',
                      onPressed: _showClearDialog,
                      isFullWidth: false,
                    ),
                    const SizedBox(width: DesignTokens.spacingMD),
                    Expanded(
                      child: PabPrimaryButton(
                        label: 'Checkout',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Checkout en desarrollo'),
                            ),
                          );
                        },
                        icon: Icons.arrow_forward,
                        isFullWidth: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Vaciar carrito'),
        content: const Text(
          '¿Quieres eliminar todos los productos del carrito?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _cart.clear();
              Navigator.pop(ctx);
              setState(() {});
            },
            child: const Text('Vaciar', style: TextStyle(color: DesignTokens.error)),
          ),
        ],
      ),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  const _CartItemRow({
    required this.item,
    required this.onRemove,
    required this.onUpdateQty,
  });

  final CartItem item;
  final VoidCallback onRemove;
  final void Function(int) onUpdateQty;

  @override
  Widget build(BuildContext context) {
    final p = item.product;
    return PabCard(
      padding: const EdgeInsets.all(DesignTokens.spacingSM),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
            child: Image.network(
              p.image,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 72,
                height: 72,
                color: DesignTokens.surfaceVariant,
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          const SizedBox(width: DesignTokens.spacingMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PabBodyText(
                  text: p.title,
                  size: BodyTextSize.small,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: DesignTokens.spacingXS),
                PabBodyText(
                  text: p.category,
                  size: BodyTextSize.small,
                ),
                const SizedBox(height: DesignTokens.spacingXS),
                PabHeading(
                  text: '\$${p.price.toStringAsFixed(2)}',
                  level: HeadingLevel.h6,
                  color: DesignTokens.primary,
                ),
                const SizedBox(height: DesignTokens.spacingSM),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 18),
                      onPressed: item.quantity > 1
                          ? () => onUpdateQty(item.quantity - 1)
                          : null,
                    ),
                    PabBodyText(
                      text: '${item.quantity}',
                      size: BodyTextSize.medium,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 18),
                      onPressed: () => onUpdateQty(item.quantity + 1),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: onRemove,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
