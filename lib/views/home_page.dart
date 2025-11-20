import 'package:flutter/material.dart';
import 'package:union_shop/models/layout.dart';

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
              height: 400,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    right: 24,
                    top: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                ],
              ),
            ),

            // PRODUCTS SECTION
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Column(
                      children: [
                        const Text(
                          'ESSENTIAL RANGE - OVER 20% OFF!',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 48),

                        // REPLACED LayoutBuilder with simple MediaQuery width check
                        Builder(
                          builder: (context) {
                            final isWide =
                                MediaQuery.of(context).size.width > 600;

                            final firstRow = isWide
                                ? const Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ProductCard(
                                          title:
                                              'Limited Edition Essential Zip Hoodies',
                                          originalPrice: '£20.00',
                                          price: '£14.99',
                                          imageUrl:
                                              'assets/images/pink_hoodie.webp',
                                          useAsset: true,
                                          customHeight: 400, // was 340
                                        ),
                                      ),
                                      SizedBox(width: 24),
                                      Expanded(
                                        child: ProductCard(
                                          title: 'Essential T-Shirt',
                                          originalPrice: '£10.00',
                                          price: '£6.99',
                                          imageUrl:
                                              'assets/images/essential_t-shirt.webp',
                                          useAsset: true,
                                          customHeight: 400, // was 340
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
                                        customHeight: 400, // was 340
                                      ),
                                      SizedBox(height: 48),
                                      ProductCard(
                                        title: 'Essential T-Shirt',
                                        originalPrice: '£10.00',
                                        price: '£6.99',
                                        imageUrl:
                                            'assets/images/essential_t-shirt.webp',
                                        useAsset: true,
                                        customHeight: 400, // was 340
                                      ),
                                    ],
                                  );

                            final secondRow = isWide
                                ? const Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ProductCard(
                                          title: 'Signiture Hoodie',
                                          price: '£32.99',
                                          imageUrl:
                                              'assets/images/signature_hoodie.webp',
                                          useAsset: true,
                                          customHeight: 360,
                                        ),
                                      ),
                                      SizedBox(width: 24),
                                      Expanded(
                                        child: ProductCard(
                                          title: 'Signiture T-Shirt', // changed
                                          price: '£14.99', // changed
                                          imageUrl:
                                              'assets/images/signiture_t-shirt.webp', // changed
                                          useAsset: true, // added
                                          customHeight: 360,
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
                                        customHeight: 360,
                                      ),
                                      SizedBox(height: 48),
                                      ProductCard(
                                        title: 'Signiture T-Shirt', // changed
                                        price: '£14.99', // changed
                                        imageUrl:
                                            'assets/images/signiture_t-shirt.webp', // changed
                                        useAsset: true, // added
                                        customHeight: 360,
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
                                    fontSize: 20,
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
                                    fontSize: 20,
                                    color: Colors.black,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 48),
                                // NEW: Portsmouth City products (responsive)
                                Builder(
                                  builder: (context) {
                                    final wide =
                                        MediaQuery.of(context).size.width > 600;
                                    if (wide) {
                                      return const Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: ProductCard(
                                                  title:
                                                      'Portsmouth City Postcard',
                                                  price: '£1.00',
                                                  imageUrl:
                                                      'assets/images/PortsmouthCityPostcard.webp',
                                                  useAsset: true,
                                                  customHeight: 300,
                                                ),
                                              ),
                                              SizedBox(width: 24),
                                              Expanded(
                                                child: ProductCard(
                                                  title:
                                                      'Portsmouth City Magnet',
                                                  price: '£4.50',
                                                  imageUrl:
                                                      'assets/images/PortsmouthCityMagnet.jpg',
                                                  useAsset: true,
                                                  customHeight: 300,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 48),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: ProductCard(
                                                  title:
                                                      'Portsmouth City Bookmark',
                                                  price: '£3.00',
                                                  imageUrl:
                                                      'assets/images/PortsmouthCityBookmark.jpg',
                                                  useAsset: true,
                                                  customHeight: 300,
                                                ),
                                              ),
                                              SizedBox(width: 24),
                                              Expanded(
                                                child: ProductCard(
                                                  title:
                                                      'Portsmouth City Notebook',
                                                  price: '£7.50',
                                                  imageUrl:
                                                      'assets/images/PortsmouthCityNotebook.webp',
                                                  useAsset: true,
                                                  customHeight: 300,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    } else {
                                      return const Column(
                                        children: [
                                          ProductCard(
                                            title: 'Portsmouth City Postcard',
                                            price: '£1.00',
                                            imageUrl:
                                                'assets/images/PortsmouthCityPostcard.webp',
                                            useAsset: true,
                                            customHeight: 300,
                                          ),
                                          SizedBox(height: 48),
                                          ProductCard(
                                            title: 'Portsmouth City Magnet',
                                            price: '£4.50',
                                            imageUrl:
                                                'assets/images/PortsmouthCityMagnet.jpg',
                                            useAsset: true,
                                            customHeight: 300,
                                          ),
                                          SizedBox(height: 48),
                                          ProductCard(
                                            title: 'Portsmouth City Bookmark',
                                            price: '£3.00',
                                            imageUrl:
                                                'assets/images/PortsmouthCityBookmark.jpg',
                                            useAsset: true,
                                            customHeight: 300,
                                          ),
                                          SizedBox(height: 48),
                                          ProductCard(
                                            title: 'Portsmouth City Notebook',
                                            price: '£7.50',
                                            imageUrl:
                                                'assets/images/PortsmouthCityNotebook.webp',
                                            useAsset: true,
                                            customHeight: 300,
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: 80), // was 40
                                SizedBox(
                                  height: 44,
                                  child: ElevatedButton(
                                    onPressed: _placeholderCallbackForButtons,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF4d2963),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24, // was 32
                                        vertical: 12, // added to thin button
                                      ),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero,
                                      ),
                                    ),
                                    child: const Text(
                                      'VIEW ALL',
                                      style: TextStyle(
                                        fontSize: 13, // was 14
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.8, // was 1.1
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 96), // was 48
                                const Text(
                                  'OUR RANGE',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 32),
                                const Row(
                                  children: [
                                    Expanded(
                                      child: RangeCategoryCard(
                                        imageAsset:
                                            'assets/images/PurpleHoodie.webp',
                                        label: 'Clothing',
                                        route: '/category/clothing',
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: RangeCategoryCard(
                                        imageAsset: 'assets/images/id.jpg',
                                        label: 'Merchandise', // fixed typo
                                        route: '/category/merch',
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: RangeCategoryCard(
                                        imageAsset:
                                            'assets/images/GradGrey.webp',
                                        label: 'Graduation',
                                        route: '/category/graduation',
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: RangeCategoryCard(
                                        imageAsset:
                                            'assets/images/notepad.webp',
                                        label: 'SALE',
                                        route: '/category/sale',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 70),
                                // NEW: Additional products or content for "OUR RANGE" can be added here
                              ],
                            );
                          },
                        ),
                      ],
                    ),
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

// PRODUCT CARD (converted to StatefulWidget for hover effects)
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
    if (widget.customHeight != null) {
      image = SizedBox(
        height: widget.customHeight,
        width: double.infinity,
        child: ClipRRect(borderRadius: BorderRadius.zero, child: baseImage),
      );
    } else if (widget.aspectRatio != null) {
      image = AspectRatio(
        aspectRatio: widget.aspectRatio!,
        child: ClipRRect(borderRadius: BorderRadius.zero, child: baseImage),
      );
    } else {
      image = SizedBox(
        height: 300,
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
            Stack(
              children: [
                image,
                Positioned.fill(child: overlay),
              ],
            ),
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

// NEW: RangeCategoryCard widget for category sections
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
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, widget.route),
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
                      child:
                          Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  color: Colors.black
                      .withOpacity(_hover ? 0.55 : 0.35), // reverted from grey
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 160),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
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
    );
  }
}
