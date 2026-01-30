import 'package:flutter/material.dart';
import 'package:pablito_ds/pablito_ds.dart';
import 'package:conectify/conectify.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.onOpenCatalog});

  final VoidCallback? onOpenCatalog;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> _featured = [];
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
      final all = await Conectify.getProducts();
      setState(() {
        _featured = all.take(6).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
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
        return SingleChildScrollView(
          padding: EdgeInsets.all(pad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const PabHeading(text: 'Descubre', level: HeadingLevel.h2),
              const SizedBox(height: DesignTokens.spacingXS),
              PabBodyText(
                text: 'Encuentra tus productos favoritos',
                size: BodyTextSize.medium,
              ),
              const SizedBox(height: DesignTokens.spacingLG),
              _PromoBanner(onShop: widget.onOpenCatalog),
              const SizedBox(height: DesignTokens.spacingXL),
              const PabHeading(text: 'Destacados', level: HeadingLevel.h4),
              const SizedBox(height: DesignTokens.spacingMD),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isWide ? 3 : 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: pad,
                  mainAxisSpacing: pad,
                ),
                itemCount: _featured.length,
                itemBuilder: (_, i) => _ProductTile(
                  product: _featured[i],
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/product-detail',
                    arguments: _featured[i],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner({this.onShop});

  final VoidCallback? onShop;

  @override
  Widget build(BuildContext context) {
    return PabCard(
      padding: const EdgeInsets.all(DesignTokens.spacingLG),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PabBodyText(
            text: 'OFERTA',
            size: BodyTextSize.small,
            color: DesignTokens.primary,
          ),
          const SizedBox(height: DesignTokens.spacingSM),
          const PabHeading(text: '50% en moda', level: HeadingLevel.h3),
          const SizedBox(height: DesignTokens.spacingMD),
          PabPrimaryButton(
            label: 'Ver catálogo',
            onPressed: onShop,
            icon: Icons.shopping_bag,
          ),
        ],
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product, this.onTap});

  final Product product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PabCard(
      onTap: onTap,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
            child: Image.network(
              product.image,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 120,
                color: DesignTokens.surfaceVariant,
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          const SizedBox(height: DesignTokens.spacingSM),
          PabBodyText(
            text: product.title,
            size: BodyTextSize.small,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: DesignTokens.spacingXS),
          PabHeading(
            text: '\$${product.price.toStringAsFixed(2)}',
            level: HeadingLevel.h5,
            color: DesignTokens.primary,
          ),
        ],
      ),
    );
  }
}
