import 'package:flutter/material.dart';
import 'package:union_shop/models/layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.trim();
    });
  }

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _searchProducts() {
    if (_searchQuery.isEmpty) {
      return Stream.value([]);
    }

    final query = _searchQuery.toLowerCase();

    return FirebaseFirestore.instance
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
                      // Search input field
                      TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Search for products...',
                          hintStyle: const TextStyle(fontSize: 16),
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: Colors.grey),
                                  onPressed: () {
                                    _searchController.clear();
                                    _onSearchChanged('');
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF4d2963),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 32),
                      // Search results will go here
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Text(
                            'Enter a search term to find products',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
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
