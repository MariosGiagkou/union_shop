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
                                      return Column(
                                        children: [
                                          const Row(
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
                                          const SizedBox(height: 48),
                                          const Row(
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

// PRODUCT CARD
class ProductCard extends StatelessWidget {
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

  Widget _buildImage() {
    final placeholder = Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.image, color: Colors.grey),
      ),
    );

    if (useAsset) {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => Container(
          color: Colors.grey[300],
          child: const Center(
            child: Icon(Icons.image_not_supported, color: Colors.grey),
          ),
        ),
      );
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Stack(
          fit: StackFit.expand,
          children: [
            placeholder,
            Positioned.fill(
              child: Center(
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
            ),
          ],
        );
      },
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.image_not_supported, color: Colors.grey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget baseImage = _buildImage();

    // Force rectangular (wide) shape using AspectRatio inside a fixed-height box if customHeight given.
    Widget image;
    if (customHeight != null) {
      image = SizedBox(
        height: customHeight,
        width: double.infinity,
        child: AspectRatio(
          aspectRatio: 16 / 9, // rectangular
          child: ClipRRect(
            borderRadius: BorderRadius.zero,
            child: baseImage,
          ),
        ),
      );
    } else if (aspectRatio != null) {
      image = AspectRatio(
        aspectRatio: 16 / 9, // override to rectangular
        child: ClipRRect(
          borderRadius: BorderRadius.zero,
          child: baseImage,
        ),
      );
    } else {
      image = SizedBox(
        height: 300, // was 260
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.zero,
          child: baseImage,
        ),
      );
    }

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/product'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          image,
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 6),
          if (originalPrice != null)
            Row(
              children: [
                Text(
                  originalPrice!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  price,
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
              price,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}
