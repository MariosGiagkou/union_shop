import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/search_page.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import '../../helpers/test_helpers.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FakeFirebaseFirestore firestoreWithProducts;

  group('SearchPage - Initial State', () {
    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
    });

    testWidgets('displays search page title', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        SearchPage(firestore: fakeFirestore),
      );
      await tester.pumpAndSettle();

      expect(find.text('Search Products'), findsOneWidget);
    });

    testWidgets('displays empty state message', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        SearchPage(firestore: fakeFirestore),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Enter a search term and click Search to find products'),
        findsOneWidget,
      );
    });

    testWidgets('displays search input field', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        SearchPage(firestore: fakeFirestore),
      );
      await tester.pumpAndSettle();

      expect(find.text('Search for products...'), findsOneWidget);
    });

    testWidgets('displays search button', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        SearchPage(firestore: fakeFirestore),
      );
      await tester.pumpAndSettle();

      expect(find.text('Search'), findsWidgets);
    });
  });

  group('SearchPage - With Initial Query', () {
    setUp(() async {
      firestoreWithProducts = FakeFirebaseFirestore();
      await firestoreWithProducts.collection('products').doc('hoodie1').set({
        'title': 'Classic Hoodie',
        'price': 35.99,
        'imageUrl': 'classic_hoodie.webp',
        'cat': 'cloth',
      });
    });

    testWidgets('pre-fills search field with initial query', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        SearchPage(
          initialQuery: 'hoodie',
          firestore: firestoreWithProducts,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('hoodie'), findsOneWidget);
    });

    testWidgets('automatically searches with initial query', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        SearchPage(
          initialQuery: 'hoodie',
          firestore: firestoreWithProducts,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Classic Hoodie'), findsOneWidget);
    });
  });

  group('SearchPage - Search Functionality', () {
    setUp(() async {
      firestoreWithProducts = FakeFirebaseFirestore();
      await firestoreWithProducts.collection('products').doc('hoodie1').set({
        'title': 'Classic Hoodie',
        'price': 35.99,
        'imageUrl': 'classic_hoodie.webp',
        'cat': 'cloth',
      });
      await firestoreWithProducts.collection('products').doc('tshirt1').set({
        'title': 'Essential T-Shirt',
        'price': 20.99,
        'imageUrl': 'essential_t-shirt.webp',
        'cat': 'cloth',
      });
      await firestoreWithProducts.collection('products').doc('notebook1').set({
        'title': 'Notebook',
        'price': 5.99,
        'imageUrl': 'notepad.webp',
        'cat': 'prod',
      });
    });

    testWidgets('can enter search query', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        SearchPage(firestore: firestoreWithProducts),
      );
      await tester.pumpAndSettle();

      final textField =
          find.widgetWithText(TextField, 'Search for products...');
      await tester.enterText(textField, 'hoodie');

      expect(find.text('hoodie'), findsOneWidget);
    });

    testWidgets('displays search results after clicking search',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        SearchPage(firestore: firestoreWithProducts),
      );
      await tester.pumpAndSettle();

      // Enter search query
      final textField =
          find.widgetWithText(TextField, 'Search for products...');
      await tester.enterText(textField, 'hoodie');
      await tester.pumpAndSettle();

      // Click search button
      final searchButton = find.text('Search').last;
      await tester.tap(searchButton, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Should find the hoodie
      expect(find.text('Classic Hoodie'), findsOneWidget);
    });

    testWidgets('displays no results message when search yields nothing',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        SearchPage(firestore: firestoreWithProducts),
      );
      await tester.pumpAndSettle();

      // Enter search query that won't match
      final textField =
          find.widgetWithText(TextField, 'Search for products...');
      await tester.enterText(textField, 'nonexistent');
      await tester.pumpAndSettle();

      // Click search button
      final searchButton = find.text('Search').last;
      await tester.tap(searchButton, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Should show no results message
      expect(find.text('No products found for "nonexistent"'), findsOneWidget);
    });

    testWidgets('displays search results for category search', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        SearchPage(firestore: firestoreWithProducts),
      );
      await tester.pumpAndSettle();

      // Enter search query for category
      final textField =
          find.widgetWithText(TextField, 'Search for products...');
      await tester.enterText(textField, 'cloth');
      await tester.pumpAndSettle();

      // Click search button
      final searchButton = find.text('Search').last;
      await tester.tap(searchButton, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Should find clothing items
      expect(find.text('Classic Hoodie'), findsOneWidget);
      expect(find.text('Essential T-Shirt'), findsOneWidget);
    });

    testWidgets('displays product prices in results', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        SearchPage(firestore: firestoreWithProducts),
      );
      await tester.pumpAndSettle();

      // Enter search query
      final textField =
          find.widgetWithText(TextField, 'Search for products...');
      await tester.enterText(textField, 'hoodie');
      await tester.pumpAndSettle();

      // Click search button
      final searchButton = find.text('Search').last;
      await tester.tap(searchButton, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Should show price
      expect(find.text('£35.99'), findsOneWidget);
    });

    testWidgets('can search by price', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        SearchPage(firestore: firestoreWithProducts),
      );
      await tester.pumpAndSettle();

      // Search by price
      final textField =
          find.widgetWithText(TextField, 'Search for products...');
      await tester.enterText(textField, '5.99');
      await tester.pumpAndSettle();

      final searchButton = find.text('Search').last;
      await tester.tap(searchButton, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Should find the notebook
      expect(find.text('Notebook'), findsOneWidget);
    });
  });

  group('SearchPage - Responsive Design', () {
    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
    });

    testWidgets('renders correctly on mobile viewport', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        SearchPage(firestore: fakeFirestore),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SearchPage), findsOneWidget);
    });

    testWidgets('renders correctly on desktop viewport', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        SearchPage(firestore: fakeFirestore),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SearchPage), findsOneWidget);
    });
  });

  group('SearchPage - Widget Structure', () {
    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
    });

    testWidgets('has expected widget hierarchy', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        SearchPage(firestore: fakeFirestore),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsWidgets);
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('has constrained layout', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        SearchPage(firestore: fakeFirestore),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ConstrainedBox), findsWidgets);
    });
  });
}
