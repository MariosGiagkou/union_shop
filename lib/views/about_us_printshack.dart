import 'package:flutter/material.dart';
import 'package:union_shop/models/layout.dart';

class PrintShackAboutPage extends StatelessWidget {
  const PrintShackAboutPage({super.key});

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'About us',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Print Shack Logo Banner
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/The_Union_Print_Shack_Logo.webp',
                            width: 1000,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Make It Yours section
                      const Text(
                        'Make It Yours at The Union Print Shack',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Want to add a personal touch? We\'ve got you covered with heat-pressed customisation on all our clothing. Swing by the shop - our team\'s always happy to help you pick the right gear and answer any questions.',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Uni Gear or Your Gear section
                      const Text(
                        'Uni Gear or Your Gear - We\'ll Personalise It',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Whether you\'re repping your university or putting your own spin on a hoodie you already own, we\'ve got you covered. We can personalise official uni-branded clothing and your own items - just bring them in and let\'s get creative!',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Simple Pricing section
                      const Text(
                        'Simple Pricing, No Surprises',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Customising your gear won\'t break the bank - just £3 for one line of text or a small chest logo, and £5 for two lines or a large back logo. Turnaround time is up to three working days, and we\'ll let you know as soon as it\'s ready to collect.',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Terms & Conditions section
                      const Text(
                        'Personalisation Terms & Conditions',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'We will print your clothing exactly as you have provided it to us, whether online or in person. We are not responsible for any spelling errors. Please ensure your chosen text is clearly displayed in either capitals or lowercase. Refunds are not provided for any personalised items.',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Ready to Make It Yours section
                      const Text(
                        'Ready to Make It Yours?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Pop in or get in touch today - let\'s create something uniquely you with our personalisation service - The Union Print Shack!',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 32),
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
