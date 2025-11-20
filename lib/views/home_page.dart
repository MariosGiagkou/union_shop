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
                            backgroundColor: Color(0xFF4d2963),
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
                          ),
                        ),
                        const SizedBox(height: 48),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount:
                              MediaQuery.of(context).size.width > 600 ? 2 : 1,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 48,
                          children: const [
                            ProductCard(
                              title: 'Limited Edition Essential Zip Hoodies',
                              originalPrice: '£20.00',
                              price: '£14.99',
                              imageUrl: 'assets/images/pink_hoodie.webp',
                              useAsset: true,
                              aspectRatio: 4 / 3,
                            ),
                            ProductCard(
                              title: 'Placeholder Product 2',
                              price: '£15.00',
                              imageUrl:
                                  'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
                            ),
                            ProductCard(
                              title: 'Placeholder Product 3',
                              price: '£20.00',
                              imageUrl:
                                  'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
                            ),
                            ProductCard(
                              title: 'Placeholder Product 4',
                              price: '£25.00',
                              imageUrl:
                                  'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
                            ),
                          ],
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
    Widget image = _buildImage();

    if (aspectRatio != null) {
      image = AspectRatio(
        aspectRatio: aspectRatio!,
        child: ClipRRect(
          borderRadius: BorderRadius.zero,
          child: image,
        ),
      );
    } else {
      image = SizedBox(
        height: customHeight ?? 260,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.zero,
          child: image,
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
