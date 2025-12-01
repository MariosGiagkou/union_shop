import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/home_page.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('Portsmouth City Collection', () {
    testWidgets('collection headings and product keys', (tester) async {
      await pumpWithProviders(tester, const HomePage());
      await tester.pumpAndSettle();

      // Section headings
      expect(find.text('ESSENTIAL RANGE - OVER 20% OFF!'), findsOneWidget);
      expect(find.text('SIGNATURE RANGE'), findsOneWidget);
      expect(find.text('PORTSMOUTH CITY COLLECTION'), findsOneWidget);

      // Essential range products
      expect(
          find.byKey(
              const ValueKey('product:Limited Edition Essential Zip Hoodies')),
          findsOneWidget);
      expect(find.byKey(const ValueKey('product:Essential T-Shirt')),
          findsOneWidget);

      // Signature range products
      expect(find.byKey(const ValueKey('product:Signiture Hoodie')),
          findsOneWidget);
      expect(find.byKey(const ValueKey('product:Signiture T-Shirt')),
          findsOneWidget);

      // Portsmouth City collection products
      expect(find.byKey(const ValueKey('product:Portsmouth City Postcard')),
          findsOneWidget);
      expect(find.byKey(const ValueKey('product:Portsmouth City Magnet')),
          findsOneWidget);
      expect(find.byKey(const ValueKey('product:Portsmouth City Bookmark')),
          findsOneWidget);
      expect(find.byKey(const ValueKey('product:Portsmouth City Notebook')),
          findsOneWidget);
    });

    testWidgets('Portsmouth City collection product cards exist via keys',
        (tester) async {
      await pumpWithProviders(tester, const HomePage());
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('product:Portsmouth City Postcard')),
          findsOneWidget);
      expect(find.byKey(const ValueKey('product:Portsmouth City Magnet')),
          findsOneWidget);
      expect(find.byKey(const ValueKey('product:Portsmouth City Bookmark')),
          findsOneWidget);
      expect(find.byKey(const ValueKey('product:Portsmouth City Notebook')),
          findsOneWidget);
    });
  });

  group('Hero Section', () {
    testWidgets('HomePage builds and shows hero text', (tester) async {
      await pumpWithProviders(tester, const HomePage());
      await tester.pumpAndSettle();
      // Updated hero first slide text
      expect(find.text('essential range 20% OFF'), findsOneWidget);
      // Keys in hero controls
      expect(find.byKey(const PageStorageKey('hero:carousel')), findsOneWidget);
      expect(find.byKey(const Key('hero:left')), findsOneWidget);
      expect(find.byKey(const Key('hero:right')), findsOneWidget);
      expect(find.byKey(const Key('hero:pause')), findsOneWidget);
      expect(find.byKey(const Key('hero:browse:1')), findsOneWidget);
      // Navigate to second slide to verify its button key
      await tester.drag(find.byKey(const PageStorageKey('hero:carousel')),
          const Offset(-600, 0));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('hero:browse:2')), findsOneWidget);
    });
  });
}
