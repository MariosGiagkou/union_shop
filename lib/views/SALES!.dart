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
            ),
            const SizedBox(height: 40),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}
 