import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/home_page.dart';

void main() {
  group('HomePage consolidated tests', () {
    testWidgets('renders headings and all product titles', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      await tester.pumpAndSettle();

      // Section headings
      expect(find.text('ESSENTIAL RANGE - OVER 20% OFF!'), findsOneWidget);
      expect(find.text('SIGNATURE RANGE'), findsOneWidget);
      expect(find.text('PORTSMOUTH CITY COLLECTION'), findsOneWidget);

      // Essential products
      expect(find.text('Limited Edition Essential Zip Hoodies'), findsOneWidget);
      expect(find.text('Essential T-Shirt'), findsOneWidget);

      // Signature products
      expect(find.text('Signiture Hoodie'), findsOneWidget);
      expect(find.text('Signiture T-Shirt'), findsOneWidget);

      // Portsmouth City collection products
      expect(find.text('Portsmouth City Postcard'), findsOneWidget);
      expect(find.text('Portsmouth City Magnet'), findsOneWidget);
      expect(find.text('Portsmouth City Bookmark'), findsOneWidget);
      expect(find.text('Portsmouth City Notebook'), findsOneWidget);

      // Total product cards
      expect(find.byType(ProductCard), findsNWidgets(8));
    });

    testWidgets('pricing and original price styling', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      await tester.pumpAndSettle();

      // Original + sale prices (essential range)
      final original20 = find.text('£20.00');
      final sale1499 = find.text('£14.99');
      final original10 = find.text('£10.00');
      final sale699 = find.text('£6.99');

      expect(original20, findsOneWidget);
      expect(sale1499, findsOneWidget);
      expect(original10, findsOneWidget);
      expect(sale699, findsOneWidget);

      // Portsmouth City prices
      expect(find.text('£1.00'), findsOneWidget);
      expect(find.text('£4.50'), findsOneWidget);
      expect(find.text('£3.00'), findsOneWidget);
      expect(find.text('£7.50'), findsOneWidget);

      // Signature prices
      expect(find.text('£32.99'), findsOneWidget);
      expect(find.text('£14.99'), findsNWidgets(2)); // hoodie sale + signature tee

      // Style checks on original prices only
      final orig20Text = tester.widget<Text>(original20);
      final orig10Text = tester.widget<Text>(original10);

      expect(orig20Text.style?.decoration, TextDecoration.lineThrough);
      expect(orig10Text.style?.decoration, TextDecoration.lineThrough);
      expect(orig20Text.style?.fontWeight, FontWeight.w600);
      expect(orig10Text.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('all asset images and hero image load', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      await tester.pumpAndSettle();

      // Hero
      expect(
        find.byWidgetPredicate((w) =>
            w is Image &&
            w.image is NetworkImage &&
            (w.image as NetworkImage).url.contains('PortsmouthCityPostcard2')),
        findsOneWidget,
      );

      // Essential
      expect(find.image(const AssetImage('assets/images/pink_hoodie.webp')), findsOneWidget);
      expect(find.image(const AssetImage('assets/images/essential_t-shirt.webp')), findsOneWidget);

      // Signature
      expect(find.image(const AssetImage('assets/images/signature_hoodie.webp')), findsOneWidget);
      expect(find.image(const AssetImage('assets/images/signiture_t-shirt.webp')), findsOneWidget);

      // Collection
      expect(find.image(const AssetImage('assets/images/PortsmouthCityPostcard.webp')), findsOneWidget);
      expect(find.image(const AssetImage('assets/images/PortsmouthCityMagnet.jpg')), findsOneWidget);
      expect(find.image(const AssetImage('assets/images/PortsmouthCityBookmark.jpg')), findsOneWidget);
      expect(find.image(const AssetImage('assets/images/PortsmouthCityNotebook.webp')), findsOneWidget);
    });

    testWidgets('hover underlines product title', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      await tester.pumpAndSettle();

      final targetTitle = find.text('Limited Edition Essential Zip Hoodies');

      final before = tester.widget<Text>(targetTitle);
      expect(before.style?.decoration, isNot(TextDecoration.underline));

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: tester.getCenter(targetTitle));
      await tester.pump();
      await gesture.moveTo(tester.getCenter(targetTitle));
      await tester.pumpAndSettle();

      final after = tester.widget<Text>(targetTitle);
      expect(after.style?.decoration, TextDecoration.underline);
    });

    testWidgets('responsive layout wide vs narrow', (tester) async {
      // Wide layout
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(1000, 1200)),
            child: HomePage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Row), findsAtLeastNWidgets(3));

      // Narrow layout
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(420, 1200)),
            child: HomePage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Limited Edition Essential Zip Hoodies'), findsOneWidget);
      expect(find.text('Signiture Hoodie'), findsOneWidget);
      expect(find.text('Portsmouth City Notebook'), findsOneWidget);
    });

    // ProductCard tests
    testWidgets('ProductCard renders asset image', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: ProductCard(
            title: 'Test Product',
            price: '£35.00',
            imageUrl: 'assets/images/pink_hoodie.webp',
            useAsset: true,
            customHeight: 100,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('£35.00'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('ProductCard renders network image', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: ProductCard(
            title: 'Network Product',
            price: '£15.00',
            imageUrl: 'https://example.com/image.jpg',
            customHeight: 100,
          ),
        ),
      ));

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));

      expect(find.text('Network Product'), findsOneWidget);
      expect(find.text('£15.00'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });
  });
}
