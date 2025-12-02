import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/models/layout.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/repositories/cart_repository.dart';

class ProductPage extends StatefulWidget {
  /// Optional overrides for product details (passed via navigation)
  /// Used when navigating from product cards with pre-loaded data
  final String? titleOverride;
  final String? priceOverride;
  final String? imageUrlOverride;
  final String? discountPriceOverride;

  const ProductPage({
    super.key,
    this.titleOverride,
    this.priceOverride,
    this.imageUrlOverride,
    this.discountPriceOverride,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _quantity = 1;
  late final TextEditingController _qtyController =
      TextEditingController(text: '1');

  // Add: options state and defaults
  static const List<String> _sizeOptions = ['XS', 'S', 'M', 'L', 'XL'];
  static const List<String> _colorOptions = [
    'Black',
    'White',
    'Grey',
    'Blue',
    'Red'
  ];
  String _selectedSize = _sizeOptions.first;
  String _selectedColor = _colorOptions.first;

  // Add: helper to detect clothing-like titles
  /// Determines if product is clothing by checking title keywords
  /// Used to show/hide size and color options
  bool _isClothingTitle(String title) {
    final t = title.toLowerCase();
    return t.contains('hoodie') ||
        t.contains('tee') ||
        t.contains('t-shirt') ||
        t.contains('tshirt') ||
        t.contains('shirt');
  }

  void navigateToHome(BuildContext context) {
    context.go('/');
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  void _addToCart(BuildContext context) {
    final cartRepo = Provider.of<CartRepository>(context, listen: false);
    final title = widget.titleOverride ?? 'Sample Product';
    final priceStr =
        widget.discountPriceOverride ?? widget.priceOverride ?? '0.00';
    final price = double.tryParse(priceStr.replaceAll('£', '')) ?? 0.0;
    final imageUrl = widget.imageUrlOverride ?? 'assets/images/logo.avif';

    // Build selected options map
    final selectedOptions = <String, dynamic>{};
    if (_isClothingTitle(title)) {
      selectedOptions['Size'] = _selectedSize;
      selectedOptions['Color'] = _selectedColor;
    }

    // Add to cart
    cartRepo.addItem(
      productId: title.toLowerCase().replaceAll(' ', '-'),
      title: title,
      price: price,
      imageUrl: imageUrl,
      quantity: _quantity,
      selectedOptions: selectedOptions.isNotEmpty ? selectedOptions : null,
    );
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  // Remove old onTapDown-based helper and use a context-anchored menu instead
  Future<void> _openMenuForBox({
    required BuildContext boxContext,
    required List<String> options,
    required String current,
    required ValueChanged<String> onChanged,
    required String keyPrefix,
  }) async {
    final renderBox = boxContext.findRenderObject() as RenderBox;
    final overlay =
        Overlay.of(boxContext).context.findRenderObject() as RenderBox;

    final offset = renderBox.localToGlobal(Offset.zero);
    final position = RelativeRect.fromLTRB(
      offset.dx,
      offset.dy + renderBox.size.height,
      overlay.size.width - offset.dx - renderBox.size.width,
      overlay.size.height - offset.dy - renderBox.size.height,
    );

    final selected = await showMenu<String>(
      context: boxContext,
      position: position,
      items: [
        for (final o in options)
          PopupMenuItem<String>(
            key: Key('product:$keyPrefix-option-$o'),
            value: o,
            child: Row(
              children: [
                if (o == current)
                  const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(Icons.check, size: 16),
                  ),
                Text(o),
              ],
            ),
          ),
      ],
    );
    if (selected != null) onChanged(selected);
  }

  // Helper: boxed dropdown styled like quantity box (tap to open menu)
  Widget _buildBoxDropdown({
    required Key key,
    required String value,
    required List<String> options,
    required ValueChanged<String> onChanged,
    required String keyPrefix,
  }) {
    return Builder(
      builder: (ctx) => InkWell(
        onTap: () {
          _openMenuForBox(
            boxContext: ctx,
            options: options,
            current: value,
            onChanged: onChanged,
            keyPrefix: keyPrefix,
          );
        },
        child: SizedBox(
          key: key,
          height: 36,
          child: Stack(
            children: [
              // Base box (matches quantity outline and padding)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF4d2963)),
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.fromLTRB(8, 8, 36, 8),
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4d2963),
                  ),
                ),
              ),
              // Right "dropdown" area like quantity box
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 36,
                  decoration: const BoxDecoration(
                    border: Border(left: BorderSide(color: Color(0xFF4d2963))),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.keyboard_arrow_down,
                      size: 18, color: Color(0xFF4d2963)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String title =
        widget.titleOverride ?? (args?['title'] as String?) ?? 'Product';
    final String price =
        widget.priceOverride ?? (args?['price'] as String?) ?? '';
    final String rawImageUrl =
        widget.imageUrlOverride ?? (args?['imageUrl'] as String?) ?? '';
    // Helper to parse price strings like '£14.99' to double for comparisons
    double _parsePrice(String price) {
      final cleaned = price.replaceAll(RegExp(r'[^0-9.]'), '');
      return double.tryParse(cleaned) ?? 0.0;
    }

    // Only support local asset images: normalize and root at assets/images/
    String imageUrl = rawImageUrl.trim();
    if (imageUrl.startsWith('/')) imageUrl = imageUrl.substring(1);
    if (imageUrl.isNotEmpty && !imageUrl.startsWith('assets/')) {
      imageUrl = 'assets/images/$imageUrl';
    }
    final String? discountPrice =
        widget.discountPriceOverride ?? (args?['discountPrice'] as String?);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            const SiteHeader(),

            // Product details
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bool isWide = constraints.maxWidth >= 800;

                  Widget imageWidget = Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: imageUrl.isEmpty
                          ? Container(
                              key: const Key('product:image'),
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : Image.asset(
                              key: const Key('product:image'),
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image_not_supported,
                                        size: 64,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 8),
                                      Text('Image unavailable',
                                          style: TextStyle(color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ),
                  );

                  Widget detailsColumn = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        key: const Key('product:title'),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          if (discountPrice != null &&
                              _parsePrice(discountPrice) < _parsePrice(price))
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                price.isNotEmpty ? price : '—',
                                key: const Key('product:originalPrice'),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF666666),
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                          Text(
                            (discountPrice != null &&
                                    _parsePrice(discountPrice) <
                                        _parsePrice(price))
                                ? discountPrice
                                : (price.isNotEmpty ? price : '—'),
                            key: const Key('product:price'),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4d2963),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Add: Clothing options (only for hoodie/tee/shirt)
                      if (_isClothingTitle(title)) ...[
                        const SizedBox(height: 12),
                        Text('Options',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 6),
                        const Text('Size'),
                        const SizedBox(height: 6),
                        _buildBoxDropdown(
                          key: const Key('product:size-selector'),
                          value: _selectedSize,
                          options: _sizeOptions,
                          onChanged: (v) => setState(() => _selectedSize = v),
                          keyPrefix: 'size',
                        ),
                        const SizedBox(height: 8),
                        const Text('Color'),
                        const SizedBox(height: 6),
                        _buildBoxDropdown(
                          key: const Key('product:color-selector'),
                          value: _selectedColor,
                          options: _colorOptions,
                          onChanged: (v) => setState(() => _selectedColor = v),
                          keyPrefix: 'color',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Selected: $_selectedSize, $_selectedColor',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Quantity selector with inline arrows (updated)
                      SizedBox(
                        key: const Key('product:quantity-row'),
                        width: 120,
                        height: 36,
                        child: Stack(
                          children: [
                            TextField(
                              key: const Key('product:quantity-input'),
                              controller: _qtyController,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (val) {
                                final parsed = int.tryParse(val);
                                setState(() {
                                  _quantity = (parsed == null || parsed <= 0)
                                      ? 1
                                      : parsed;
                                  if (_quantity == 1 &&
                                      (parsed == null || parsed <= 0)) {
                                    _qtyController.text = '1';
                                    _qtyController.selection =
                                        TextSelection.collapsed(
                                            offset: _qtyController.text.length);
                                  }
                                });
                              },
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(8, 8, 36, 8),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF4d2963)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFF4d2963), width: 2),
                                ),
                              ),
                              style: const TextStyle(fontSize: 16),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                width: 36,
                                decoration: const BoxDecoration(
                                  border: Border(
                                      left:
                                          BorderSide(color: Color(0xFF4d2963))),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        key: const Key('product:qty-increase'),
                                        onTap: () {
                                          setState(() {
                                            _quantity++;
                                            _qtyController.text = '$_quantity';
                                          });
                                        },
                                        child: const Icon(
                                            Icons.keyboard_arrow_up,
                                            size: 18,
                                            color: Color(0xFF4d2963)),
                                      ),
                                    ),
                                    const Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: Color(0xFF4d2963)),
                                    Expanded(
                                      child: InkWell(
                                        key: const Key('product:qty-decrease'),
                                        onTap: () {
                                          if (_quantity > 1) {
                                            setState(() {
                                              _quantity--;
                                              _qtyController.text =
                                                  '$_quantity';
                                            });
                                          }
                                        },
                                        child: const Icon(
                                            Icons.keyboard_arrow_down,
                                            size: 18,
                                            color: Color(0xFF4d2963)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          key: const Key('product:add-to-cart'),
                          onPressed: () => _addToCart(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4d2963),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: const Text(
                            'ADD TO CART',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'This is a placeholder description for the product. Students should replace this with real product information and implement proper data management.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Students should add size options, colour options, quantity selector, add to cart button, and buy now button here.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),
                    ],
                  );

                  if (isWide) {
                    // Two-column layout
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: imageWidget,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 6,
                          child: detailsColumn,
                        ),
                      ],
                    );
                  } else {
                    // Stacked layout (mobile)
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 220,
                          width: double.infinity,
                          child: imageWidget,
                        ),
                        const SizedBox(height: 24),
                        detailsColumn,
                      ],
                    );
                  }
                },
              ),
            ),

            // Footer
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}
