import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/home_page.dart';

void main() {
  group('HomePage View', () {
    testWidgets('renders header, hero, products, footer', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: HomePage()),
      );
      await tester.pump();

      // Header banner
      expect(find.textContaining('BIG SALE!'), findsOneWidget);

      // Hero
      expect(find.text('Placeholder Hero Title'), findsOneWidget);
      expect(find.text('BROWSE PRODUCTS'), findsOneWidget);

      // Products section heading
      expect(find.text('PRODUCTS SECTION'), findsOneWidget);

      // Product cards
      expect(find.text('Placeholder Product 1'), findsOneWidget);
      expect(find.text('Placeholder Product 2'), findsOneWidget);
      expect(find.text('Placeholder Product 3'), findsOneWidget);
      expect(find.text('Placeholder Product 4'), findsOneWidget);

      // Footer headings
      expect(find.text('Opening Hours'), findsOneWidget);
      expect(find.text('Help and Information'), findsOneWidget);
      expect(find.text('Latest Offers'), findsOneWidget);
    });

    testWidgets('subscribe elements in footer exist', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: HomePage()),
      );
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('SUBSCRIBE'), findsOneWidget);
    });
  });
}
