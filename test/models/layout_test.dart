import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/layout.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('Layout (Header & Footer)', () {
    testWidgets('SiteHeader displays nav items', (tester) async {
      await pumpWithProviders(
        tester,
        const Scaffold(body: SiteHeader()),
        authService: createSignedOutAuthService(),
      );

      // Banner
      expect(find.textContaining('BIG SALE!'), findsOneWidget);

      // Nav items
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Shop'), findsOneWidget);
      expect(find.text('The Printing Shack'), findsOneWidget);
      expect(find.text('SALES!'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    });

    testWidgets('SiteHeader displays icons', (tester) async {
      await pumpWithProviders(
        tester,
        const Scaffold(body: SiteHeader()),
        authService: createSignedOutAuthService(),
      );

      // Icons
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    });

    testWidgets('SiteFooter displays all columns', (tester) async {
      await pumpWithProviders(
        tester,
        const Scaffold(body: SingleChildScrollView(child: SiteFooter())),
      );

      expect(find.text('Opening Hours'), findsOneWidget);
      expect(find.text('Help and Information'), findsOneWidget);
      expect(find.text('Latest Offers'), findsOneWidget);
    });
  });
}
