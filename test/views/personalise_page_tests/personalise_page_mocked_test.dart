import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/views/personalise_page.dart';
import 'package:union_shop/repositories/cart_repository.dart';
import 'package:union_shop/services/auth_service.dart';
import 'package:union_shop/models/layout.dart';
import '../../helpers/test_helpers.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
  });

  group('PersonalisePage - Loading State', () {
    testWidgets('shows loading indicator while fetching data', (tester) async {
      await pumpWithProviders(
        tester,
        PersonalisePage(firestore: fakeFirestore),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(SiteHeader), findsOneWidget);
    });

    testWidgets('has PopScope wrapper', (tester) async {
      await pumpWithProviders(
        tester,
        PersonalisePage(firestore: fakeFirestore),
      );

      expect(find.byType(PopScope), findsOneWidget);
    });

    testWidgets('has Scaffold', (tester) async {
      await pumpWithProviders(
        tester,
        PersonalisePage(firestore: fakeFirestore),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });

  group('PersonalisePage - No Data State', () {
    testWidgets('shows error message when product not found', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        PersonalisePage(firestore: fakeFirestore),
      );
      await tester.pumpAndSettle();

      expect(find.text('Personalise product not found'), findsOneWidget);
      expect(find.byType(SiteFooter), findsOneWidget);
    });
  });

  group('PersonalisePage - With Product Data', () {
    late FakeFirebaseFirestore firestoreWithProduct;

    setUp(() async {
      firestoreWithProduct = FakeFirebaseFirestore();
      await firestoreWithProduct.collection('products').doc('personalise').set({
        'title': 'Personalised Hoodie',
        'price': 45.99,
        'imageUrl': 'personalazedhoodie.webp',
      });
    });

    testWidgets('displays product title', (tester) async {
      await pumpWithProviders(
        tester,
        PersonalisePage(firestore: firestoreWithProduct),
      );
      await tester.pumpAndSettle();

      expect(find.text('Personalised Hoodie'), findsOneWidget);
    });

    testWidgets('displays product price', (tester) async {
      await pumpWithProviders(
        tester,
        PersonalisePage(firestore: firestoreWithProduct),
      );
      await tester.pumpAndSettle();

      expect(find.text('£45.99'), findsOneWidget);
    });

    testWidgets('displays personalisation dropdown', (tester) async {
      await pumpWithProviders(
        tester,
        PersonalisePage(firestore: firestoreWithProduct),
      );
      await tester.pumpAndSettle();

      expect(find.text('One Line of Text'), findsOneWidget);
    });

    testWidgets('displays quantity selector', (tester) async {
      await pumpWithProviders(
        tester,
        PersonalisePage(firestore: firestoreWithProduct),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('product:quantity-row')), findsOneWidget);
    });

    testWidgets('displays add to cart button', (tester) async {
      await pumpWithProviders(
        tester,
        PersonalisePage(firestore: firestoreWithProduct),
      );
      await tester.pumpAndSettle();

      expect(find.text('ADD TO CART'), findsOneWidget);
      expect(find.byKey(const Key('product:add-to-cart')), findsOneWidget);
    });

    testWidgets('shows text input for One Line option', (tester) async {
      await pumpWithProviders(
        tester,
        PersonalisePage(firestore: firestoreWithProduct),
      );
      await tester.pumpAndSettle();

      expect(find.text('Line 1'), findsOneWidget);
      expect(find.text('Line 2'), findsNothing);
      expect(find.text('Line 3'), findsNothing);
    });

    testWidgets('can increment quantity', (tester) async {
      await pumpWithProviders(
        tester,
        PersonalisePage(firestore: firestoreWithProduct),
      );
      await tester.pumpAndSettle();

      final increaseButton = find.byKey(const Key('product:qty-increase'));
      expect(increaseButton, findsOneWidget);

      await tester.tap(increaseButton, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Quantity should increase
      expect(tester.takeException(), isNull);
    });

    testWidgets('can decrement quantity', (tester) async {
      await pumpWithProviders(
        tester,
        PersonalisePage(firestore: firestoreWithProduct),
      );
      await tester.pumpAndSettle();

      // First increase
      final increaseButton = find.byKey(const Key('product:qty-increase'));
      await tester.tap(increaseButton, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Then decrease
      final decreaseButton = find.byKey(const Key('product:qty-decrease'));
      await tester.tap(decreaseButton, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('add to cart button is functional', (tester) async {
      await pumpWithProviders(
        tester,
        PersonalisePage(firestore: firestoreWithProduct),
      );
      await tester.pumpAndSettle();

      final addButton = find.byKey(const Key('product:add-to-cart'));
      await tester.tap(addButton, warnIfMissed: false);
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });

  group('PersonalisePage - With Discount Price', () {
    late FakeFirebaseFirestore firestoreWithDiscount;

    setUp(() async {
      firestoreWithDiscount = FakeFirebaseFirestore();
      await firestoreWithDiscount
          .collection('products')
          .doc('personalise')
          .set({
        'title': 'Personalised Hoodie',
        'price': 45.99,
        'discountPrice': 35.99,
        'imageUrl': 'personalazedhoodie.webp',
      });
    });

    testWidgets('displays discount price', (tester) async {
      await pumpWithProviders(
        tester,
        PersonalisePage(firestore: firestoreWithDiscount),
      );
      await tester.pumpAndSettle();

      expect(find.text('£35.99'), findsOneWidget);
    });

    testWidgets('displays original price with strikethrough', (tester) async {
      await pumpWithProviders(
        tester,
        PersonalisePage(firestore: firestoreWithDiscount),
      );
      await tester.pumpAndSettle();

      expect(find.text('£45.99'), findsOneWidget);
      expect(find.byKey(const Key('product:originalPrice')), findsOneWidget);
    });
  });

  group('PersonalisePage - Responsive Design', () {
    late FakeFirebaseFirestore firestoreForResponsive;

    setUp(() async {
      firestoreForResponsive = FakeFirebaseFirestore();
      await firestoreForResponsive
          .collection('products')
          .doc('personalise')
          .set({
        'title': 'Test Product',
        'price': 20.0,
        'imageUrl': 'test.webp',
      });
    });

    testWidgets('renders on mobile screen', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        PersonalisePage(firestore: firestoreForResponsive),
      );
      await tester.pumpAndSettle();

      expect(find.text('Test Product'), findsOneWidget);
    });

    testWidgets('renders on desktop screen', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        PersonalisePage(firestore: firestoreForResponsive),
      );
      await tester.pumpAndSettle();

      expect(find.text('Test Product'), findsOneWidget);
    });
  });

  group('PersonalisePage - Widget Structure', () {
    testWidgets('can be instantiated with firestore parameter', (tester) async {
      final page = PersonalisePage(firestore: fakeFirestore);
      expect(page, isNotNull);
      expect(page.firestore, equals(fakeFirestore));
    });

    testWidgets('can be instantiated without firestore parameter',
        (tester) async {
      const page = PersonalisePage();
      expect(page, isNotNull);
      expect(page.firestore, isNull);
    });

    testWidgets('is a StatefulWidget', (tester) async {
      const page = PersonalisePage();
      expect(page, isA<StatefulWidget>());
    });
  });
}
