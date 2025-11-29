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

                          return GridView.count(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1,
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            children: items.map((d) {
                              final data = d.data();
                              String src =
                                  (data['imageUrl'] ?? '').toString().trim();
                              if (src.startsWith('/')) src = src.substring(1);
                              if (src.isNotEmpty &&
                                  !src.startsWith('assets/')) {
                                src = 'assets/images/$src';
                              }
                              if (src.isEmpty) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child:
                                        Icon(Icons.image, color: Colors.grey),
                                  ),
                                );
                              }

                              return ClipRRect(
                                borderRadius: BorderRadius.zero,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.asset(
                                    src,
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
