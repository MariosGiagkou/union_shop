import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/collections_page.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import '../../helpers/test_helpers.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FakeFirebaseFirestore firestoreWithProducts;

  group('CollectionsPage - Loading State', () {
    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
    });

    testWidgets('shows loading indicator initially for signature category',
        (tester) async {
      await pumpWithProviders(
        tester,
        CollectionsPage(category: 'signature', firestore: fakeFirestore),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders collection grid when no category specified',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        CollectionsPage(firestore: fakeFirestore),
      );
      await tester.pumpAndSettle();

      expect(find.text('Collections'), findsOneWidget);
      expect(find.byType(GridView), findsWidgets);
    });
  });

  group('CollectionsPage - No Data State', () {
    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
    });

    testWidgets('shows no products message when collection is empty',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        CollectionsPage(category: 'signature', firestore: fakeFirestore),
      );
      await tester.pumpAndSettle();

      expect(find.text('No products found'), findsOneWidget);
    });
  });

  group('CollectionsPage - With Sale Products', () {
    setUp(() async {
      firestoreWithProducts = FakeFirebaseFirestore();
      await firestoreWithProducts.collection('products').doc('sale-item').set({
        'title': 'Sale Hoodie',
        'price': 45.99,
        'discountPrice': 30.99,
        'imageUrl': 'sale_hoodie.webp',
        'slug': 'sale-hoodie',
      });
    });

    testWidgets('displays sale products with discount', (tester) async {
      tester.view.physicalSize = const Size(1200, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        CollectionsPage(category: 'sale', firestore: firestoreWithProducts),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sale Hoodie'), findsOneWidget);
      expect(find.text('£30.99'), findsOneWidget);
    });

    testWidgets('shows product count', (tester) async {
      tester.view.physicalSize = const Size(1200, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        CollectionsPage(category: 'sale', firestore: firestoreWithProducts),
      );
      await tester.pumpAndSettle();

      expect(find.text('1 product'), findsOneWidget);
    });
  });

  group('CollectionsPage - With Merchandise Products', () {
    setUp(() async {
      firestoreWithProducts = FakeFirebaseFirestore();
      await firestoreWithProducts.collection('products').doc('merch1').set({
        'title': 'ID Card',
        'price': 5.99,
        'imageUrl': 'id.jpg',
        'slug': 'merch-id-card',
      });
    });

    testWidgets('displays merchandise products', (tester) async {
      tester.view.physicalSize = const Size(1200, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        CollectionsPage(
            category: 'merchandise', firestore: firestoreWithProducts),
      );
      await tester.pumpAndSettle();

      expect(find.text('ID Card'), findsOneWidget);
      expect(find.text('£5.99'), findsOneWidget);
    });
  });

  group('CollectionsPage - Filter and Sort Features', () {
    setUp(() async {
      firestoreWithProducts = FakeFirebaseFirestore();
      await firestoreWithProducts.collection('products').doc('sale-item').set({
        'title': 'Sale Hoodie',
        'price': 45.99,
        'discountPrice': 30.99,
        'imageUrl': 'sale_hoodie.webp',
        'slug': 'sale-hoodie',
      });
    });

    testWidgets('displays dropdown menus', (tester) async {
      tester.view.physicalSize = const Size(1200, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        CollectionsPage(category: 'sale', firestore: firestoreWithProducts),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DropdownButton<String>), findsWidgets);
      expect(find.text('All products'), findsWidgets);
      expect(find.text('Featured'), findsWidgets);
    });

    testWidgets('can open filter dropdown', (tester) async {
      tester.view.physicalSize = const Size(1200, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        CollectionsPage(category: 'sale', firestore: firestoreWithProducts),
      );
      await tester.pumpAndSettle();

      // Find and tap filter dropdown
      final filterDropdowns = find.byType(DropdownButton<String>);
      expect(filterDropdowns, findsWidgets);

      await tester.tap(filterDropdowns.first, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Dropdown menu should open
      expect(find.text('Merchandise').hitTestable(), findsWidgets);
      expect(find.text('Clothing').hitTestable(), findsWidgets);
    });
  });

  group('CollectionsPage - All Collections View', () {
    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
    });

    testWidgets('displays collection grid', (tester) async {
      tester.view.physicalSize = const Size(1200, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        CollectionsPage(firestore: fakeFirestore),
      );
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsWidgets);
    });

    testWidgets('collection tiles are tappable', (tester) async {
      tester.view.physicalSize = const Size(1200, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        CollectionsPage(firestore: fakeFirestore),
      );
      await tester.pumpAndSettle();

      final inkWells = find.byType(InkWell);
      expect(inkWells, findsWidgets);
    });

    testWidgets('displays collection images', (tester) async {
      tester.view.physicalSize = const Size(1200, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        CollectionsPage(firestore: fakeFirestore),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsWidgets);
    });
  });

  group('CollectionsPage - Responsive Design', () {
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
        CollectionsPage(firestore: fakeFirestore),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CollectionsPage), findsOneWidget);
    });

    testWidgets('renders correctly on desktop viewport', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        CollectionsPage(firestore: fakeFirestore),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CollectionsPage), findsOneWidget);
    });
  });

  group('CollectionsPage - Widget Structure', () {
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
        CollectionsPage(firestore: fakeFirestore),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsWidgets);
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('uses GridView for collection display', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        CollectionsPage(firestore: fakeFirestore),
      );
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsWidgets);
    });
  });
}
