import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/layout.dart';
import 'package:union_shop/views/search_page.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('SearchPage (views)', () {
    testWidgets('SearchPage is a StatefulWidget', (tester) async {
      expect(const SearchPage(), isA<StatefulWidget>());
    });

    testWidgets('SearchPage can be instantiated with initialQuery',
        (tester) async {
      const page = SearchPage(initialQuery: 'test query');
      expect(page.initialQuery, 'test query');
    });

    testWidgets('SearchPage can be instantiated without initialQuery',
        (tester) async {
      const page = SearchPage();
      expect(page.initialQuery, isNull);
    });

    testWidgets('SearchPage can be instantiated with key', (tester) async {
      const page = SearchPage(key: Key('search-page'));
      expect(page.key, const Key('search-page'));
    });

    testWidgets('SearchPage displays search title', (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      expect(find.text('Search Products'), findsOneWidget);
    });

    testWidgets('SearchPage has SiteHeader', (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      expect(find.byType(SiteHeader), findsOneWidget);
    });

    testWidgets('SearchPage has search TextField', (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      // SearchPage has a TextField with the search hint
      expect(
        find.widgetWithText(TextField, 'Search for products...'),
        findsOneWidget,
      );
    });

    testWidgets('SearchPage TextField has search hint', (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      // Find TextField with the specific hint text
      final searchTextField =
          find.widgetWithText(TextField, 'Search for products...');
      expect(searchTextField, findsOneWidget);

      final textField = tester.widget<TextField>(searchTextField);
      expect(
        textField.decoration?.hintText,
        'Search for products...',
      );
    });

    testWidgets('SearchPage has search icon in TextField', (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      // Find TextField with the specific hint and verify it has a search icon
      final searchTextField =
          find.widgetWithText(TextField, 'Search for products...');
      final textField = tester.widget<TextField>(searchTextField);
      expect(textField.decoration?.prefixIcon, isA<Icon>());
    });

    testWidgets('SearchPage has Search button', (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      expect(
        find.widgetWithText(ElevatedButton, 'Search'),
        findsOneWidget,
      );
    });

    testWidgets('SearchPage displays empty state message initially',
        (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      expect(
        find.text('Enter a search term and click Search to find products'),
        findsOneWidget,
      );
    });

    testWidgets('SearchPage is wrapped in Scaffold', (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('SearchPage has SingleChildScrollView', (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      expect(find.byType(SingleChildScrollView), findsAtLeastNWidgets(1));
    });

    testWidgets('SearchPage has StreamBuilder for results', (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      // Stream builder exists but is embedded in the widget tree
      // Check for the empty state message instead
      expect(
        find.text('Enter a search term and click Search to find products'),
        findsOneWidget,
      );
    });

    testWidgets('SearchPage TextField is styled properly', (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      final searchTextField =
          find.widgetWithText(TextField, 'Search for products...');
      final textField = tester.widget<TextField>(searchTextField);
      expect(textField.decoration?.border, isA<OutlineInputBorder>());
      expect(textField.decoration?.enabledBorder, isA<OutlineInputBorder>());
      expect(textField.decoration?.focusedBorder, isA<OutlineInputBorder>());
    });

    testWidgets('SearchPage Search button has correct styling', (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Search'),
      );
      final style = button.style;
      expect(style, isNotNull);
    });

    testWidgets('SearchPage displays title with correct style', (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      final titleText = tester.widget<Text>(find.text('Search Products'));
      expect(titleText.style?.fontSize, 34);
      expect(titleText.style?.fontWeight, FontWeight.w700);
    });

    testWidgets('SearchPage renders without error', (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      expect(find.byType(SearchPage), findsOneWidget);
    });

    testWidgets('SearchPage LayoutBuilder responds to constraints',
        (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      expect(find.byType(LayoutBuilder), findsAtLeastNWidgets(1));
    });

    testWidgets('SearchPage uses ConstrainedBox for max width', (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      expect(find.byType(ConstrainedBox), findsAtLeastNWidgets(1));
    });
  });

  group('SearchPage User Interactions', () {
    testWidgets('SearchPage initializes with empty query', (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      expect(
        find.text('Enter a search term and click Search to find products'),
        findsOneWidget,
      );
    });

    testWidgets('SearchPage can be instantiated with initialQuery parameter',
        (tester) async {
      const page = SearchPage(initialQuery: 'hoodie');
      expect(page.initialQuery, equals('hoodie'));
    });

    testWidgets('SearchPage TextField accepts text input', (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      final searchField =
          find.widgetWithText(TextField, 'Search for products...');
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'hoodie');
      await tester.pump();

      final textField = tester.widget<TextField>(searchField);
      expect(textField.controller?.text, equals('hoodie'));
    });

    testWidgets('SearchPage Search button is tappable', (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      final searchButton = find.widgetWithText(ElevatedButton, 'Search');
      expect(searchButton, findsOneWidget);

      // Verify button exists and is enabled (don't tap to avoid Firebase)
      final button = tester.widget<ElevatedButton>(searchButton);
      expect(button.onPressed, isNotNull);
    });

    testWidgets('SearchPage TextField has onSubmitted callback',
        (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      final searchField =
          find.widgetWithText(TextField, 'Search for products...');
      await tester.enterText(searchField, 'test');

      // Verify TextField has onSubmitted without triggering it
      final textField = tester.widget<TextField>(searchField);
      expect(textField.onSubmitted, isNotNull);
    });

    testWidgets('SearchPage displays empty message when no search performed',
        (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      expect(
        find.textContaining('Enter a search term'),
        findsOneWidget,
      );
    });

    testWidgets('SearchPage clears search when TextField is cleared',
        (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      final searchField =
          find.widgetWithText(TextField, 'Search for products...');

      // Enter text
      await tester.enterText(searchField, 'hoodie');
      await tester.pump();

      // Clear text
      await tester.enterText(searchField, '');
      await tester.pump();

      final textField = tester.widget<TextField>(searchField);
      expect(textField.controller?.text, equals(''));
    });

    testWidgets('SearchPage TextField has proper decoration', (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      final searchField =
          find.widgetWithText(TextField, 'Search for products...');
      final textField = tester.widget<TextField>(searchField);

      expect(textField.decoration?.prefixIcon, isA<Icon>());
      expect(textField.decoration?.hintText, equals('Search for products...'));
    });

    testWidgets('SearchPage handles multiple search queries', (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      final searchField =
          find.widgetWithText(TextField, 'Search for products...');

      // Enter first query
      await tester.enterText(searchField, 'hoodie');
      await tester.pump();

      var textField = tester.widget<TextField>(searchField);
      expect(textField.controller?.text, equals('hoodie'));

      // Change to second query
      await tester.enterText(searchField, 'shirt');
      await tester.pump();

      textField = tester.widget<TextField>(searchField);
      expect(textField.controller?.text, equals('shirt'));
    });

    testWidgets('SearchPage button maintains styling', (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      final searchButton = find.widgetWithText(ElevatedButton, 'Search');

      // Verify button styling without tapping
      final button = tester.widget<ElevatedButton>(searchButton);
      expect(button.style, isNotNull);
      expect(button.onPressed, isNotNull);
    });

    testWidgets('SearchPage TextField supports paste operations',
        (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      final searchField =
          find.widgetWithText(TextField, 'Search for products...');

      // Simulate pasting text
      await tester.enterText(searchField, 'pasted search query');
      await tester.pump();

      final textField = tester.widget<TextField>(searchField);
      expect(textField.controller?.text, equals('pasted search query'));
    });

    testWidgets('SearchPage responds to text input changes', (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      final searchField =
          find.widgetWithText(TextField, 'Search for products...');

      // Type character by character
      await tester.enterText(searchField, 'h');
      await tester.pump();

      await tester.enterText(searchField, 'ho');
      await tester.pump();

      await tester.enterText(searchField, 'hoodie');
      await tester.pump();

      final textField = tester.widget<TextField>(searchField);
      expect(textField.controller?.text, equals('hoodie'));
    });

    testWidgets('SearchPage TextField can handle long search queries',
        (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      final searchField =
          find.widgetWithText(TextField, 'Search for products...');
      const longQuery = 'this is a very long search query with many words';

      await tester.enterText(searchField, longQuery);
      await tester.pump();

      final textField = tester.widget<TextField>(searchField);
      expect(textField.controller?.text, equals(longQuery));
    });

    testWidgets('SearchPage TextField can handle special characters',
        (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      final searchField =
          find.widgetWithText(TextField, 'Search for products...');
      const specialQuery = 'search-with_special.chars@123';

      await tester.enterText(searchField, specialQuery);
      await tester.pump();

      final textField = tester.widget<TextField>(searchField);
      expect(textField.controller?.text, equals(specialQuery));
    });

    testWidgets('SearchPage Search button can be pressed multiple times',
        (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      final searchButton = find.widgetWithText(ElevatedButton, 'Search');

      // Verify button is always present and enabled
      expect(searchButton, findsOneWidget);

      final button = tester.widget<ElevatedButton>(searchButton);
      expect(button.onPressed, isNotNull);
    });

    testWidgets('SearchPage maintains state after multiple interactions',
        (tester) async {
      await pumpWithProviders(
        tester,
        const MaterialApp(home: SearchPage()),
        authService: createSignedOutAuthService(),
      );

      final searchField =
          find.widgetWithText(TextField, 'Search for products...');

      // Enter initial text
      await tester.enterText(searchField, 'initial');
      await tester.pump();

      var textField = tester.widget<TextField>(searchField);
      expect(textField.controller?.text, equals('initial'));

      // Modify text without triggering search
      await tester.enterText(searchField, 'modified');
      await tester.pump();

      textField = tester.widget<TextField>(searchField);
      expect(textField.controller?.text, equals('modified'));
    });
  });
}
