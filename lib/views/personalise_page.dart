import 'package:flutter/material.dart';
import 'package:union_shop/models/layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/repositories/cart_repository.dart';

class PersonalisePage extends StatefulWidget {
  const PersonalisePage({super.key});

  @override
  State<PersonalisePage> createState() => _PersonalisePageState();
}

class _PersonalisePageState extends State<PersonalisePage> {
  int _quantity = 1;
  late final TextEditingController _qtyController =
      TextEditingController(text: '1');

  // Text controllers for customization lines
  late final TextEditingController _line1Controller = TextEditingController();
  late final TextEditingController _line2Controller = TextEditingController();
  late final TextEditingController _line3Controller = TextEditingController();

  // Personalisation options
  static const List<String> _personalisationOptions = [
    'One Line of Text',
    'Two Lines of Text',
    'Three Lines of Text',
    'Small Logo',
    'Big Logo'
  ];
  String _selectedPersonalisation = _personalisationOptions.first;

  // Helper to determine number of text lines needed
  int _getNumberOfLines() {
    if (_selectedPersonalisation == 'One Line of Text') return 1;
    if (_selectedPersonalisation == 'Two Lines of Text') return 2;
    if (_selectedPersonalisation == 'Three Lines of Text') return 3;
    return 0; // For logo options, no text input needed
  }

  void _addToCart(
      BuildContext context, String title, double price, String imageUrl) {
    final cartRepo = Provider.of<CartRepository>(context, listen: false);

    // Build customization text
    final customizationLines = <String>[];
    if (_getNumberOfLines() >= 1 && _line1Controller.text.isNotEmpty) {
      customizationLines.add(_line1Controller.text);
    }
    if (_getNumberOfLines() >= 2 && _line2Controller.text.isNotEmpty) {
      customizationLines.add(_line2Controller.text);
    }
    if (_getNumberOfLines() >= 3 && _line3Controller.text.isNotEmpty) {
      customizationLines.add(_line3Controller.text);
    }

    // Build selected options map for personalization
    final selectedOptions = <String, dynamic>{
      'Personalisation Type': _selectedPersonalisation,
      if (customizationLines.isNotEmpty)
        'Custom Text': customizationLines.join(' | '),
    };

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

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  // Helper: open menu for dropdown
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

  // Helper: boxed dropdown widget
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

  String _formatPrice(dynamic value) {
    if (value == null) return '';
    final numValue = value is double || value is int
        ? value as num
        : double.tryParse(value.toString()) ?? 0;
    return '£${numValue.toStringAsFixed(2)}';
  }

  double _parsePrice(dynamic value) {
    if (value == null) return 0.0;
    if (value is double || value is int) return (value as num).toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _line1Controller.dispose();
    _line2Controller.dispose();
    _line3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('products')
              .doc('personalise')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                children: [
                  SiteHeader(),
                  Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
              );
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Column(
                children: [
                  SiteHeader(),
                  Expanded(
                    child: Center(
                      child: Text('Personalise product not found'),
                    ),
                  ),
                  SiteFooter(),
                ],
              );
            }

            final data = snapshot.data!.data()!;
            final String title = data['title'] ?? 'Personalise Product';
            final price = data['price'] ?? 0;
            final discountPrice = data['discountPrice'];
            final String rawImageUrl =
                (data['imageUrl'] ?? '').toString().trim();

            // Normalize image path
            String imageUrl = rawImageUrl;
            if (imageUrl.startsWith('/')) imageUrl = imageUrl.substring(1);
            if (imageUrl.isNotEmpty && !imageUrl.startsWith('assets/')) {
              imageUrl = 'assets/images/$imageUrl';
            }

            final priceStr = _formatPrice(price);
            final discountStr =
                discountPrice != null ? _formatPrice(discountPrice) : null;

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SiteHeader(),
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
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.image_not_supported,
                                              size: 64,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(height: 8),
                                            Text('Image unavailable',
                                                style: TextStyle(
                                                    color: Colors.grey)),
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
                                if (discountStr != null &&
                                    _parsePrice(discountPrice) <
                                        _parsePrice(price))
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      priceStr.isNotEmpty ? priceStr : '—',
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
                                  (discountStr != null &&
                                          _parsePrice(discountPrice) <
                                              _parsePrice(price))
                                      ? discountStr
                                      : (priceStr.isNotEmpty ? priceStr : '—'),
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

                            // Personalisation options
                            const SizedBox(height: 12),
                            const Text('Per Line:'),
                            const SizedBox(height: 6),
                            _buildBoxDropdown(
                              key:
                                  const Key('product:personalisation-selector'),
                              value: _selectedPersonalisation,
                              options: _personalisationOptions,
                              onChanged: (v) =>
                                  setState(() => _selectedPersonalisation = v),
                              keyPrefix: 'personalisation',
                            ),
                            const SizedBox(height: 12),

                            // Text input fields (shown only for text options)
                            if (_getNumberOfLines() > 0) ...[
                              const SizedBox(height: 12),
                              const Text(
                                'Customization Text:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Line 1
                              TextField(
                                controller: _line1Controller,
                                decoration: const InputDecoration(
                                  labelText: 'Line 1',
                                  hintText: 'Enter text for line 1',
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF4d2963)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF4d2963),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),

                              // Line 2
                              if (_getNumberOfLines() >= 2) ...[
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _line2Controller,
                                  decoration: const InputDecoration(
                                    labelText: 'Line 2',
                                    hintText: 'Enter text for line 2',
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFF4d2963)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF4d2963),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],

                              // Line 3
                              if (_getNumberOfLines() >= 3) ...[
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _line3Controller,
                                  decoration: const InputDecoration(
                                    labelText: 'Line 3',
                                    hintText: 'Enter text for line 3',
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFF4d2963)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF4d2963),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 12),
                            ],

                            // Quantity selector
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
                                        _quantity =
                                            (parsed == null || parsed <= 0)
                                                ? 1
                                                : parsed;
                                        if (_quantity == 1 &&
                                            (parsed == null || parsed <= 0)) {
                                          _qtyController.text = '1';
                                          _qtyController.selection =
                                              TextSelection.collapsed(
                                                  offset: _qtyController
                                                      .text.length);
                                        }
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(8, 8, 36, 8),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFF4d2963)),
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
                                            left: BorderSide(
                                                color: Color(0xFF4d2963))),
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              key: const Key(
                                                  'product:qty-increase'),
                                              onTap: () {
                                                setState(() {
                                                  _quantity++;
                                                  _qtyController.text =
                                                      '$_quantity';
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
                                              key: const Key(
                                                  'product:qty-decrease'),
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

                            // Add to Cart button
                            SizedBox(
                              height: 44,
                              child: ElevatedButton(
                                key: const Key('product:add-to-cart'),
                                onPressed: () {
                                  final actualPrice = discountPrice != null
                                      ? _parsePrice(discountPrice)
                                      : _parsePrice(price);
                                  _addToCart(
                                      context, title, actualPrice, imageUrl);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4d2963),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
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
                  const SiteFooter(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
