import 'package:flutter/material.dart';
import 'package:union_shop/models/layout.dart';
import 'dart:math' as math;

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

            // HERO SECTION
            SizedBox(
              height: 420, // enlarged hero
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/signiture_t-shirt.webp'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Placeholder Hero Title',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'This is placeholder text for the hero section.',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: _placeholderCallbackForButtons,
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
                  ),
                ],
              ),
            ),

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

                          final firstRow = isWide
                              ? Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 32,
                                  runSpacing: 32,
                                  children: [
                                    SizedBox(
                                      width: productWidth,
                                      child: const ProductCard(
                                        title:
                                            'Limited Edition Essential Zip Hoodies',
                                        originalPrice: '£20.00',
                                        price: '£14.99',
                                        imageUrl:
                                            'assets/images/pink_hoodie.webp',
                                        useAsset: true,
                                        aspectRatio: 3 / 2,
                                      ),
                                    ),
                                    SizedBox(
                                      width: productWidth,
                                      child: const ProductCard(
                                        title: 'Essential T-Shirt',
                                        originalPrice: '£10.00',
                                        price: '£6.99',
                                        imageUrl:
                                            'assets/images/essential_t-shirt.webp',
                                        useAsset: true,
                                        aspectRatio: 3 / 2,
                                      ),
                                    ),
                                  ],
                                )
                              : const Column(
                                  children: [
                                    ProductCard(
                                      title:
                                          'Limited Edition Essential Zip Hoodies',
                                      originalPrice: '£20.00',
                                      price: '£14.99',
                                      imageUrl:
                                          'assets/images/pink_hoodie.webp',
                                      useAsset: true,
                                      aspectRatio: 3 / 2,
                                    ),
                                    SizedBox(height: 48),
                                    ProductCard(
                                      title: 'Essential T-Shirt',
                                      originalPrice: '£10.00',
                                      price: '£6.99',
                                      imageUrl:
                                          'assets/images/essential_t-shirt.webp',
                                      useAsset: true,
                                      aspectRatio: 3 / 2,
                                    ),
                                  ],
                                );

                          final secondRow = isWide
                              ? Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 32,
                                  runSpacing: 32,
                                  children: [
                                    SizedBox(
                                      width: productWidth,
                                      child: const ProductCard(
                                        title: 'Signiture Hoodie',
                                        price: '£32.99',
                                        imageUrl:
                                            'assets/images/signature_hoodie.webp',
                                        useAsset: true,
                                        aspectRatio: 3 / 2,
                                      ),
                                    ),
                                    SizedBox(
                                      width: productWidth,
                                      child: const ProductCard(
                                        title: 'Signiture T-Shirt',
                                        price: '£14.99',
                                        imageUrl:
                                            'assets/images/signiture_t-shirt.webp',
                                        useAsset: true,
                                        aspectRatio: 3 / 2,
                                      ),
                                    ),
                                  ],
                                )
                              : const Column(
                                  children: [
                                    ProductCard(
                                      title: 'Signiture Hoodie',
                                      price: '£32.99',
                                      imageUrl:
                                          'assets/images/signature_hoodie.webp',
                                      useAsset: true,
                                      aspectRatio: 3 / 2,
                                    ),
                                    SizedBox(height: 48),
                                    ProductCard(
                                      title: 'Signiture T-Shirt',
                                      price: '£14.99',
                                      imageUrl:
                                          'assets/images/signiture_t-shirt.webp',
                                      useAsset: true,
                                      aspectRatio: 3 / 2,
                                    ),
                                  ],
                                );

                          final portsmouthRow1 = isWide
                              ? Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 32,
                                  runSpacing: 32,
                                  children: [
                                    SizedBox(
                                      width: productWidth,
                                      child: const ProductCard(
                                        title: 'Portsmouth City Postcard',
                                        price: '£1.00',
                                        imageUrl:
                                            'assets/images/PortsmouthCityPostcard.webp',
                                        useAsset: true,
                                        aspectRatio: 4 / 3,
                                      ),
                                    ),
                                    SizedBox(
                                      width: productWidth,
                                      child: const ProductCard(
                                        title: 'Portsmouth City Magnet',
                                        price: '£4.50',
                                        imageUrl:
                                            'assets/images/PortsmouthCityMagnet.jpg',
                                        useAsset: true,
                                        aspectRatio: 4 / 3,
                                      ),
                                    ),
                                  ],
                                )
                              : const Column(
                                  children: [
                                    ProductCard(
                                      title: 'Portsmouth City Postcard',
                                      price: '£1.00',
                                      imageUrl:
                                          'assets/images/PortsmouthCityPostcard.webp',
                                      useAsset: true,
                                      aspectRatio: 4 / 3,
                                    ),
                                    SizedBox(height: 48),
                                    ProductCard(
                                      title: 'Portsmouth City Magnet',
                                      price: '£4.50',
                                      imageUrl:
                                          'assets/images/PortsmouthCityMagnet.jpg',
                                      useAsset: true,
                                      aspectRatio: 4 / 3,
                                    ),
                                  ],
                                );

                          final portsmouthRow2 = isWide
                              ? Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 32,
                                  runSpacing: 32,
                                  children: [
                                    SizedBox(
                                      width: productWidth,
                                      child: const ProductCard(
                                        title: 'Portsmouth City Bookmark',
                                        price: '£3.00',
                                        imageUrl:
                                            'assets/images/PortsmouthCityBookmark.jpg',
                                        useAsset: true,
                                        aspectRatio: 4 / 3,
                                      ),
                                    ),
                                    SizedBox(
                                      width: productWidth,
                                      child: const ProductCard(
                                        title: 'Portsmouth City Notebook',
                                        price: '£7.50',
                                        imageUrl:
                                            'assets/images/PortsmouthCityNotebook.webp',
                                        useAsset: true,
                                        aspectRatio: 4 / 3,
                                      ),
                                    ),
                                  ],
                                )
                              : const Column(
                                  children: [
                                    ProductCard(
                                      title: 'Portsmouth City Bookmark',
                                      price: '£3.00',
                                      imageUrl:
                                          'assets/images/PortsmouthCityBookmark.jpg',
                                      useAsset: true,
                                      aspectRatio: 4 / 3,
                                    ),
                                    SizedBox(height: 48),
                                    ProductCard(
                                      title: 'Portsmouth City Notebook',
                                      price: '£7.50',
                                      imageUrl:
                                          'assets/images/PortsmouthCityNotebook.webp',
                                      useAsset: true,
                                      aspectRatio: 4 / 3,
                                    ),
                                  ],
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
                                            imageAsset:
                                                'assets/images/PurpleHoodie.webp',
                                            label: 'Clothing',
                                            route: '/category/clothing',
                                          ),
                                        ),
                                        SizedBox(width: categorySpacing),
                                        SizedBox(
                                          width: adjustedSquareSide,
                                          child: const RangeCategoryCard(
                                            imageAsset: 'assets/images/id.jpg',
                                            label: 'Merchandise',
                                            route: '/category/merch',
                                          ),
                                        ),
                                        SizedBox(width: categorySpacing),
                                        SizedBox(
                                          width: adjustedSquareSide,
                                          child: const RangeCategoryCard(
                                            imageAsset:
                                                'assets/images/GradGrey.webp',
                                            label: 'Graduation',
                                            route: '/category/graduation',
                                          ),
                                        ),
                                        SizedBox(width: categorySpacing),
                                        SizedBox(
                                          width: adjustedSquareSide,
                                          child: const RangeCategoryCard(
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

class ProductCard extends StatefulWidget {
  final String title;
  final String price;
  final String imageUrl;
  final String? originalPrice;
  final bool useAsset;
  final double? aspectRatio;
  final double? customHeight;

  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.originalPrice,
    this.useAsset = false,
    this.aspectRatio,
    this.customHeight,
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
    if (widget.useAsset) {
      return Image.asset(
        widget.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey[300],
          child: const Center(
              child: Icon(Icons.image_not_supported, color: Colors.grey)),
        ),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    Widget baseImage = _buildImage();
    Widget image;
    const maxHeight = 520.0;
    if (widget.aspectRatio != null) {
      image = ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: maxHeight),
        child: AspectRatio(
          aspectRatio: widget.aspectRatio!,
          child: ClipRRect(borderRadius: BorderRadius.zero, child: baseImage),
        ),
      );
    } else if (widget.customHeight != null) {
      image = SizedBox(
        height: widget.customHeight! <= maxHeight
            ? widget.customHeight!
            : maxHeight,
        width: double.infinity,
        child: ClipRRect(borderRadius: BorderRadius.zero, child: baseImage),
      );
    } else {
      image = SizedBox(
        height: maxHeight,
        width: double.infinity,
        child: ClipRRect(borderRadius: BorderRadius.zero, child: baseImage),
      );
    }
    final overlay = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      color: Colors.white.withOpacity(_hover ? 0.25 : 0.15),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/product'),
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
            onTap: () => Navigator.pushNamed(context, widget.route),
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
