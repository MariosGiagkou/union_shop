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

  bool _isRoute(BuildContext context, String route) {
    return ModalRoute.of(context)?.settings.name == route;
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
        behavior: HitTestBehavior.translucent,
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
                      child: Image.asset(
                        'assets/images/logo1.png', // fixed path to load from assets folder
                        height: 90,
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
                          () => Navigator.pushNamed(context, '/sales'),
                          active: _isRoute(context, '/sales'),
                        ),
                        _navButton(
                          'About',
                          _aboutHover,
                          (v) => _aboutHover = v,
                          () => Navigator.pushNamed(context, '/about'),
                          active: _isRoute(context, '/about'),
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

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 800;

    // enlarged font sizes
    const headingStyle = TextStyle(
      fontSize: 18, // was 16
      fontWeight: FontWeight.w700,
      color: Colors.black,
      letterSpacing: .6,
    );
    const bodyStyle = TextStyle(
      fontSize: 15, // was 13
      height: 1.5, // was 1.4
      color: Colors.black87,
    );

    Widget thirdCol = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Latest Offers', style: headingStyle),
        const SizedBox(height: 14),
        Row(
          children: [
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Email address',
                  hintStyle: TextStyle(fontSize: 14),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 18,
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide:
                        BorderSide(color: Color(0xFF4d2963), width: 1.5),
                  ),
                ),
                style: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4d2963),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero),
                ),
                child: const Text(
                  'SUBSCRIBE',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );

    return Container(
      width: double.infinity,
      color: Colors.grey[50],
      // left-shift: reduce left padding, keep right padding larger
      padding:
          const EdgeInsets.fromLTRB(20, 48, 40, 48), // was symmetric 40 / 32
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Opening Hours', style: headingStyle),
                    SizedBox(height: 14),
                    Text(
                      '❄️ Winter Break Closure Dates ❄️\n'
                      'Closing 4pm 19/12/2025\n'
                      'Reopening 10am 05/01/2026\n'
                      'Last post date: 12pm on 18/12/2025\n'
                      '------------------------\n'
                      '(Term Time)\n'
                      'Monday - Friday 10am - 4pm\n'
                      '(Outside of Term Time / Consolidation Weeks)\n'
                      'Monday - Friday 10am - 3pm\n'
                      'Purchase online 24/7',
                      style: bodyStyle,
                    ),
                  ],
                )),
                const SizedBox(width: 36), // was 32
                const Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Help and Information', style: headingStyle),
                    SizedBox(height: 14),
                    Text('Search\nTerms & Conditions of Sale Policy',
                        style: bodyStyle),
                  ],
                )),
                const SizedBox(width: 36), // was 32
                Expanded(child: thirdCol),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Opening Hours', style: headingStyle),
                    SizedBox(height: 14),
                    Text(
                      '❄️ Winter Break Closure Dates ❄️\n'
                      'Closing 4pm 19/12/2025\n'
                      'Reopening 10am 05/01/2026\n'
                      'Last post date: 12pm on 18/12/2025\n'
                      '------------------------\n'
                      '(Term Time)\n'
                      'Monday - Friday 10am - 4pm\n'
                      '(Outside of Term Time / Consolidation Weeks)\n'
                      'Monday - Friday 10am - 3pm\n'
                      'Purchase online 24/7',
                      style: bodyStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 40), // was 32
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Help and Information', style: headingStyle),
                    SizedBox(height: 14),
                    Text('Search\nTerms & Conditions of Sale Policy',
                        style: bodyStyle),
                  ],
                ),
                const SizedBox(height: 40), // was 32
                thirdCol,
              ],
            ),
    );
  }
}
