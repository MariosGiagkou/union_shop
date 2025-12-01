import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/home_page.dart';
import '../../helpers/test_helpers.dart';

void main() {
  testWidgets('essential + signature + category assets appear', (tester) async {
    await pumpWithProviders(tester, const HomePage());
    await tester.pumpAndSettle();

    expect(
      find.image(const AssetImage('assets/images/pink_hoodie.webp')),
      findsOneWidget,
    );
    expect(
      find.image(const AssetImage('assets/images/essential_t-shirt.webp')),
      findsOneWidget,
    );

    expect(
      find.image(const AssetImage('assets/images/signature_hoodie.webp')),
      findsOneWidget,
    );
    expect(
      find.image(const AssetImage('assets/images/signiture_t-shirt.webp')),
      findsWidgets, // allow duplicates after hero/layout changes
    );

    expect(
      find.image(const AssetImage('assets/images/PurpleHoodie.webp')),
      findsOneWidget,
    );
    expect(
      find.image(const AssetImage('assets/images/id.jpg')),
      findsOneWidget,
    );
    expect(
      find.image(const AssetImage('assets/images/GradGrey.webp')),
      findsOneWidget,
    );
    expect(
      find.image(const AssetImage('assets/images/notepad.webp')),
      findsOneWidget,
    );
  });

  testWidgets('total product/category cards count', (tester) async {
    await pumpWithProviders(tester, const HomePage());
    await tester.pumpAndSettle();
    // ProductCard + RangeCategoryCard instances
    final productCards = find.byType(ProductCard);
    final rangeCards = find.byType(RangeCategoryCard);
    expect(productCards, findsWidgets);
    expect(rangeCards, findsNWidgets(4));
  });
}
