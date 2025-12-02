import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/search_page.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('SearchPage - Basic Structure', () {
    testWidgets('displays search page with title', (tester) async {
      await pumpWithProviders(
        tester,
        const SearchPage(),
      );
      await tester.pumpAndSettle();

      expect(find.text('Search Products'), findsOneWidget);
    });

    testWidgets('displays empty state message', (tester) async {
      await pumpWithProviders(
        tester,
        const SearchPage(),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Enter a search term and click Search to find products'),
        findsOneWidget,
      );
    });

    testWidgets('displays search button', (tester) async {
      await pumpWithProviders(
        tester,
        const SearchPage(),
      );
      await tester.pumpAndSettle();

      expect(find.text('Search'), findsOneWidget);
    });
  });
}
