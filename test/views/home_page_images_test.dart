import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/home_page.dart';

void main() {
  testWidgets('essential range images appear', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();

    expect(
      find.image(const AssetImage('assets/images/pink_hoodie.webp')),
      findsOneWidget,
    );
    expect(
      find.image(const AssetImage('assets/images/essential_t-shirt.webp')),
      findsOneWidget,
    );
  });

  testWidgets('signature range images appear', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();

    // Two network product images
    expect(
      find.image(const NetworkImage(
        'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
      )),
      findsNWidgets(2),
    );
  });

  testWidgets('total product cards count is 4', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();
    expect(find.byType(ProductCard), findsNWidgets(4));
  });
}
