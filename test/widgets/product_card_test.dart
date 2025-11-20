import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/home_page.dart'; // ProductCard lives here

void main() {
  testWidgets('ProductCard shows original (strikethrough) and sale price',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 250,
            child: ProductCard(
              title: 'Limited Edition Essential Zip Hoodies',
              originalPrice: '£20.00',
              price: '£14.99',
              imageUrl: 'https://example.com/image.jpg',
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final originalFinder = find.text('£20.00');
    final saleFinder = find.text('£14.99');

    expect(originalFinder, findsOneWidget);
    expect(saleFinder, findsOneWidget);

    final originalText = tester.widget<Text>(originalFinder);
    final saleText = tester.widget<Text>(saleFinder);

    expect(originalText.style?.decoration, TextDecoration.lineThrough);
    expect(originalText.style?.fontWeight, FontWeight.w600);
    expect(saleText.style?.fontWeight, FontWeight.w600);
  });

  testWidgets('ProductCard without original price only shows sale price',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 250,
            child: ProductCard(
              title: 'Placeholder Product 2',
              price: '£15.00',
              imageUrl: 'https://example.com/image2.jpg',
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('£15.00'), findsOneWidget);
    expect(find.text('£20.00'), findsNothing);
  });
}
