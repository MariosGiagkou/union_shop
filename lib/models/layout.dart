import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  // Track if shop dropdown is open
  OverlayEntry? _shopDropdownOverlay;
  final LayerLink _shopLayerLink = LayerLink();

  // Track if print shack dropdown is open
  OverlayEntry? _printShackDropdownOverlay;
  final LayerLink _printShackLayerLink = LayerLink();

  // Track search box state
  bool _showSearchBox = false;
  int _searchClickCount = 0;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  DateTime? _lastSearchClick;

  @override
  void dispose() {
    _removeShopDropdown();
    _removePrintShackDropdown();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _removeShopDropdown() {
    _shopDropdownOverlay?.remove();
    _shopDropdownOverlay = null;
    setState(() => _shopHover = false);
  }

  void _removePrintShackDropdown() {
    _printShackDropdownOverlay?.remove();
    _printShackDropdownOverlay = null;
    setState(() => _tpsHover = false);
  }

  void _showShopDropdown(BuildContext context) {
    // Collection items matching collections_page.dart (without personalisation)
    final collections = [
      {'title': 'Signature', 'slug': 'signature'},
      {'title': 'Sale', 'slug': 'sale'},
      {'title': 'Merchandise', 'slug': 'merchandise'},
      {'title': 'Portsmouth City', 'slug': 'portsmouth-city'},
      {'title': 'Pride', 'slug': 'pride'},
      {'title': 'Halloween', 'slug': 'halloween'},
      {'title': 'Graduation', 'slug': 'graduation'},
    ];

    setState(() => _shopHover = true);

    _shopDropdownOverlay = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _removeShopDropdown,
        child: Stack(
          children: [
            // Transparent overlay to catch clicks outside
            Positioned.fill(
              child: Container(color: Colors.transparent),
            ),
            // Dropdown menu
            Positioned(
              width: 220,
              child: CompositedTransformFollower(
                link: _shopLayerLink,
                showWhenUnlinked: false,
                offset: const Offset(0, 5),
                child: Material(
                  elevation: 8,
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: collections.map((collection) {
                      return InkWell(
                        onTap: () {
                          _removeShopDropdown();
                          _navigate(
                              context, '/collections/${collection['slug']}');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Text(
                            collection['title']!,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_shopDropdownOverlay!);
  }

  void _showPrintShackDropdown(BuildContext context) {
    // Print Shack dropdown options
    final options = [
      {'title': 'About', 'route': '/printshack/about'},
      {'title': 'Personalisation', 'route': '/personalise'},
    ];

    setState(() => _tpsHover = true);

    _printShackDropdownOverlay = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _removePrintShackDropdown,
        child: Stack(
          children: [
            // Transparent overlay to catch clicks outside
            Positioned.fill(
              child: Container(color: Colors.transparent),
            ),
            // Dropdown menu
            Positioned(
              width: 220,
              child: CompositedTransformFollower(
                link: _printShackLayerLink,
                showWhenUnlinked: false,
                offset: const Offset(0, 5),
                child: Material(
                  elevation: 8,
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: options.map((option) {
                      return InkWell(
                        onTap: () {
                          _removePrintShackDropdown();
                          _navigate(context, option['route']!);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Text(
                            option['title']!,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_printShackDropdownOverlay!);
  }

  void _handleSearchIconClick() {
    final now = DateTime.now();

    // Check if this is a double click (within 500ms)
    if (_lastSearchClick != null &&
        now.difference(_lastSearchClick!).inMilliseconds < 500) {
      // Double click - navigate to search page
      setState(() {
        _showSearchBox = false;
        _searchClickCount = 0;
        _lastSearchClick = null;
      });
      _navigate(context, '/search');
    } else {
      // Single click - toggle search box
      setState(() {
        _showSearchBox = !_showSearchBox;
        _lastSearchClick = now;
        if (_showSearchBox) {
          // Focus the search box when it appears
          Future.delayed(const Duration(milliseconds: 100), () {
            _searchFocusNode.requestFocus();
          });
        }
      });
    }
  }

  void _performQuickSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      // Navigate to search page with query parameter
      final uri = Uri(path: '/search', queryParameters: {'q': query});
      _navigate(context, uri.toString());
      // Clear the search box after navigating
      setState(() {
        _showSearchBox = false;
        _searchController.clear();
      });
    }
  }

  void _placeholderCallbackForButtons() {
    // placeholder for buttons that don't do anything yet
  }

  String _currentLocation(BuildContext context) {
    return GoRouter.maybeOf(context)?.location ??
        ModalRoute.of(context)?.settings.name ??
        '/';
  }

  void _goHome(BuildContext context) {
    final router = GoRouter.maybeOf(context);
    if (router != null) {
      router.go('/');
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
    }
  }

  void _navigate(BuildContext context, String route) {
    final router = GoRouter.maybeOf(context);
    if (router != null) {
      router.go(route);
    } else {
      Navigator.pushNamed(context, route);
    }
  }

  bool _isHome(BuildContext context) {
    final loc = _currentLocation(context);
    return loc == '/' || loc.isEmpty;
  }

  bool _isRoute(BuildContext context, String route) {
    return _currentLocation(context) == route;
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

  // Shop button with dropdown arrow
  Widget _shopButtonWithArrow() {
    return MouseRegion(
      onEnter: (_) => setState(() => _shopHover = true),
      onExit: (_) => setState(() => _shopHover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _showShopDropdown(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Shop',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 16,
                  fontWeight: _shopHover ? FontWeight.w700 : FontWeight.w500,
                  decoration: _shopHover
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: Colors.grey[800],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Print Shack button with dropdown arrow
  Widget _printShackButtonWithArrow() {
    return MouseRegion(
      onEnter: (_) => setState(() => _tpsHover = true),
      onExit: (_) => setState(() => _tpsHover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _showPrintShackDropdown(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'The Printing Shack',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 16,
                  fontWeight: _tpsHover ? FontWeight.w700 : FontWeight.w500,
                  decoration: _tpsHover
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: Colors.grey[800],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isWideNav = MediaQuery.of(context).size.width >= 800; // added
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
                  // Center: nav buttons (shown only on wide screens)
                  if (isWideNav)
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
                          // Shop button with dropdown and arrow
                          CompositedTransformTarget(
                            link: _shopLayerLink,
                            child: _shopButtonWithArrow(),
                          ),
                          // Print Shack button with dropdown and arrow
                          CompositedTransformTarget(
                            link: _printShackLayerLink,
                            child: _printShackButtonWithArrow(),
                          ),
                          _navButton(
                            'SALES!',
                            _salesHover,
                            (v) => _salesHover = v,
                            () => _navigate(context, '/collections/sale'),
                            active: _isRoute(context, '/collections/sale'),
                          ),
                          _navButton(
                            'About',
                            _aboutHover,
                            (v) => _aboutHover = v,
                            () => _navigate(context, '/about'),
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
                          // Search icon with expandable text field
                          if (_showSearchBox) ...[
                            SizedBox(
                              width: 200,
                              height: 40,
                              child: TextField(
                                controller: _searchController,
                                focusNode: _searchFocusNode,
                                onSubmitted: (_) => _performQuickSearch(),
                                decoration: InputDecoration(
                                  hintText: 'Search...',
                                  hintStyle: const TextStyle(fontSize: 14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF4d2963),
                                      width: 1.5,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.close, size: 18),
                                    onPressed: () {
                                      setState(() {
                                        _showSearchBox = false;
                                        _searchController.clear();
                                      });
                                    },
                                  ),
                                ),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          IconButton(
                            icon: const Icon(Icons.search,
                                size: 24, color: Colors.grey),
                            padding: const EdgeInsets.all(10),
                            constraints: const BoxConstraints(
                                minWidth: 40, minHeight: 40),
                            onPressed: _handleSearchIconClick,
                          ),
                          IconButton(
                            icon: const Icon(Icons.person_outline,
                                size: 24, color: Colors.grey),
                            padding: const EdgeInsets.all(10),
                            constraints: const BoxConstraints(
                                minWidth: 40, minHeight: 40),
                            onPressed: () => _navigate(context, '/sign-in'),
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

extension on GoRouter? {
  get location => null;
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
