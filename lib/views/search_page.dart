import 'package:flutter/material.dart';
import 'package:union_shop/models/layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatefulWidget {
  final String? initialQuery;
  final FirebaseFirestore? firestore;

  const SearchPage({super.key, this.initialQuery, this.firestore});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _submittedQuery = ''; // Track what was actually searched

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _searchController.text = widget.initialQuery!;
      _submittedQuery = widget.initialQuery!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    setState(() {
      _submittedQuery = _searchController.text.trim();
    });
  }

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _searchProducts() {
    if (_submittedQuery.isEmpty) {
      return Stream.value([]);
    }

    final query = _submittedQuery.toLowerCase();

    return (widget.firestore ?? FirebaseFirestore.instance)
        .collection('products')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.where((doc) {
        final data = doc.data();
        final title = (data['title'] ?? '').toString().toLowerCase();
        final price = (data['price'] ?? '').toString();
        final cat = (data['cat'] ?? '').toString().toLowerCase();

        // Search in title, price, and category
        return title.contains(query) ||
            price.contains(query) ||
            cat.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SiteHeader(),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 56),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Search Products',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Search input field with button
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isMobile =
                              MediaQuery.of(context).size.width < 600;

                          return Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  onSubmitted: (_) => _performSearch(),
                                  decoration: InputDecoration(
                                    hintText: 'Search for products...',
                                    hintStyle:
                                        TextStyle(fontSize: isMobile ? 14 : 16),
                                    prefixIcon: const Icon(Icons.search,
                                        color: Colors.grey),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF4d2963),
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: isMobile ? 12 : 16,
                                      vertical: isMobile ? 12 : 16,
                                    ),
                                  ),
                                  style:
                                      TextStyle(fontSize: isMobile ? 14 : 16),
                                ),
                              ),
                              SizedBox(width: isMobile ? 8 : 16),
                              SizedBox(
                                height: isMobile ? 48 : 56,
                                child: ElevatedButton(
                                  onPressed: _performSearch,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4d2963),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isMobile ? 16 : 32,
                                      vertical: isMobile ? 12 : 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'Search',
                                    style: TextStyle(
                                      fontSize: isMobile ? 14 : 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                      // Search results
                      StreamBuilder<
                          List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                        stream: _searchProducts(),
                        builder: (context, snapshot) {
                          if (_submittedQuery.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(40.0),
                                child: Text(
                                  'Enter a search term and click Search to find products',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(40.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final results = snapshot.data ?? [];

                          if (results.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: Text(
                                  'No products found for "$_submittedQuery"',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${results.length} ${results.length == 1 ? 'product' : 'products'} found',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 24),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final screenWidth =
                                      MediaQuery.of(context).size.width;
                                  int crossAxisCount = 4;
                                  if (screenWidth < 600) {
                                    crossAxisCount = 1; // Mobile: 1 column
                                  } else if (screenWidth < 900) {
                                    crossAxisCount = 2; // Tablet: 2 columns
                                  } else if (screenWidth < 1200) {
                                    crossAxisCount =
                                        3; // Small desktop: 3 columns
                                  }

                                  return GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      childAspectRatio: 0.75,
                                    ),
                                    itemCount: results.length,
                                    itemBuilder: (context, index) {
                                      final data = results[index].data();
                                      final title = data['title'] ?? 'Untitled';
                                      final price = data['price'] ?? 0;
                                      final discountPrice =
                                          data['discountPrice'];
                                      String imageUrl = (data['imageUrl'] ?? '')
                                          .toString()
                                          .trim();

                                      // Normalize image path
                                      imageUrl = imageUrl.replaceAll(
                                          RegExp(r'^/+'), '');
                                      if (imageUrl.isNotEmpty &&
                                          !imageUrl.contains('assets/images')) {
                                        imageUrl = 'assets/images/$imageUrl';
                                      }

                                      return _SearchResultCard(
                                        title: title,
                                        price: price,
                                        discountPrice: discountPrice,
                                        imageUrl: imageUrl,
                                      );
                                    },
                                  );
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
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}

// Search result card widget
class _SearchResultCard extends StatefulWidget {
  final String title;
  final dynamic price;
  final dynamic discountPrice;
  final String imageUrl;

  const _SearchResultCard({
    required this.title,
    required this.price,
    required this.discountPrice,
    required this.imageUrl,
  });

  @override
  State<_SearchResultCard> createState() => _SearchResultCardState();
}

class _SearchResultCardState extends State<_SearchResultCard> {
  bool _hover = false;

  String _formatPrice(dynamic price) {
    if (price == null) return '£0.00';
    if (price is num) return '£${price.toStringAsFixed(2)}';
    if (price is String) {
      final cleaned = price.replaceAll(RegExp(r'[^0-9.]'), '');
      final parsed = double.tryParse(cleaned);
      if (parsed != null) return '£${parsed.toStringAsFixed(2)}';
      return price.startsWith('£') ? price : '£$price';
    }
    return '£0.00';
  }

  double _parsePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is num) return price.toDouble();
    if (price is String) {
      final cleaned = price.replaceAll(RegExp(r'[^0-9.]'), '');
      return double.tryParse(cleaned) ?? 0.0;
    }
    return 0.0;
  }

  String _createProductSlug(String title) {
    return title
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'-+'), '-')
        .trim();
  }

  String _determineCategorySlug() {
    final title = widget.title.toLowerCase();
    final hasDiscount = widget.discountPrice != null &&
        _parsePrice(widget.discountPrice) < _parsePrice(widget.price);

    if (title.contains('portsmouth city')) {
      return 'portsmouth-city';
    }
    if (hasDiscount) {
      return 'sale';
    }
    return 'signature';
  }

  @override
  Widget build(BuildContext context) {
    final priceStr = _formatPrice(widget.price);
    final discountStr = widget.discountPrice != null
        ? _formatPrice(widget.discountPrice)
        : null;
    final hasDiscount = discountStr != null &&
        _parsePrice(widget.discountPrice) < _parsePrice(widget.price);

    String imageUrl = widget.imageUrl;
    if (imageUrl.isEmpty) {
      imageUrl = 'assets/images/logo1.png';
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          final categorySlug = _determineCategorySlug();
          final productSlug = _createProductSlug(widget.title);
          context.go(
            '/collections/$categorySlug/product/$productSlug',
            extra: {
              'title': widget.title,
              'price': priceStr,
              'imageUrl': widget.imageUrl,
              if (hasDiscount) 'discountPrice': discountStr,
            },
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 3 / 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.zero,
                    child: Image.asset(
                      imageUrl,
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
                ),
                Positioned.fill(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    color: Colors.white.withOpacity(_hover ? 0.25 : 0.15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w700,
                decoration:
                    _hover ? TextDecoration.underline : TextDecoration.none,
              ),
            ),
            const SizedBox(height: 6),
            if (hasDiscount)
              Row(
                children: [
                  Text(
                    priceStr,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    discountStr,
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
                priceStr,
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
