import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/product_page.dart';

void main() {
  group('ProductPage (views)', () {
    Widget _wrap(Widget child) => MaterialApp(home: child);

    testWidgets('renders core elements and keys by default', (tester) async {
      await tester.pumpWidget(_wrap(const ProductPage()));
      await tester.pump();

      expect(find.byKey(const Key('product:image')), findsOneWidget);
      expect(find.byKey(const Key('product:title')), findsOneWidget);
      expect(find.byKey(const Key('product:price')), findsOneWidget);
      expect(find.byKey(const Key('product:add-to-cart')), findsOneWidget);
      // Defaults
      expect(find.text('Product'), findsOneWidget);
      expect(find.text('—'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(
        find.text(
          'This is a placeholder description for the product. Students should replace this with real product information and implement proper data management.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows original price when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(const ProductPage(
          titleOverride: 'Tee',
          priceOverride: '£15.00',
          originalPriceOverride: '£20.00',
        )),
      );
      await tester.pump();

      expect(find.text('Tee'), findsOneWidget);
      expect(find.text('£15.00'), findsOneWidget);
      expect(find.byKey(const Key('product:originalPrice')), findsOneWidget);
      expect(find.text('£20.00'), findsOneWidget);
    });

    testWidgets('omits original price when not provided', (tester) async {
      await tester.pumpWidget(
        _wrap(const ProductPage(
          titleOverride: 'Hoodie',
          priceOverride: '£30.00',
        )),
      );
      await tester.pump();

      expect(find.text('Hoodie'), findsOneWidget);
      expect(find.text('£30.00'), findsOneWidget);
      expect(find.byKey(const Key('product:originalPrice')), findsNothing);
    });

    testWidgets('resolves route arguments for title/price/image',
        (tester) async {
      final args = <String, dynamic>{
        'title': 'Route Product',
        'price': '£9.99',
        'imageUrl': 'assets/images/fidget.avif',
        'useAsset': true,
      };

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/product': (_) => const ProductPage(),
          },
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/product', arguments: args),
              child: const Text('GO'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('GO'));
      await tester.pumpAndSettle();

      expect(find.text('Route Product'), findsOneWidget);
      expect(find.text('£9.99'), findsOneWidget);
      expect(find.byKey(const Key('product:image')), findsOneWidget);
    });

    testWidgets('wide layout places content in a Row', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      addTearDown(() async => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        _wrap(const ProductPage(
          titleOverride: 'Wide',
          priceOverride: '£1.00',
          imageUrlOverride: 'assets/images/fidget.avif',
          useAssetOverride: true,
        )),
      );
      await tester.pump();

      // Title should have a Row ancestor from the two-column layout
      expect(
        find.ancestor(
          of: find.byKey(const Key('product:title')),
          matching: find.byType(Row),
        ),
        findsOneWidget,
      );
      // Image should also participate in the Row
      expect(
        find.ancestor(
          of: find.byKey(const Key('product:image')),
          matching: find.byType(Row),
        ),
        findsOneWidget,
      );
    });

    testWidgets('narrow layout stacks content in a Column', (tester) async {
      // Use a slightly wider "narrow" width to avoid header/footer overflows
      await tester.binding.setSurfaceSize(const Size(780, 1200));
      addTearDown(() async => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        _wrap(const ProductPage(
          titleOverride: 'Narrow',
          priceOverride: '£2.00',
          imageUrlOverride: 'assets/images/fidget.avif',
          useAssetOverride: true,
        )),
      );
      await tester.pumpAndSettle();

      // Title should NOT have the outer Row ancestor in narrow mode
      expect(
        find.ancestor(
          of: find.byKey(const Key('product:title')),
          matching: find.byType(Row),
        ),
        findsNothing,
      );
    });

    testWidgets('add to cart button is tappable (no crash)', (tester) async {
      await tester.pumpWidget(_wrap(const ProductPage()));
      await tester.pump();

      await tester.tap(find.byKey(const Key('product:add-to-cart')));
      await tester.pump();

      // No exceptions should be thrown by the placeholder handler
      expect(tester.takeException(), isNull);
    });

    testWidgets('header and footer basic presence', (tester) async {
      await tester.pumpWidget(_wrap(const ProductPage()));
      await tester.pump();

      // Sale banner text from SiteHeader
      expect(
        find.text(
          'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF! COME GRAB YOURS WHILE STOCK LASTS!',
        ),
        findsOneWidget,
      );
      // Footer section headings
      expect(find.text('Opening Hours'), findsOneWidget);
      expect(find.text('Help and Information'), findsOneWidget);
      expect(find.text('Latest Offers'), findsOneWidget);
    });
  });
}
