import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/home_page.dart';

void main() {
  group('ProductCard pricing', () {
    testWidgets('shows original and sale price with correct styles (asset)',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProductCard(
              title: 'Test Product',
              originalPrice: '£50.00',
              price: '£35.00',
              imageUrl: 'assets/images/pink_hoodie.webp',
              useAsset: true,
              customHeight: 100,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final originalFinder = find.text('£50.00');
      final saleFinder = find.text('£35.00');
      expect(originalFinder, findsOneWidget);
      expect(saleFinder, findsOneWidget);

      final originalText = tester.widget<Text>(originalFinder);
      final saleText = tester.widget<Text>(saleFinder);
      expect(originalText.style?.decoration, TextDecoration.lineThrough);
      expect(originalText.style?.fontWeight, FontWeight.w600);
      expect(saleText.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('shows original and sale price with correct styles (network)',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProductCard(
              title: 'Network Product',
              originalPrice: '£20.00',
              price: '£15.00',
              imageUrl: 'https://example.com/image.jpg',
              customHeight: 100,
            ),
          ),
        ),
      );
      await tester.pump(); // initial frame
      await tester
          .pump(const Duration(milliseconds: 150)); // allow loadingBuilder
      final originalFinder = find.text('£20.00');
      final saleFinder = find.text('£15.00');
      expect(originalFinder, findsOneWidget);
      expect(saleFinder, findsOneWidget);
    });

    testWidgets('without original price only shows current price',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProductCard(
              title: 'No Sale Product',
              price: '£12.00',
              imageUrl: 'https://example.com/image.jpg',
              customHeight: 100,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('£12.00'), findsOneWidget);
      expect(find.text('£50.00'), findsNothing);
    });
  });
}
