import 'package:flutter/material.dart';
import 'package:union_shop/models/layout.dart';

/// Sales page showing discounted / promotional items.
/// Uses shared `SiteHeader` and `SiteFooter` from `layout.dart`.
class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SiteHeader(),
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.white,
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.only(top: 40),
              child: const Column(
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
            ),
            const SizedBox(height: 40),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}
