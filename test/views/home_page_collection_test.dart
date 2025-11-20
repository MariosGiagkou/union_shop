import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/home_page.dart';

void main() {
  group('Portsmouth City Collection', () {
    testWidgets('collection headings and product counts', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      await tester.pumpAndSettle();

      // Section headings
      expect(find.text('ESSENTIAL RANGE - OVER 20% OFF!'), findsOneWidget);
      expect(find.text('SIGNATURE RANGE'), findsOneWidget);
      expect(find.text('PORTSMOUTH CITY COLLECTION'), findsOneWidget);

      // Essential range products
      expect(
          find.text('Limited Edition Essential Zip Hoodies'), findsOneWidget);
      expect(find.text('Essential T-Shirt'), findsOneWidget);

      // Signature range products
      expect(find.text('Signiture Hoodie'), findsOneWidget);
      expect(find.text('Signiture T-Shirt'), findsOneWidget);

      // Portsmouth City collection products
      expect(find.text('Portsmouth City Postcard'), findsOneWidget);
      expect(find.text('Portsmouth City Magnet'), findsOneWidget);
      expect(find.text('Portsmouth City Bookmark'), findsOneWidget);
      expect(find.text('Portsmouth City Notebook'), findsOneWidget);
    });

    testWidgets('Portsmouth City collection asset images exist',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      await tester.pumpAndSettle();

      expect(
        find.image(
            const AssetImage('assets/images/PortsmouthCityPostcard.webp')),
        findsOneWidget,
      );
      expect(
        find.image(const AssetImage('assets/images/PortsmouthCityMagnet.jpg')),
        findsOneWidget,
      );
      expect(
        find.image(
            const AssetImage('assets/images/PortsmouthCityBookmark.jpg')),
        findsOneWidget,
      );
      expect(
        find.image(
            const AssetImage('assets/images/PortsmouthCityNotebook.webp')),
        findsOneWidget,
      );
    });
  });
}
