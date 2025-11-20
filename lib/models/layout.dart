import 'package:flutter/material.dart';

class SiteHeader extends StatefulWidget {
  const SiteHeader({super.key});

  @override
  State<SiteHeader> createState() => _SiteHeaderState();
}

class _SiteHeaderState extends State<SiteHeader> {
  bool _homeHover = false;
  bool _shopHover = false; // added
  bool _tpsHover = false; // added
  bool _salesHover = false; // added
  bool _aboutHover = false; // added

  void _placeholderCallbackForButtons() {
    // placeholder for buttons that don't do anything yet
  }

  void _goHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  bool _isHome(BuildContext context) {
    final name = ModalRoute.of(context)?.settings.name;
    return name == '/' || name == null;
  }

  // helper to render nav text buttons with hover/active styles
  Widget _navButton(
    String label,
    bool hover,
    void Function(bool) setHover,
    VoidCallback onTap, {
    bool active = false,
  }) {
    return MouseRegion(
      onEnter: (_) => setState(() => setHover(true)),
      onExit: (_) => setState(() => setHover(false)),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 16,
              fontWeight: (hover || active) ? FontWeight.w700 : FontWeight.w500,
              decoration: (hover || active)
                  ? TextDecoration.underline
                  : TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      color: Colors.white,
      child: Column(
        children: [
          // Top banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Left: Logo
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => _goHome(context),
                      child: Image.network(
                        'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
                        height: 28,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            width: 28,
                            height: 28,
                            child: const Center(
                              child: Icon(Icons.image_not_supported,
                                  color: Colors.grey),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Center: nav buttons (Home + new dummy links)
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _navButton(
                          'Home',
                          _homeHover,
                          (v) => _homeHover = v,
                          () => _goHome(context),
                          active: _isHome(context),
                        ),
                        _navButton(
                          'Shop',
                          _shopHover,
                          (v) => _shopHover = v,
                          _placeholderCallbackForButtons,
                        ),
                        _navButton(
                          'The Printing Shack',
                          _tpsHover,
                          (v) => _tpsHover = v,
                          _placeholderCallbackForButtons,
                        ),
                        _navButton(
                          'SALES!',
                          _salesHover,
                          (v) => _salesHover = v,
                          _placeholderCallbackForButtons,
                        ),
                        _navButton(
                          'About',
                          _aboutHover,
                          (v) => _aboutHover = v,
                          _placeholderCallbackForButtons,
                        ),
                      ],
                    ),
                  ),
                  // Right: Icons group
                  Align(
                    alignment: Alignment.centerRight,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.search,
                                size: 24, color: Colors.grey),
                            padding: const EdgeInsets.all(10),
                            constraints: const BoxConstraints(
                                minWidth: 40, minHeight: 40),
                            onPressed: _placeholderCallbackForButtons,
                          ),
                          IconButton(
                            icon: const Icon(Icons.person_outline,
                                size: 24, color: Colors.grey),
                            padding: const EdgeInsets.all(10),
                            constraints: const BoxConstraints(
                                minWidth: 40, minHeight: 40),
                            onPressed: _placeholderCallbackForButtons,
                          ),
                          IconButton(
                            icon: const Icon(Icons.shopping_bag_outlined,
                                size: 24, color: Colors.grey),
                            padding: const EdgeInsets.all(10),
                            constraints: const BoxConstraints(
                                minWidth: 40, minHeight: 40),
                            onPressed: _placeholderCallbackForButtons,
                          ),
                          IconButton(
                            icon: const Icon(Icons.menu,
                                size: 24, color: Colors.grey),
                            padding: const EdgeInsets.all(10),
                            constraints: const BoxConstraints(
                                minWidth: 40, minHeight: 40),
                            onPressed: _placeholderCallbackForButtons,
                          ),
                        ],
                      ),
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
