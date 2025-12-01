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

      // Check for page title
      expect(find.text('Search Products'), findsOneWidget);
    });

    testWidgets('displays empty state message', (tester) async {
      await pumpWithProviders(
        tester,
        const SearchPage(),
      );
      await tester.pumpAndSettle();

      // Check for empty state message
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

      // Check for search button
      expect(find.text('Search'), findsOneWidget);
    });
  });

  group('SearchPage - Layout', () {
    testWidgets('has constrained layout', (tester) async {
      await pumpWithProviders(
        tester,
        const SearchPage(),
      );
      await tester.pumpAndSettle();

      // Check for ConstrainedBox
      expect(find.byType(ConstrainedBox), findsWidgets);
    });

    testWidgets('uses SingleChildScrollView', (tester) async {
      await pumpWithProviders(
        tester,
        const SearchPage(),
      );
      await tester.pumpAndSettle();

      // Check for scrollable view
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('has proper spacing', (tester) async {
      await pumpWithProviders(
        tester,
        const SearchPage(),
      );
      await tester.pumpAndSettle();

      // Check for SizedBox spacing
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('uses Scaffold', (tester) async {
      await pumpWithProviders(
        tester,
        const SearchPage(),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });

  group('SearchPage - Responsive Design', () {
    testWidgets('renders on mobile screen', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        const SearchPage(),
      );
      await tester.pumpAndSettle();

      expect(find.text('Search Products'), findsOneWidget);
    });

    testWidgets('renders on tablet screen', (tester) async {
      tester.view.physicalSize = const Size(800, 1024);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        const SearchPage(),
      );
      await tester.pumpAndSettle();

      expect(find.text('Search Products'), findsOneWidget);
    });

    testWidgets('renders on desktop screen', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        const SearchPage(),
      );
      await tester.pumpAndSettle();

      expect(find.text('Search Products'), findsOneWidget);
    });
  });

  group('SearchPage - Styling', () {
    testWidgets('page title has correct styling', (tester) async {
      await pumpWithProviders(
        tester,
        const SearchPage(),
      );
      await tester.pumpAndSettle();

      final titleFinder = find.text('Search Products');
      expect(titleFinder, findsOneWidget);

      final titleWidget = tester.widget<Text>(titleFinder);
      expect(titleWidget.style?.fontSize, equals(34));
      expect(titleWidget.style?.fontWeight, equals(FontWeight.w700));
      expect(titleWidget.style?.color, equals(Colors.black));
    });

    testWidgets('empty state has proper styling', (tester) async {
      await pumpWithProviders(
        tester,
        const SearchPage(),
      );
      await tester.pumpAndSettle();

      final emptyStateFinder =
          find.text('Enter a search term and click Search to find products');
      expect(emptyStateFinder, findsOneWidget);

      final emptyStateText = tester.widget<Text>(emptyStateFinder);
      expect(emptyStateText.style?.fontSize, equals(16));
      expect(emptyStateText.style?.color, equals(Colors.grey));
    });
  });

  group('SearchPage - Widget Types', () {
    testWidgets('is a StatefulWidget', (tester) async {
      const page = SearchPage();
      expect(page, isA<StatefulWidget>());
    });

    testWidgets('can be instantiated', (tester) async {
      const page = SearchPage();
      expect(page, isNotNull);
    });

    testWidgets('has proper widget hierarchy', (tester) async {
      await pumpWithProviders(
        tester,
        const SearchPage(),
      );
      await tester.pumpAndSettle();

      // Verify key widgets exist in hierarchy
      expect(find.byType(SearchPage), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
    });
  });
}
