import 'package:flutter/material.dart';
import 'package:union_shop/models/layout.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the collection items with their images and titles
    final collectionItems = [
      {'image': 'assets/images/signature_hoodie.webp', 'title': 'Signature'},
      {'image': 'assets/images/sale.webp', 'title': 'Sale'},
      {'image': 'assets/images/id.jpg', 'title': 'Merchandise'},
      {
        'image': 'assets/images/personalazedhoodie.webp',
        'title': 'Personalisation'
      },
      {
        'image': 'assets/images/PortsmouthCityBookmark.jpg',
        'title': 'Portsmouth City'
      },
      {'image': 'assets/images/RainbowHoodie.webp', 'title': 'Pride'},
      {'image': 'assets/images/Halloween_tote_bag.jpg', 'title': 'Halloween'},
      {'image': 'assets/images/GradGrey.webp', 'title': 'Graduation'},
    ];

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
                          return _HoverImageTile(
                            src: item['image']!,
                            label: item['title']!,
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
