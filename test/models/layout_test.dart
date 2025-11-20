import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/layout.dart';

void main() {
  group('Layout (Header & Footer)', () {
    testWidgets('SiteHeader displays nav items and icons', (tester) async {
      await tester
          .pumpWidget(const MaterialApp(home: Scaffold(body: SiteHeader())));
      await tester.pump();

      // Banner
      expect(find.textContaining('BIG SALE!'), findsOneWidget);

      // Nav items
      for (final label in [
        'Home',
        'Shop',
        'The Printing Shack',
        'SALES!',
        'About',
      ]) {
        expect(find.text(label), findsOneWidget);
      }

      // Icons
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('SiteFooter displays all columns', (tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(body: SingleChildScrollView(child: SiteFooter()))));
      await tester.pump();

      expect(find.text('Opening Hours'), findsOneWidget);
      expect(find.text('Help and Information'), findsOneWidget);
      expect(find.text('Latest Offers'), findsOneWidget);
      expect(find.text('SUBSCRIBE'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
