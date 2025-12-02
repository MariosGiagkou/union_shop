import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/collections_page.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('CollectionsPage (views) - UI Structure Tests', () {
    testWidgets('CollectionsPage shows "Collections" title',
        (WidgetTester tester) async {
      await pumpWithProviders(tester, const CollectionsPage());

      expect(find.text('Collections'), findsOneWidget);
    });

    testWidgets('CollectionsPage displays collection grid',
        (WidgetTester tester) async {
      await pumpWithProviders(tester, const CollectionsPage());

      expect(find.byType(GridView), findsWidgets);
    });

    testWidgets('CollectionsPage has images for collections',
        (WidgetTester tester) async {
      await pumpWithProviders(tester, const CollectionsPage());

      expect(find.byType(Image), findsWidgets);
    });
  });
}
