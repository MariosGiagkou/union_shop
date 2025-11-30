import 'package:flutter/material.dart';
import 'package:union_shop/models/layout.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:union_shop/views/personalise_page.dart';

class CollectionsPage extends StatefulWidget {
  final String? category;

  const CollectionsPage({super.key, this.category});

  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  // Filter and sort state
  String _filterBy = 'All products';
  String _sortBy = 'Featured';

  // Define all collection categories
  static final Map<String, Map<String, String>> allCollections = {
    'signature': {
      'image': 'assets/images/signature_hoodie.webp',
      'title': 'Signature',
      'slug': 'signature'
    },
    'sale': {
      'image': 'assets/images/sale.webp',
      'title': 'Sale',
      'slug': 'sale'
    },
    'merchandise': {
      'image': 'assets/images/id.jpg',
      'title': 'Merchandise',
      'slug': 'merchandise'
    },
    'personalisation': {
      'image': 'assets/images/personalazedhoodie.webp',
      'title': 'Personalisation',
      'slug': 'personalisation'
    },
    'portsmouth-city': {
      'image': 'assets/images/PortsmouthCityBookmark.jpg',
      'title': 'Portsmouth City',
      'slug': 'portsmouth-city'
    },
    'pride': {
      'image': 'assets/images/RainbowHoodie.webp',
      'title': 'Pride',
      'slug': 'pride'
    },
    'halloween': {
      'image': 'assets/images/Halloween_tote_bag.jpg',
      'title': 'Halloween',
      'slug': 'halloween'
    },
    'graduation': {
      'image': 'assets/images/GradGrey.webp',
      'title': 'Graduation',
      'slug': 'graduation'
    },
  };

  // Helper method to apply category filter based on cat field
  List<DocumentSnapshot<Map<String, dynamic>>> _applyFilter(
      List<DocumentSnapshot<Map<String, dynamic>>> docs) {
    if (_filterBy == 'All products') {
      return docs;
    } else if (_filterBy == 'Merchandise') {
      return docs.where((doc) {
        final cat = (doc.data()?['cat'] ?? '').toString().toLowerCase();
        return cat == 'prod';
      }).toList();
    } else if (_filterBy == 'Clothing') {
      return docs.where((doc) {
        final cat = (doc.data()?['cat'] ?? '').toString().toLowerCase();
        return cat == 'cloth';
      }).toList();
    }
    return docs;
  }

  // Helper method to apply sorting
  List<DocumentSnapshot<Map<String, dynamic>>> _applySort(
      List<DocumentSnapshot<Map<String, dynamic>>> docs) {
    final sortedDocs = List<DocumentSnapshot<Map<String, dynamic>>>.from(docs);

    if (_sortBy == 'Alphabetically: A-Z') {
      sortedDocs.sort((a, b) {
        final titleA = (a.data()?['title'] ?? '').toString().toLowerCase();
        final titleB = (b.data()?['title'] ?? '').toString().toLowerCase();
        return titleA.compareTo(titleB);
      });
    } else if (_sortBy == 'Alphabetically: Z-A') {
      sortedDocs.sort((a, b) {
        final titleA = (a.data()?['title'] ?? '').toString().toLowerCase();
        final titleB = (b.data()?['title'] ?? '').toString().toLowerCase();
        return titleB.compareTo(titleA);
      });
    } else if (_sortBy == 'Price: Low to High') {
      sortedDocs.sort((a, b) {
        final priceA = _getProductPrice(a.data());
        final priceB = _getProductPrice(b.data());
        return priceA.compareTo(priceB);
      });
    } else if (_sortBy == 'Price: High to Low') {
      sortedDocs.sort((a, b) {
        final priceA = _getProductPrice(a.data());
        final priceB = _getProductPrice(b.data());
        return priceB.compareTo(priceA);
      });
    }
    // 'Featured' - no sorting, keep original order
    return sortedDocs;
  }

  // Helper to get the effective price (use discountPrice if available)
  double _getProductPrice(Map<String, dynamic>? data) {
    if (data == null) return 0.0;
    final discountPrice = data['discountPrice'];
    if (discountPrice != null) {
      if (discountPrice is num) return discountPrice.toDouble();
      return double.tryParse(discountPrice.toString()) ?? 0.0;
    }
    final price = data['price'] ?? 0;
    if (price is num) return price.toDouble();
    return double.tryParse(price.toString()) ?? 0.0;
  }

  // Build filter and sort banner
  Widget _buildFilterSortBanner(int productCount) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Filter dropdown
          Row(
            children: [
              const Text(
                'Filter by',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButton<String>(
                  value: _filterBy,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                      value: 'All products',
                      child: Text('All products'),
                    ),
                    DropdownMenuItem(
                      value: 'Merchandise',
                      child: Text('Merchandise'),
                    ),
                    DropdownMenuItem(
                      value: 'Clothing',
                      child: Text('Clothing'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _filterBy = value);
                    }
                  },
                ),
              ),
            ],
          ),

          // Center: Product count
          Text(
            '$productCount ${productCount == 1 ? 'product' : 'products'}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),

          // Right side: Sort dropdown
          Row(
            children: [
              const Text(
                'Sort by',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButton<String>(
                  value: _sortBy,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                      value: 'Featured',
                      child: Text('Featured'),
                    ),
                    DropdownMenuItem(
                      value: 'Alphabetically: A-Z',
                      child: Text('Alphabetically: A-Z'),
                    ),
                    DropdownMenuItem(
                      value: 'Alphabetically: Z-A',
                      child: Text('Alphabetically: Z-A'),
                    ),
                    DropdownMenuItem(
                      value: 'Price: Low to High',
                      child: Text('Price: Low to High'),
                    ),
                    DropdownMenuItem(
                      value: 'Price: High to Low',
                      child: Text('Price: High to Low'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _sortBy = value);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If category is specified, show that category's products
    // Otherwise show the collection grid overview
    if (widget.category != null &&
        allCollections.containsKey(widget.category)) {
      return _buildCategoryPage(context, widget.category!);
    } else {
      return _buildCollectionsOverview(context);
    }
  }

  // Build the main collections overview grid
  Widget _buildCollectionsOverview(BuildContext context) {
    final collectionItems = allCollections.values.toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SiteHeader(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Collections',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Centered, constrained grid: 8 square images (3 cols)
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100),
                      child: GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: collectionItems.map<Widget>((item) {
                          return GestureDetector(
                            onTap: () {
                              context.go('/collections/${item['slug']}');
                            },
                            child: _HoverImageTile(
                              src: item['image']!,
                              label: item['title']!,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }

  // Build a specific category page
  Widget _buildCategoryPage(BuildContext context, String categorySlug) {
    // Special handling for personalisation - redirect to PersonalisePage
    if (categorySlug == 'personalisation') {
      // Navigate to the personalise route
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/personalise');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final categoryData = allCollections[categorySlug]!;
    ;
    final categoryTitle = categoryData['title']!;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SiteHeader(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button and title
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => context.go('/collections'),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        categoryTitle,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Products grid from Firebase (for signature, sale, merchandise, portsmouth-city, pride, halloween, and graduation collections)
                  if (categorySlug == 'signature' ||
                      categorySlug == 'sale' ||
                      categorySlug == 'merchandise' ||
                      categorySlug == 'portsmouth-city' ||
                      categorySlug == 'pride' ||
                      categorySlug == 'halloween' ||
                      categorySlug == 'graduation')
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('products')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: Text('No products found'),
                            ),
                          );
                        }

                        // Filter products based on category
                        final allDocs = snapshot.data!.docs;
                        final filteredDocs = allDocs.where((doc) {
                          final data = doc.data();

                          // For sale category: show items with discountPrice
                          if (categorySlug == 'sale') {
                            return data.containsKey('discountPrice') &&
                                data['discountPrice'] != null;
                          }

                          // For merchandise category: show items with slug containing 'merch'
                          if (categorySlug == 'merchandise') {
                            final slug =
                                (data['slug'] ?? '').toString().toLowerCase();
                            return slug.contains('merch');
                          }

                          // For portsmouth-city category: show items with title containing 'Portsmouth City'
                          if (categorySlug == 'portsmouth-city') {
                            final title =
                                (data['title'] ?? '').toString().toLowerCase();
                            return title.contains('portsmouth city');
                          }

                          // For halloween category: show items with title containing 'Halloween'
                          if (categorySlug == 'halloween') {
                            final title =
                                (data['title'] ?? '').toString().toLowerCase();
                            return title.contains('halloween');
                          }

                          // For graduation category: show items with title containing 'grad'
                          if (categorySlug == 'graduation') {
                            final title =
                                (data['title'] ?? '').toString().toLowerCase();
                            return title.contains('grad');
                          }

                          // For other categories: match by slug
                          final slug =
                              (data['slug'] ?? '').toString().toLowerCase();
                          return slug == categorySlug.toLowerCase();
                        }).toList();

                        // Apply additional filter and sort
                        final processedDocs =
                            _applySort(_applyFilter(filteredDocs));

                        if (processedDocs.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Text(
                                  'No ${categoryTitle.toLowerCase()} products found'),
                            ),
                          );
                        }

                        return Column(
                          children: [
                            // Filter/Sort Banner
                            _buildFilterSortBanner(processedDocs.length),
                            const SizedBox(height: 16),

                            // Products Grid
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.75,
                              ),
                              itemCount: processedDocs.length,
                              itemBuilder: (context, index) {
                                final data = processedDocs[index].data();
                                final title = data?['title'] ?? 'Untitled';
                                final price = data?['price'] ?? 0;
                                final discountPrice = data?['discountPrice'];
                                String imageUrl =
                                    (data?['imageUrl'] ?? '').toString().trim();

                                // Normalize image path
                                imageUrl =
                                    imageUrl.replaceAll(RegExp(r'^/+'), '');
                                if (imageUrl.isNotEmpty &&
                                    !imageUrl.contains('assets/images')) {
                                  imageUrl = 'assets/images/$imageUrl';
                                }

                                return _ProductCard(
                                  title: title,
                                  price: price,
                                  discountPrice: discountPrice,
                                  imageUrl: imageUrl,
                                  categorySlug: categorySlug,
                                );
                              },
                            ),
                          ],
                        );
                      },
                    )
                  else
                    // Category content placeholder for other collections
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Text(
                          'Category page content goes here',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final String title;
  final dynamic price;
  final dynamic discountPrice;
  final String imageUrl;
  final String categorySlug;

  const _ProductCard({
    required this.title,
    required this.price,
    required this.discountPrice,
    required this.imageUrl,
    required this.categorySlug,
  });

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _hover = false;

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

  String _createProductSlug(String title) {
    // Convert title to URL-friendly slug
    return title
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '') // Remove special characters
        .replaceAll(RegExp(r'\s+'), '_') // Replace spaces with underscores
        .replaceAll(
            RegExp(r'-+'), '-') // Replace multiple dashes with single dash
        .trim();
  }

  Widget _buildImage() {
    String src = widget.imageUrl.trim();
    // Normalize path
    src = src.replaceAll(RegExp(r'^/+'), '');
    if (src.isNotEmpty && !src.contains('assets/images')) {
      src = 'assets/images/$src';
    }

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
          child: Icon(Icons.image_not_supported, color: Colors.grey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final priceStr = _formatPrice(widget.price);
    final discountStr = widget.discountPrice != null
        ? _formatPrice(widget.discountPrice)
        : null;
    final hasDiscount = discountStr != null &&
        discountStr.isNotEmpty &&
        _parsePrice(widget.discountPrice) < _parsePrice(widget.price);

    final image = AspectRatio(
      aspectRatio: 3 / 2,
      child: ClipRRect(
        borderRadius: BorderRadius.zero,
        child: _buildImage(),
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
        onTap: () {
          final productSlug = _createProductSlug(widget.title);
          context.go(
            '/collections/${widget.categorySlug}/product/$productSlug',
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
                image,
                Positioned.fill(child: overlay),
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

// Small hover-capable tile: darkens on hover and shows an optional centered label.
class _HoverImageTile extends StatefulWidget {
  final String src;
  final String? label;

  const _HoverImageTile({required this.src, this.label});

  @override
  State<_HoverImageTile> createState() => _HoverImageTileState();
}

class _HoverImageTileState extends State<_HoverImageTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: ClipRRect(
        borderRadius: BorderRadius.zero,
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                widget.src,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[300],
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.image_not_supported,
                            color: Colors.grey),
                        if (widget.label != null &&
                            widget.label!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            widget.label!,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),

              // Baseline transparent overlay; darken on hover so images remain visible.
              Positioned.fill(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  color: Colors.black.withOpacity(_hover ? 0.35 : 0.0),
                ),
              ),

              // Centered label (no underline on hover)
              if (widget.label != null && widget.label!.isNotEmpty)
                Positioned.fill(
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 160),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        decoration: TextDecoration.none,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          widget.label!.toUpperCase(),
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
    );
  }
}
