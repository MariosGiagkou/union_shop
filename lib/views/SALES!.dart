import 'package:flutter/material.dart';
import 'package:union_shop/models/layout.dart';

/// Sales page showing discounted / promotional items.
/// Uses shared `SiteHeader` and `SiteFooter` from `layout.dart`.
class SalesPage extends StatefulWidget {
  const SalesPage({super.key});
  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  String _selectedFilter = 'All products';
  String _selectedSort = 'Best selling';
  final int _productCount = 14; // placeholder

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SiteHeader(),
            Container(
              width: double.infinity,
              height: 360,
              color: Colors.white,
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'SALE',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Don’t miss out! Get yours before they’re all gone!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.4,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'All prices shown are inclusive of the discount 🛒',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: Color(0xFF444444),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  // Filter / Sort / Count bar moved here (not in footer area)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      children: [
                        DropdownButton<String>(
                          value: _selectedFilter,
                          items: const [
                            DropdownMenuItem(
                              value: 'All products',
                              child: Text('Filter by  All products'),
                            ),
                          ],
                          onChanged: (v) {
                            if (v != null) setState(() => _selectedFilter = v);
                          },
                        ),
                        const SizedBox(width: 24),
                        DropdownButton<String>(
                          value: _selectedSort,
                          items: const [
                            DropdownMenuItem(
                              value: 'Best selling',
                              child: Text('Sort by  Best selling'),
                            ),
                          ],
                          onChanged: (v) {
                            if (v != null) setState(() => _selectedSort = v);
                          },
                        ),
                        const Spacer(),
                        Text(
                          '$_productCount products',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}
