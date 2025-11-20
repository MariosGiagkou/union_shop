import 'package:flutter/material.dart';

class SiteHeader extends StatelessWidget {
  const SiteHeader({super.key});

  void _placeholderCallbackForButtons() {
    // placeholder for buttons that don't do anything yet
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140, // increased from 100
      color: Colors.white,
      child: Column(
        children: [
          // Top banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12), // was 11
            color: const Color(0xFF4d2963),
            child: const Text(
              'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF! COME GRAB YOURS WHILE STOCK LASTS!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          // Main header
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16), // was 10
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (route) => false);
                    },
                    child: Image.network(
                      'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
                      height: 28, // was 18
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          width: 28, // was 18
                          height: 28, // was 18
                          child: const Center(
                            child: Icon(Icons.image_not_supported,
                                color: Colors.grey),
                          ),
                        );
                      },
                    ),
                  ),
                  const Spacer(),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.search,
                            size: 24, // was 18
                            color: Colors.grey,
                          ),
                          padding: const EdgeInsets.all(10), // was 8
                          constraints: const BoxConstraints(
                            minWidth: 40, // was 32
                            minHeight: 40, // was 32
                          ),
                          onPressed: _placeholderCallbackForButtons,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.person_outline,
                            size: 24, // was 18
                            color: Colors.grey,
                          ),
                          padding: const EdgeInsets.all(10), // was 8
                          constraints: const BoxConstraints(
                            minWidth: 40, // was 32
                            minHeight: 40, // was 32
                          ),
                          onPressed: _placeholderCallbackForButtons,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.shopping_bag_outlined,
                            size: 24, // was 18
                            color: Colors.grey,
                          ),
                          padding: const EdgeInsets.all(10), // was 8
                          constraints: const BoxConstraints(
                            minWidth: 40, // was 32
                            minHeight: 40, // was 32
                          ),
                          onPressed: _placeholderCallbackForButtons,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.menu,
                            size: 24, // was 18
                            color: Colors.grey,
                          ),
                          padding: const EdgeInsets.all(10), // was 8
                          constraints: const BoxConstraints(
                            minWidth: 40, // was 32
                            minHeight: 40, // was 32
                          ),
                          onPressed: _placeholderCallbackForButtons,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
