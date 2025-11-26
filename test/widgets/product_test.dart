import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/product_page.dart';

void main() {
  group('Legacy Product Page Header/Footer Tests (updated to current layout)',
      () {
    Widget createTestWidget() => const MaterialApp(home: ProductPage());

    testWidgets('renders sale banner and navigation icons', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(
        find.text(
          'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF! COME GRAB YOURS WHILE STOCK LASTS!',
        ),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('renders product fallback title and price placeholder',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Product'), findsOneWidget); // default title
      expect(find.text('—'), findsOneWidget); // fallback price
      expect(find.text('Description'), findsOneWidget);
    });

    testWidgets('renders student instruction and additional description text',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(
        find.text(
          'Students should add size options, colour options, quantity selector, add to cart button, and buy now button here.',
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          'This is a placeholder description for the product. Students should replace this with real product information and implement proper data management.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders footer sections by heading text', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Opening Hours'), findsOneWidget);
      expect(find.text('Help and Information'), findsOneWidget);
      expect(find.text('Latest Offers'), findsOneWidget);
    });
  });
}
