import 'package:flutter/material.dart';
import 'package:union_shop/models/layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
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

                  // Centered, constrained grid: up to 15 square images (3 cols)
                  Center(
                    child: ConstrainedBox(
                      // Allow more room so larger square tiles can fit comfortably
                      // The Grid will size three columns across this width.
                      constraints: const BoxConstraints(maxWidth: 1100),
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('products')
                            .snapshots(),
                        builder: (context, snap) {
                          if (snap.connectionState == ConnectionState.waiting) {
                            return const SizedBox(
                              height: 120,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final docs = snap.data?.docs ?? [];
                          if (docs.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(child: Text('No images')),
                            );
                          }

                          final items =
                              docs.length <= 15 ? docs : docs.sublist(0, 15);

                          // Fixed labels for the first 8 tiles as requested by the user.
                          const List<String> fixedLabels = [
                            'Clothing',
                            'SALES',
                            'Essentials Range',
                            'Graduation',
                            'Personalisation',
                            'Portsmouth Collection',
                            'Pride Collection',
                            'Limited Edition - Zip Up Collection',
                          ];

                          return GridView.count(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            // When GridView is inside a scrollable (SingleChildScrollView)
                            // it must shrink to its content and disable its own scrolling.
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            // Let the outer SingleChildScrollView handle scrolling
                            children:
                                items.asMap().entries.map<Widget>((entry) {
                              final idx = entry.key;
                              final d = entry.value;
                              final data = d.data();
                              String src =
                                  (data['imageUrl'] ?? '').toString().trim();
                              // Remove any leading slashes
                              src = src.replaceAll(RegExp(r'^/+'), '');
                              // Avoid double-prefixing if clients already stored a full asset path
                              if (src.isNotEmpty &&
                                  !src.contains('assets/images')) {
                                src = 'assets/images/$src';
                              }

                              if (src.isEmpty) {
                                // Keep placeholder tile consistent with hover look
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child:
                                        Icon(Icons.image, color: Colors.grey),
                                  ),
                                );
                              }

                              // Choose fixed label for early tiles, otherwise fall back to document title
                              final docTitle = (data['title'] ?? '').toString();
                              final label = idx < fixedLabels.length &&
                                      fixedLabels[idx].isNotEmpty
                                  ? fixedLabels[idx]
                                  : (docTitle.isNotEmpty ? docTitle : null);

                              return _HoverImageTile(
                                src: src,
                                label: label,
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Footer sits after the content — will only be visible when
            // the user scrolls to the bottom of the page.
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
