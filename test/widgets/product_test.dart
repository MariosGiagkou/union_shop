import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/product_page.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('Legacy Product Page Tests', () {
    testWidgets('ProductPage can be instantiated', (tester) async {
      const page = ProductPage();
      expect(page, isNotNull);
      expect(page, isA<StatefulWidget>());
    });

    testWidgets('ProductPage renders with providers', (tester) async {
      await pumpWithProviders(tester, const ProductPage());
      await tester.pump();

      // Verify page renders without error
      expect(find.byType(ProductPage), findsOneWidget);
    });
  });
}
