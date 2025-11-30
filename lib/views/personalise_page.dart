import 'package:flutter/material.dart';
import 'package:union_shop/models/layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalisePage extends StatefulWidget {
  const PersonalisePage({super.key});

  @override
  State<PersonalisePage> createState() => _PersonalisePageState();
}

class _PersonalisePageState extends State<PersonalisePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .doc('personalise')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Column(
              children: [
                SiteHeader(),
                Expanded(
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Column(
              children: [
                SiteHeader(),
                Expanded(
                  child: Center(
                    child: Text('Personalise product not found'),
                  ),
                ),
                SiteFooter(),
              ],
            );
          }

          final data = snapshot.data!.data()!;
          final String title = data['title'] ?? 'Personalise Product';
          final price = data['price'] ?? 0;
          final discountPrice = data['discountPrice'];
          final String rawImageUrl = (data['imageUrl'] ?? '').toString().trim();

          // Normalize image path
          String imageUrl = rawImageUrl;
          if (imageUrl.startsWith('/')) imageUrl = imageUrl.substring(1);
          if (imageUrl.isNotEmpty && !imageUrl.startsWith('assets/')) {
            imageUrl = 'assets/images/$imageUrl';
          }

          final priceStr = _formatPrice(price);
          final discountStr =
              discountPrice != null ? _formatPrice(discountPrice) : null;

          return SingleChildScrollView(
            child: Column(
              children: [
                const SiteHeader(),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          title,
                          key: const Key('product:title'),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          (discountStr != null &&
                                  _parsePrice(discountPrice) <
                                      _parsePrice(price))
                              ? discountStr
                              : priceStr,
                          key: const Key('product:price'),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4d2963),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SiteFooter(),
              ],
            ),
          );
        },
      ),
    );
  }
}
