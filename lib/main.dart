import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/views/product_page.dart';
import 'package:union_shop/views/home_page.dart';
import 'package:union_shop/views/about_us.dart';
import 'package:union_shop/views/SALES!.dart';
import 'package:union_shop/views/sign_in.dart';
import 'package:union_shop/views/collections_page.dart';

void main() {
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
          builder: (context, state) => const ProductPage(),
        ),
        GoRoute(
          path: '/about',
          name: 'about',
          builder: (context, state) => const AboutUsPage(),
        ),
        GoRoute(
          path: '/sales',
          name: 'sales',
          builder: (context, state) => const SalesPage(),
        ),
        GoRoute(
          path: '/sign-in',
          name: 'sign-in',
          builder: (context, state) => const SignInPage(),
        ),
        GoRoute(
          path: '/collections',
          name: 'collections',
          builder: (context, state) => const CollectionsPage(),
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
