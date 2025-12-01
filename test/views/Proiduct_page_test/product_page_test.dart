import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/services/auth_service.dart';
import 'package:union_shop/repositories/cart_repository.dart';
import 'package:union_shop/views/product_page.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('ProductPage (views)', () {
    testWidgets('renders core elements and keys by default', (tester) async {
      await pumpWithProviders(tester, const ProductPage());
      await tester.pump();

      expect(find.byKey(const Key('product:image')), findsOneWidget);
      expect(find.byKey(const Key('product:title')), findsOneWidget);
      expect(find.byKey(const Key('product:price')), findsOneWidget);
      expect(find.byKey(const Key('product:add-to-cart')), findsOneWidget);
      // Defaults
      expect(find.text('Product'), findsOneWidget);
      expect(find.text('—'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(
        find.text(
          'This is a placeholder description for the product. Students should replace this with real product information and implement proper data management.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows original price when provided', (tester) async {
      await pumpWithProviders(
          tester,
          const ProductPage(
            titleOverride: 'Tee',
            priceOverride: '£20.00',
            discountPriceOverride: '£15.00',
          ));
      await tester.pump();

      expect(find.text('Tee'), findsOneWidget);
      // discounted price should be shown as the main price, original shown struck-through
      expect(find.text('£15.00'), findsOneWidget);
      expect(find.byKey(const Key('product:originalPrice')), findsOneWidget);
      expect(find.text('£20.00'), findsOneWidget);
    });

    testWidgets('omits original price when not provided', (tester) async {
      await pumpWithProviders(
          tester,
          const ProductPage(
            titleOverride: 'Hoodie',
            priceOverride: '£30.00',
          ));
      await tester.pump();

      expect(find.text('Hoodie'), findsOneWidget);
      expect(find.text('£30.00'), findsOneWidget);
      expect(find.byKey(const Key('product:originalPrice')), findsNothing);
    });

    testWidgets('resolves route arguments for title/price/image',
        (tester) async {
      final args = <String, dynamic>{
        'title': 'Route Product',
        'price': '£9.99',
        'imageUrl': 'assets/images/fidget.avif',
        'useAsset': true,
      };

      final authService = createSignedOutAuthService();
      final cartRepository = createCartWithItems();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthService>.value(value: authService),
            ChangeNotifierProvider<CartRepository>.value(value: cartRepository),
          ],
          child: MaterialApp(
            routes: {
              '/product': (_) => const ProductPage(),
            },
            home: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/product', arguments: args),
                child: const Text('GO'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('GO'));
      await tester.pumpAndSettle();

      expect(find.text('Route Product'), findsOneWidget);
      expect(find.text('£9.99'), findsOneWidget);
      expect(find.byKey(const Key('product:image')), findsOneWidget);
    });

    testWidgets('wide layout places content in a Row', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      addTearDown(() async => tester.binding.setSurfaceSize(null));

      await pumpWithProviders(
          tester,
          const ProductPage(
            titleOverride: 'Wide',
            priceOverride: '£1.00',
            imageUrlOverride: 'assets/images/fidget.avif',
          ));
      await tester.pump();

      // Title should have a Row ancestor from the two-column layout
      expect(
        find.ancestor(
          of: find.byKey(const Key('product:title')),
          matching: find.byType(Row),
        ),
        findsOneWidget,
      );
      // Image should also participate in the Row
      expect(
        find.ancestor(
          of: find.byKey(const Key('product:image')),
          matching: find.byType(Row),
        ),
        findsOneWidget,
      );
    });

    testWidgets('narrow layout stacks content in a Column', (tester) async {
      // Use a slightly wider "narrow" width to avoid header/footer overflows
      await tester.binding.setSurfaceSize(const Size(780, 1200));
      addTearDown(() async => tester.binding.setSurfaceSize(null));

      await pumpWithProviders(
          tester,
          const ProductPage(
            titleOverride: 'Narrow',
            priceOverride: '£2.00',
            imageUrlOverride: 'assets/images/fidget.avif',
          ));
      await tester.pumpAndSettle();

      // Title should NOT have the outer Row ancestor in narrow mode
      expect(
        find.ancestor(
          of: find.byKey(const Key('product:title')),
          matching: find.byType(Row),
        ),
        findsNothing,
      );
    });

    testWidgets('add to cart button is tappable (no crash)', (tester) async {
      await pumpWithProviders(tester, const ProductPage());
      await tester.pump();

      await tester.tap(find.byKey(const Key('product:add-to-cart')));
      await tester.pump();

      // No exceptions should be thrown by the placeholder handler
      expect(tester.takeException(), isNull);
    });

    testWidgets('header and footer basic presence', (tester) async {
      await pumpWithProviders(tester, const ProductPage());
      await tester.pump();

      // Sale banner text from SiteHeader
      expect(
        find.text(
          'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF! COME GRAB YOURS WHILE STOCK LASTS!',
        ),
        findsOneWidget,
      );
      // Footer section headings
      expect(find.text('Opening Hours'), findsOneWidget);
      expect(find.text('Help and Information'), findsOneWidget);
      expect(find.text('Latest Offers'), findsOneWidget);
    });

    testWidgets('quantity input is present with inline arrows', (tester) async {
      await pumpWithProviders(tester, const ProductPage());
      await tester.pump();

      expect(find.byKey(const Key('product:quantity-input')), findsOneWidget);
      expect(find.byKey(const Key('product:qty-increase')), findsOneWidget);
      expect(find.byKey(const Key('product:qty-decrease')), findsOneWidget);

      final tf = tester
          .widget<TextField>(find.byKey(const Key('product:quantity-input')));
      expect(tf.controller!.text, '1');
    });

    testWidgets('typing a valid quantity updates the input', (tester) async {
      await pumpWithProviders(tester, const ProductPage());
      await tester.pump();

      await tester.enterText(
          find.byKey(const Key('product:quantity-input')), '5');
      await tester.pump();

      final tf = tester
          .widget<TextField>(find.byKey(const Key('product:quantity-input')));
      expect(tf.controller!.text, '5');
    });

    testWidgets('invalid input resets to minimum 1', (tester) async {
      await pumpWithProviders(tester, const ProductPage());
      await tester.pump();

      await tester.enterText(
          find.byKey(const Key('product:quantity-input')), '');
      await tester.pump();

      var tf = tester
          .widget<TextField>(find.byKey(const Key('product:quantity-input')));
      expect(tf.controller!.text, '1');

      await tester.enterText(
          find.byKey(const Key('product:quantity-input')), '0');
      await tester.pump();

      tf = tester
          .widget<TextField>(find.byKey(const Key('product:quantity-input')));
      expect(tf.controller!.text, '1');
    });

    testWidgets('arrow increase increments quantity', (tester) async {
      await pumpWithProviders(tester, const ProductPage());
      await tester.pump();

      await tester.tap(find.byKey(const Key('product:qty-increase')));
      await tester.pump();

      final tf = tester
          .widget<TextField>(find.byKey(const Key('product:quantity-input')));
      expect(tf.controller!.text, '2');
    });

    testWidgets('arrow decrease decrements but not below 1', (tester) async {
      await pumpWithProviders(tester, const ProductPage());
      await tester.pump();

      // Try to go below 1
      await tester.tap(find.byKey(const Key('product:qty-decrease')));
      await tester.pump();

      var tf = tester
          .widget<TextField>(find.byKey(const Key('product:quantity-input')));
      expect(tf.controller!.text, '1');

      // Set to 3 and then decrease to 2
      await tester.enterText(
          find.byKey(const Key('product:quantity-input')), '3');
      await tester.pump();
      await tester.tap(find.byKey(const Key('product:qty-decrease')));
      await tester.pump();

      tf = tester
          .widget<TextField>(find.byKey(const Key('product:quantity-input')));
      expect(tf.controller!.text, '2');
    });

    testWidgets('clothing options are hidden for non-clothing titles',
        (tester) async {
      await pumpWithProviders(
          tester,
          const ProductPage(
            titleOverride: 'Mug',
            priceOverride: '£5.00',
          ));
      await tester.pump();

      expect(find.byKey(const Key('product:size-selector')), findsNothing);
      expect(find.byKey(const Key('product:color-selector')), findsNothing);
      expect(find.textContaining('Selected:'), findsNothing);
    });

    testWidgets('clothing options show and default to first values',
        (tester) async {
      await pumpWithProviders(
          tester,
          const ProductPage(
            titleOverride: 'Hoodie',
            priceOverride: '£30.00',
          ));
      await tester.pump();

      expect(find.byKey(const Key('product:size-selector')), findsOneWidget);
      expect(find.byKey(const Key('product:color-selector')), findsOneWidget);
      expect(find.text('Selected: XS, Black'), findsOneWidget);
    });

    testWidgets('size dropdown changes selected size and summary',
        (tester) async {
      await pumpWithProviders(
          tester,
          const ProductPage(
            titleOverride: 'Hoodie',
            priceOverride: '£30.00',
          ));
      await tester.pump();

      // Open size menu
      await tester.tap(find.byKey(const Key('product:size-selector')));
      await tester.pumpAndSettle();

      // Ensure option keys exist and select 'M'
      expect(find.byKey(const Key('product:size-option-M')), findsOneWidget);
      await tester.tap(find.byKey(const Key('product:size-option-M')));
      await tester.pumpAndSettle();

      expect(find.text('Selected: M, Black'), findsOneWidget);
    });

    testWidgets('selected options persist after quantity change (rebuild)',
        (tester) async {
      await pumpWithProviders(
          tester,
          const ProductPage(
            titleOverride: 'Hoodie',
            priceOverride: '£30.00',
          ));
      await tester.pump();

      // Change size to L
      await tester.tap(find.byKey(const Key('product:size-selector')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('product:size-option-L')));
      await tester.pumpAndSettle();
      expect(find.text('Selected: L, Black'), findsOneWidget);

      // Trigger a rebuild by changing quantity
      await tester.tap(find.byKey(const Key('product:qty-increase')));
      await tester.pump();

      // Selection should persist
      expect(find.text('Selected: L, Black'), findsOneWidget);
    });
  });
}
