import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/home_page.dart';

void main() {
  group('HomePage structure', () {
    testWidgets('renders headings, products, prices, footer', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      await tester.pumpAndSettle();

      // Range headings
      expect(find.text('ESSENTIAL RANGE - OVER 20% OFF!'), findsOneWidget);
      expect(find.text('SIGNATURE RANGE'), findsOneWidget);

      // Product titles
      expect(find.text('Limited Edition Essential Zip Hoodies'), findsOneWidget);
      expect(find.text('Essential T-Shirt'), findsOneWidget);
      expect(find.text('Placeholder Product 3'), findsOneWidget);
      expect(find.text('Placeholder Product 4'), findsOneWidget);

      // Original + sale prices
      final original20 = find.text('£20.00');
      final sale1499 = find.text('£14.99');
      final original10 = find.text('£10.00');
      final sale699 = find.text('£6.99');

      expect(original20, findsOneWidget);
      expect(sale1499, findsOneWidget);
      expect(original10, findsOneWidget);
      expect(sale699, findsOneWidget);

      // Styling checks
      final orig20Text = tester.widget<Text>(original20);
      final sale1499Text = tester.widget<Text>(sale1499);
      expect(orig20Text.style?.decoration, TextDecoration.lineThrough);
      expect(orig20Text.style?.fontWeight, FontWeight.w600);
      expect(sale1499Text.style?.fontWeight, FontWeight.w600);

      final orig10Text = tester.widget<Text>(original10);
      final sale699Text = tester.widget<Text>(sale699);
      expect(orig10Text.style?.decoration, TextDecoration.lineThrough);
      expect(orig10Text.style?.fontWeight, FontWeight.w600);
      expect(sale699Text.style?.fontWeight, FontWeight.w600);

      // ProductCard count
      expect(find.byType(ProductCard), findsNWidgets(4));

      // Footer presence
      expect(find.text('Opening Hours'), findsOneWidget);
      expect(find.text('Help and Information'), findsOneWidget);
      expect(find.text('Latest Offers'), findsOneWidget);
      expect(find.text('SUBSCRIBE'), findsOneWidget);
    });

    testWidgets('wide layout uses rows for both ranges', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(1000, 1200)),
            child: HomePage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // At least two Row widgets for the two range sections
      expect(find.byType(Row), findsAtLeastNWidgets(2));
    });

    testWidgets('narrow layout stacks products vertically', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(400, 1200)),
            child: HomePage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Limited Edition Essential Zip Hoodies'), findsOneWidget);
      expect(find.text('Essential T-Shirt'), findsOneWidget);

      // Columns used in stacked layout
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('image assets and network images load', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      await tester.pumpAndSettle();

      // Hero background (search by NetworkImage URL)
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Image &&
              w.image is NetworkImage &&
              (w.image as NetworkImage)
                  .url
                  .contains('PortsmouthCityPostcard2'),
        ),
        findsOneWidget,
      );

      // Essential range asset images
      expect(
        find.image(const AssetImage('assets/images/pink_hoodie.webp')),
        findsOneWidget,
      );
      expect(
        find.image(const AssetImage('assets/images/essential_t-shirt.webp')),
        findsOneWidget,
      );

      // Signature range network images (2 placeholders)
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Image &&
              w.image is NetworkImage &&
              (w.image as NetworkImage)
                  .url
                  .contains('PortsmouthCityMagnet1_1024x1024@2x.jpg'),
        ),
        findsNWidgets(2),
      );

      // Ensure total product images = 4
      final productImages = find.byWidgetPredicate(
        (w) =>
            w is Image &&
            ((w.image is AssetImage &&
                    ((w.image as AssetImage).assetName.contains('pink_hoodie') ||
                        (w.image as AssetImage)
                            .assetName
                            .contains('essential_t-shirt'))) ||
                (w.image is NetworkImage &&
                    (w.image as NetworkImage)
                        .url
                        .contains('PortsmouthCityMagnet1_1024x1024@2x.jpg'))),
      );
      expect(productImages, findsNWidgets(4));
    });
  });
}
