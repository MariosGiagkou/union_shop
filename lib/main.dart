import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:union_shop/firebase_options.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/views/product_page.dart';
import 'package:union_shop/views/home_page.dart';
import 'package:union_shop/views/about_us.dart';
import 'package:union_shop/views/about_us_printshack.dart';
import 'package:union_shop/views/sign_in.dart';
import 'package:union_shop/views/collections_page.dart';
import 'package:union_shop/views/personalise_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const UnionShopApp());
}

class UnionShopApp extends StatelessWidget {
  const UnionShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/product',
          name: 'product',
          builder: (context, state) {
            // Forward extras (provided via context.go('/product', extra: {...}))
            final args = state.extra as Map<String, dynamic>?;
            return ProductPage(
              titleOverride: args?['title'] as String?,
              priceOverride: args?['price'] as String?,
              imageUrlOverride: args?['imageUrl'] as String?,
              discountPriceOverride: args?['discountPrice'] as String?,
            );
          },
        ),
        GoRoute(
          path: '/about',
          name: 'about',
          builder: (context, state) => const AboutUsPage(),
        ),
        GoRoute(
          path: '/printshack/about',
          name: 'printshack-about',
          builder: (context, state) => const PrintShackAboutPage(),
        ),
        GoRoute(
          path: '/sign-in',
          name: 'sign-in',
          builder: (context, state) => const SignInPage(),
        ),
        GoRoute(
          path: '/personalise',
          name: 'personalise',
          builder: (context, state) => const PersonalisePage(),
        ),
        GoRoute(
          path: '/collections',
          name: 'collections',
          builder: (context, state) => const CollectionsPage(),
          routes: [
            GoRoute(
              path: ':category',
              name: 'collection-category',
              builder: (context, state) {
                final category = state.pathParameters['category'];
                return CollectionsPage(category: category);
              },
              routes: [
                GoRoute(
                  path: 'product/:productId',
                  name: 'collection-product',
                  builder: (context, state) {
                    // productId available from state.pathParameters['productId'] if needed
                    final args = state.extra as Map<String, dynamic>?;
                    return ProductPage(
                      titleOverride: args?['title'] as String?,
                      priceOverride: args?['price'] as String?,
                      imageUrlOverride: args?['imageUrl'] as String?,
                      discountPriceOverride: args?['discountPrice'] as String?,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Union Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4d2963)),
      ),
      routerConfig: router,
    );
  }
}
