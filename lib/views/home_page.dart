import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/models/layout.dart';
import 'dart:math' as math;
import 'dart:async';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _placeholderCallbackForButtons() {}

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

                          Widget buildPair(
                              {required ProductCard a,
                              required ProductCard b,
                              double verticalGap = 48}) {
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

                          final firstRow = buildPair(
                            a: const ProductCard(
                              key: ValueKey(
                                  'product:Limited Edition Essential Zip Hoodies'),
                              title: 'Limited Edition Essential Zip Hoodies',
                              originalPrice: '£20.00',
                              price: '£14.99',
                              imageUrl: 'assets/images/pink_hoodie.webp',
                            ),
                            b: const ProductCard(
                              key: ValueKey('product:Essential T-Shirt'),
                              title: 'Essential T-Shirt',
                              originalPrice: '£10.00',
                              price: '£6.99',
                              imageUrl: 'assets/images/essential_t-shirt.webp',
                            ),
                          );

                          final secondRow = buildPair(
                            a: const ProductCard(
                              key: ValueKey('product:Signiture Hoodie'),
                              title: 'Signiture Hoodie',
                              price: '£32.99',
                              imageUrl: 'assets/images/signature_hoodie.webp',
                            ),
                            b: const ProductCard(
                              key: ValueKey('product:Signiture T-Shirt'),
                              title: 'Signiture T-Shirt',
                              price: '£14.99',
                              imageUrl: 'assets/images/signiture_t-shirt.webp',
                            ),
                          );

                          final portsmouthRow1 = buildPair(
                            a: const ProductCard(
                              key: ValueKey('product:Portsmouth City Postcard'),
                              title: 'Portsmouth City Postcard',
                              price: '£1.00',
                              imageUrl:
                                  'assets/images/PortsmouthCityPostcard.webp',
                            ),
                            b: const ProductCard(
                              key: ValueKey('product:Portsmouth City Magnet'),
                              title: 'Portsmouth City Magnet',
                              price: '£4.50',
                              imageUrl:
                                  'assets/images/PortsmouthCityMagnet.jpg',
                            ),
                          );

                          final portsmouthRow2 = buildPair(
                            a: const ProductCard(
                              key: ValueKey('product:Portsmouth City Bookmark'),
                              title: 'Portsmouth City Bookmark',
                              price: '£3.00',
                              imageUrl:
                                  'assets/images/PortsmouthCityBookmark.jpg',
                            ),
                            b: const ProductCard(
                              key: ValueKey('product:Portsmouth City Notebook'),
                              title: 'Portsmouth City Notebook',
                              price: '£7.50',
                              imageUrl:
                                  'assets/images/PortsmouthCityNotebook.webp',
                            ),
                          );

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
  final String? originalPrice;

  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.originalPrice,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _hover = false;

  Widget _buildImage() {
    final placeholder = Container(
      color: Colors.grey[300],
      child: const Center(child: Icon(Icons.image, color: Colors.grey)),
    );
    final isNetwork = widget.imageUrl.startsWith('http');
    if (!isNetwork) {
      return Image.asset(
        widget.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey[300],
          child: const Center(
              child: Icon(Icons.image_not_supported, color: Colors.grey)),
        ),
      );
    } else {
      return Image.network(
        widget.imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Stack(
            fit: StackFit.expand,
            children: [
              placeholder,
              Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    value: progress.expectedTotalBytes != null
                        ? progress.cumulativeBytesLoaded /
                            progress.expectedTotalBytes!
                        : null,
                    color: const Color(0xFF4d2963),
                  ),
                ),
              ),
            ],
          );
        },
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey[300],
          child: const Center(
              child: Icon(Icons.image_not_supported, color: Colors.grey)),
        ),
      );
    }
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
            if (widget.originalPrice != null)
              'originalPrice': widget.originalPrice,
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
            if (widget.originalPrice != null)
              Row(
                children: [
                  Text(
                    widget.originalPrice!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.price,
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
        return MouseRegion(
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => context.go(widget.route),
            child: SizedBox(
              height: constraints.maxWidth,
              child: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        widget.imageAsset,
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
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            decoration: _hover
                                ? TextDecoration.underline
                                : TextDecoration.none,
                          ),
                          child: Text(widget.label.toUpperCase()),
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
