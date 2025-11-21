import 'package:flutter/material.dart';
import 'package:union_shop/models/layout.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

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
                  constraints: const BoxConstraints(maxWidth: 960),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About us',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 28),
                      Text('Welcome to the Union Shop.'),
                      SizedBox(height: 24),
                      Text(
                          'We sell university branded clothing and merchandise all year round. You can add personal text to selected items.'),
                      SizedBox(height: 24),
                      Text('Order online for delivery or collect in store.'),
                      SizedBox(height: 24),
                      Text('Got a question or idea? Email hello@upsu.net.'),
                      SizedBox(height: 24),
                      Text('Happy shopping!'),
                      SizedBox(height: 32),
                      Text('The Union Shop & Reception Team'),
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
