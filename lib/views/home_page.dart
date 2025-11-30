import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/models/layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;
import 'dart:async';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _placeholderCallbackForButtons() {}

  Stream<QuerySnapshot<Map<String, dynamic>>> _productsStream() {
    try {
      return FirebaseFirestore.instance.collection('products').snapshots();
    } catch (_) {
      return Stream<QuerySnapshot<Map<String, dynamic>>>.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SiteHeader(),

            // HERO SECTION WITH AUTO-ROTATING CAROUSEL
            const HeroCarousel(),

            // PRODUCTS SECTION
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Center(
                  child: Column(
                    children: [
                      const Text(
                        'ESSENTIAL RANGE - OVER 20% OFF!',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 48),
                      Builder(
                        builder: (context) {
                          final screenWidth = MediaQuery.of(context).size.width;
                          final isWide = screenWidth > 600;
                          final double categoryWidth = screenWidth >= 1400
                              ? 360
                              : screenWidth >= 1150
                                  ? 320
                                  : screenWidth >= 900
                                      ? 300
                                      : screenWidth >= 700
                                          ? 280
                                          : 240;
                          final double productWidth = math.max(
                            categoryWidth,
                            screenWidth >= 1600
                                ? 520
                                : screenWidth >= 1400
                                    ? 480
                                    : screenWidth >= 1200
                                        ? 440
                                        : screenWidth >= 1000
                                            ? 400
                                            : screenWidth >= 800
                                                ? 360
                                                : 320,
                          );

                          const double productSpacing = 32;
                          const double categorySpacing = 24;
                          final double totalProductSpan =
                              2 * productWidth + productSpacing;

                          double squareSide =
                              (totalProductSpan - 3 * categorySpacing) / 4;
                          squareSide =
                              squareSide.clamp(140, productWidth * 0.85);

                          // Helpers to convert DB price representations into doubles
                          // and format them as UI strings like '£12.34'.
                          double? _toDouble(dynamic raw) {
                            if (raw == null) return null;
                            if (raw is double) return raw;
                            if (raw is int) return raw.toDouble();
                            if (raw is num) return raw.toDouble();
                            if (raw is String) {
                              final s = raw.trim();
                              if (s.isEmpty) return null;
                              final withoutCurrency =
                                  s.startsWith('£') ? s.substring(1) : s;
                              final cleaned = withoutCurrency.replaceAll(
                                  RegExp(r'[^0-9.]'), '');
                              return double.tryParse(cleaned);
                            }
                            try {
                              return double.parse(raw.toString());
                            } catch (_) {
                              return null;
                            }
                          }

                          String fmtPrice(dynamic raw) {
                            final d = _toDouble(raw);
                            if (d != null) return '£${d.toStringAsFixed(2)}';
                            if (raw is String) {
                              final s = raw.trim();
                              if (s.startsWith('£') && s.length > 1) return s;
                            }
                            return '£0.00';
                          }

                          // StreamBuilder that reads products and arranges them into
                          // sections: ESSENTIAL RANGE (discounted items),
                          // SIGNATURE RANGE and PORTSMOUTH collection (regular items).
                          final productSection = StreamBuilder<
                              QuerySnapshot<Map<String, dynamic>>>(
                            stream: _productsStream(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox(
                                  height: 200,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }
                              final docs = snapshot.data?.docs ?? [];
                              if (docs.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24),
                                  child: Center(
                                      child: Text('No products available')),
                                );
                              }

                              // Convert documents into ProductCard widgets
                              final allCards = <Widget>[];
                              for (final d in docs) {
                                final data = d.data();
                                final priceStr = fmtPrice(data['price']);
                                final discountStr =
                                    data['discountPrice'] == null
                                        ? null
                                        : fmtPrice(data['discountPrice']);
                                allCards.add(ProductCard(
                                  key: ValueKey('product:${d.id}'),
                                  title: data['title'] ?? '',
                                  price: priceStr,
                                  imageUrl: data['imageUrl'] ?? '',
                                  discountPrice: discountStr,
                                ));
                              }

                              final allDocs = docs;
                              final orderedDocs = <QueryDocumentSnapshot<
                                  Map<String, dynamic>>>[];
                              final orderedCards = <Widget>[];
                              final usedIds = <String>{};

                              const List<String> preferredTitles = [
                                'Limited Edition Essential Zip Hoodies',
                                'Essential T-Shirt',
                              ];

                              for (final pref in preferredTitles) {
                                final idx = allDocs.indexWhere((d) {
                                  final t = (d.data()['title'] ?? '')
                                      .toString()
                                      .toLowerCase();
                                  return t.contains(pref.toLowerCase());
                                });
                                if (idx != -1) {
                                  final d = allDocs[idx];
                                  if (!usedIds.contains(d.id)) {
                                    orderedDocs.add(d);
                                    orderedCards.add(allCards[idx]);
                                    usedIds.add(d.id);
                                  }
                                }
                              }

                              // Append the rest in original Firestore order
                              for (var i = 0; i < allDocs.length; i++) {
                                final d = allDocs[i];
                                if (usedIds.contains(d.id)) continue;
                                orderedDocs.add(d);
                                orderedCards.add(allCards[i]);
                              }

                              // Now operate on orderedDocs / orderedCards for any
                              // subsequent swaps or partitioning.
                              final docsOrdered = orderedDocs;
                              final cardsOrdered = orderedCards;

                              // Partition into discounted, regular, and Portsmouth lists
                              final discountedCards = <Widget>[];
                              final regularCards = <Widget>[];
                              final portsmouthCards = <Widget>[];
                              for (var i = 0; i < docsOrdered.length; i++) {
                                final data = docsOrdered[i].data();
                                final p = _toDouble(data['price']);
                                final dp = _toDouble(data['discountPrice']);
                                final card = cardsOrdered[i];
                                final title = (data['title'] ?? '')
                                    .toString()
                                    .toLowerCase();

                                // Check if this is a Portsmouth City product
                                if (title.contains('portsmouth city')) {
                                  portsmouthCards.add(card);
                                } else if (dp != null && p != null && dp < p) {
                                  discountedCards.add(card);
                                } else {
                                  regularCards.add(card);
                                }
                              }

                              Widget buildPairFromList(
                                  List<Widget> list, int aIdx, int bIdx,
                                  {double verticalGap = 48}) {
                                final Widget a = aIdx < list.length
                                    ? list[aIdx]
                                    : const SizedBox.shrink();
                                final Widget b = bIdx < list.length
                                    ? list[bIdx]
                                    : const SizedBox.shrink();

                                if (isWide) {
                                  return Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 32,
                                    runSpacing: 32,
                                    children: [
                                      SizedBox(width: productWidth, child: a),
                                      SizedBox(width: productWidth, child: b),
                                    ],
                                  );
                                }

                                return Column(
                                  children: [
                                    a,
                                    SizedBox(height: verticalGap),
                                    b,
                                  ],
                                );
                              }

                              final firstRow =
                                  buildPairFromList(discountedCards, 0, 1);
                              final secondRow =
                                  buildPairFromList(regularCards, 0, 1);
                              final portsmouthRow1 =
                                  buildPairFromList(portsmouthCards, 0, 1);
                              final portsmouthRow2 =
                                  buildPairFromList(portsmouthCards, 2, 3);

                              return Column(
                                children: [
                                  firstRow,
                                  const SizedBox(height: 56),
                                  const Text(
                                    'SIGNATURE RANGE',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 48),
                                  secondRow,
                                  const SizedBox(height: 56),
                                  const Text(
                                    'PORTSMOUTH CITY COLLECTION',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 48),
                                  Column(
                                    children: [
                                      portsmouthRow1,
                                      const SizedBox(height: 48),
                                      portsmouthRow2,
                                    ],
                                  ),
                                ],
                              );
                            },
                          );

                          return Column(
                            children: [
                              productSection,
                              const SizedBox(height: 80),
                              SizedBox(
                                height: 44,
                                child: ElevatedButton(
                                  key: const Key('home:view-all'),
                                  onPressed: _placeholderCallbackForButtons,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4d2963),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                    ),
                                  ),
                                  child: const Text(
                                    'VIEW ALL',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 96),
                              const Text(
                                'OUR RANGE',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Clamp width to available space to avoid horizontal overflow on narrower viewports
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final span = math.min(
                                      totalProductSpan, constraints.maxWidth);
                                  // Recompute square side based on clamped span to preserve spacing & proportions
                                  final adjustedSquareSide =
                                      ((span - 3 * categorySpacing) / 4).clamp(
                                          120.0,
                                          squareSide); // keep sensible lower bound
                                  return SizedBox(
                                    width: span,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: adjustedSquareSide,
                                          child: const RangeCategoryCard(
                                            key: ValueKey('category:Clothing'),
                                            imageAsset:
                                                'assets/images/PurpleHoodie.webp',
                                            label: 'Clothing',
                                            route: '/category/clothing',
                                          ),
                                        ),
                                        const SizedBox(width: categorySpacing),
                                        SizedBox(
                                          width: adjustedSquareSide,
                                          child: const RangeCategoryCard(
                                            key: ValueKey(
                                                'category:Merchandise'),
                                            imageAsset: 'assets/images/id.jpg',
                                            label: 'Merchandise',
                                            route: '/category/merch',
                                          ),
                                        ),
                                        const SizedBox(width: categorySpacing),
                                        SizedBox(
                                          width: adjustedSquareSide,
                                          child: const RangeCategoryCard(
                                            key:
                                                ValueKey('category:Graduation'),
                                            imageAsset:
                                                'assets/images/GradGrey.webp',
                                            label: 'Graduation',
                                            route: '/category/graduation',
                                          ),
                                        ),
                                        const SizedBox(width: categorySpacing),
                                        SizedBox(
                                          width: adjustedSquareSide,
                                          child: const RangeCategoryCard(
                                            key: ValueKey('category:SALE'),
                                            imageAsset:
                                                'assets/images/notepad.webp',
                                            label: 'SALE',
                                            route: '/category/sale',
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 72),
                              // Personalisation row: also clamp width to available space to remove overflow while keeping layout
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final span = math.min(
                                      totalProductSpan, constraints.maxWidth);
                                  const double textBlockMaxWidth = 420;
                                  const double spacer = 60;
                                  final double effectiveTextWidth =
                                      math.min(textBlockMaxWidth, span * 0.6);
                                  final double remaining =
                                      span - (effectiveTextWidth + spacer);
                                  double imageWidth = 0;
                                  double leftPad = 0;
                                  if (remaining > 0) {
                                    imageWidth = math.min(340, remaining);
                                    leftPad = remaining - imageWidth;
                                    if (leftPad < 0) leftPad = 0;
                                  }
                                  return SizedBox(
                                    width: span,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxWidth: effectiveTextWidth),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Add a Personal Touch',
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: .5,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              const Text(
                                                'First add your item of clothing to your cart then click below to add your text! One line of text contains 10 characters!',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  height: 1.5,
                                                  color: Color(0xFF666666),
                                                ),
                                              ),
                                              const SizedBox(height: 24),
                                              SizedBox(
                                                height: 44,
                                                child: ElevatedButton(
                                                  key: const Key(
                                                      'home:add-text'),
                                                  onPressed:
                                                      _placeholderCallbackForButtons,
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFF4d2963),
                                                    foregroundColor:
                                                        Colors.white,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 24),
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .zero),
                                                  ),
                                                  child: const Text(
                                                    'CLICK HERE TO ADD TEXT!',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: spacer),
                                        Row(
                                          children: [
                                            if (leftPad > 0)
                                              SizedBox(width: leftPad),
                                            if (imageWidth > 0)
                                              SizedBox(
                                                width: imageWidth,
                                                child: AspectRatio(
                                                  aspectRatio: 1,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.zero,
                                                    child: Image.asset(
                                                      'assets/images/printshack.webp',
                                                      fit: BoxFit.cover,
                                                      errorBuilder:
                                                          (_, __, ___) =>
                                                              Container(
                                                        color: Colors.grey[300],
                                                        child: const Center(
                                                          child: Icon(
                                                              Icons
                                                                  .image_not_supported,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 70),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}

/// Auto-rotating hero carousel with two slides.
class HeroCarousel extends StatefulWidget {
  const HeroCarousel({super.key});

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  late final PageController _controller;
  int _current = 0;
  static const _interval = Duration(seconds: 15);
  static const _animation = Duration(milliseconds: 600);
  Timer? _timer;
  bool _paused = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _timer = Timer.periodic(_interval, (_) {
      if (_paused) return; // do nothing while paused
      final next = (_current + 1) % 2;
      if (mounted) {
        _controller.animateToPage(
          next,
          duration: _animation,
          curve: Curves.easeInOut,
        );
      }
    });
    _controller.addListener(() {
      final page = _controller.page?.round() ?? 0;
      if (page != _current) setState(() => _current = page);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Widget _buildSlide({required String asset, required Widget child}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        Image.asset(
          asset,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => ColoredBox(
            color: Colors.grey.shade700,
            child: const Center(
              child: Icon(Icons.image_not_supported, color: Colors.white70),
            ),
          ),
        ),
        // Dark overlay
        ColoredBox(color: Colors.black.withOpacity(0.7)),
        // Foreground content
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: child,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      width: double.infinity,
      child: Stack(
        children: [
          PageView(
            key: const PageStorageKey('hero:carousel'),
            controller: _controller,
            children: [
              // Slide 1 (retain existing hero text for tests)
              _buildSlide(
                asset: 'assets/images/signiture_t-shirt.webp',
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'essential range 20% OFF',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'essential clothing for all uni students. Grab yours now and save big!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      key: const Key('hero:browse:1'),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4d2963),
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: const Text(
                        'BROWSE PRODUCTS',
                        style: TextStyle(fontSize: 14, letterSpacing: 1),
                      ),
                    ),
                  ],
                ),
              ),
              // Slide 2 (new image requested)
              _buildSlide(
                asset: 'assets/images/personalazedhoodie.webp',
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Personalised Hoodie',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Add custom text and make it yours!',
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.white,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      key: const Key('hero:browse:2'),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4d2963),
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: const Text(
                        'BROWSE PRODUCTS',
                        style: TextStyle(fontSize: 14, letterSpacing: 1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Bottom controls: left arrow, dots, right arrow, pause/play
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _NavButton(
                  key: const Key('hero:left'),
                  icon: Icons.chevron_left,
                  onTap: () {
                    final prev = (_current - 1) < 0 ? 1 : _current - 1;
                    _controller.animateToPage(
                      prev,
                      duration: _animation,
                      curve: Curves.easeInOut,
                    );
                  },
                ),
                const SizedBox(width: 12),
                Row(
                  children: List.generate(2, (i) {
                    final active = i == _current;
                    return GestureDetector(
                      onTap: () {
                        _controller.animateToPage(
                          i,
                          duration: _animation,
                          curve: Curves.easeInOut,
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: active ? 14 : 10,
                        height: active ? 14 : 10,
                        decoration: BoxDecoration(
                          color:
                              active ? const Color(0xFF4d2963) : Colors.white70,
                          shape: BoxShape.circle,
                          boxShadow: active
                              ? [
                                  const BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(0, 2))
                                ]
                              : null,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 12),
                _NavButton(
                  key: const Key('hero:right'),
                  icon: Icons.chevron_right,
                  onTap: () {
                    final next = (_current + 1) % 2;
                    _controller.animateToPage(
                      next,
                      duration: _animation,
                      curve: Curves.easeInOut,
                    );
                  },
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  key: const Key('hero:pause'),
                  onTap: () => setState(() => _paused = !_paused),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      _paused ? Icons.play_arrow : Icons.pause,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable navigation button with consistent styling
class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(28),
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: Colors.white, size: 32),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final String title;
  final String price;
  final String imageUrl;
  final String? discountPrice;

  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.discountPrice,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _hover = false;

  // Helper to parse price strings like '£14.99' to double for comparisons
  double _parsePrice(String price) {
    final cleaned = price.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  Widget _buildImage() {
    // Normalize asset path locally; do not mutate the widget.
    String src = widget.imageUrl.trim();
    if (src.startsWith('/')) src = src.substring(1);
    if (src.isNotEmpty && !src.startsWith('assets/'))
      src = 'assets/images/$src';

    if (src.isEmpty) {
      return Container(
        color: Colors.grey[300],
        child: const Center(child: Icon(Icons.image, color: Colors.grey)),
      );
    }

    return Image.asset(
      src,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: Colors.grey[300],
        child: const Center(
            child: Icon(Icons.image_not_supported, color: Colors.grey)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget baseImage = _buildImage();
    const maxHeight = 520.0;
    double _defaultAspect() {
      final s = widget.imageUrl.toLowerCase();
      // Preserve prior visuals: PortsmouthCity items used 4/3; others 3/2
      if (s.contains('portsmouthcity')) return 4 / 3;
      return 3 / 2;
    }

    final image = ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: maxHeight),
      child: AspectRatio(
        aspectRatio: _defaultAspect(),
        child: ClipRRect(borderRadius: BorderRadius.zero, child: baseImage),
      ),
    );
    final overlay = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      color: Colors.white.withOpacity(_hover ? 0.25 : 0.15),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(
          '/product',
          extra: {
            'title': widget.title,
            'price': widget.price,
            'imageUrl': widget.imageUrl,
            if (widget.discountPrice != null)
              'discountPrice': widget.discountPrice,
          },
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [image, Positioned.fill(child: overlay)]),
            const SizedBox(height: 8),
            Text(
              widget.title,
              maxLines: 2,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w700,
                decoration:
                    _hover ? TextDecoration.underline : TextDecoration.none,
              ),
            ),
            const SizedBox(height: 6),
            if (widget.discountPrice != null &&
                _parsePrice(widget.discountPrice!) < _parsePrice(widget.price))
              Row(
                children: [
                  Text(
                    widget.price,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.discountPrice!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            else
              Text(
                widget.price,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class RangeCategoryCard extends StatefulWidget {
  final String imageAsset;
  final String label;
  final String route;
  const RangeCategoryCard({
    super.key,
    required this.imageAsset,
    required this.label,
    required this.route,
  });

  @override
  State<RangeCategoryCard> createState() => _RangeCategoryCardState();
}

class _RangeCategoryCardState extends State<RangeCategoryCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine a safe square side. When constraints are unbounded
        // (can happen inside some flex/scroll combos), fall back to a
        // reasonable default so the card renders predictably on mobile.
        final double side =
            constraints.maxWidth.isFinite ? constraints.maxWidth : 180.0;

        // Normalize asset path locally; callers may pass bare filenames.
        String asset = widget.imageAsset.trim();
        if (asset.startsWith('/')) asset = asset.substring(1);
        if (asset.isNotEmpty && !asset.startsWith('assets/')) {
          asset = 'assets/images/$asset';
        }

        // Scale the label font for very small cards so text doesn't overflow.
        final double fontSize = side < 140 ? 14 : (side < 220 ? 18 : 24);

        return MouseRegion(
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => context.go(widget.route),
            child: SizedBox(
              height: side,
              child: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        asset,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.image_not_supported,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        color: Colors.black.withOpacity(_hover ? 0.55 : 0.35),
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 160),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSize,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            decoration: _hover
                                ? TextDecoration.underline
                                : TextDecoration.none,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              widget.label.toUpperCase(),
                              textAlign: TextAlign.center,
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
