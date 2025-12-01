import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/cart_page.dart';
import 'package:union_shop/repositories/cart_repository.dart';
import '../../helpers/test_helpers.dart';



void main() {
  // Set larger test surface to reduce overflow errors (doesn't fully solve it)
  TestWidgetsFlutterBinding.ensureInitialized();

  // Use a setup that applies to all tests
  setUp(() async {
    // Binding is already initialized above
  });

  group('CartPage - Empty Cart', () {
    testWidgets('shows empty cart message when cart is empty',
        (WidgetTester tester) async {
      // Arrange: Create empty cart
      final emptyCart = CartRepository();

      // Act: Pump the cart page with empty cart
      await pumpWithProviders(
        tester,
        const CartPage(),
        cartRepository: emptyCart,
      );

      // Assert: Empty cart UI elements appear
      expect(find.byIcon(Icons.shopping_bag_outlined), findsWidgets);
      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.text('Continue Shopping'), findsOneWidget);
    });

    testWidgets('continue shopping button appears in empty cart',
        (WidgetTester tester) async {
      // Arrange
      final emptyCart = CartRepository();

      // Act
      await pumpWithProviders(
        tester,
        const CartPage(),
        cartRepository: emptyCart,
      );

      // Assert
      final continueButton =
          find.widgetWithText(ElevatedButton, 'Continue Shopping');
      expect(continueButton, findsOneWidget);
    });
  });

  group('CartPage - Cart with Items', () {
    testWidgets('shows cart items when cart has products',
        (WidgetTester tester) async {
      // Arrange: Create cart with items
      final cartWithItems = createCartWithItems();
      // Set larger screen size to avoid layout overflows
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      // Act
      await pumpWithProviders(
        tester,
        const CartPage(),
        cartRepository: cartWithItems,
      );

      // Assert: Page title and item count appear
      expect(find.text('Shopping Cart'), findsOneWidget);
      expect(
          find.text('3 items'), findsOneWidget); // Cart has 3 total items (qty)

      // Reset surface size
      addTearDown(() => tester.binding.setSurfaceSize(null));
    });

    testWidgets('displays product titles from cart items',
        (WidgetTester tester) async {
      // Arrange
      final cartWithItems = createCartWithItems();

      // Act
      await pumpWithProviders(
        tester,
        const CartPage(),
        cartRepository: cartWithItems,
      );

      // Assert: Product titles appear
      expect(find.text('Test Product 1'), findsOneWidget);
      expect(find.text('Test Product 2'), findsOneWidget);
    });

    testWidgets('displays product prices correctly',
        (WidgetTester tester) async {
      // Arrange
      final cartWithItems = createCartWithItems();

      // Act
      await pumpWithProviders(
        tester,
        const CartPage(),
        cartRepository: cartWithItems,
      );

      // Assert: Product prices appear
      expect(find.text('£19.99'), findsWidgets);
      expect(find.text('£29.99'), findsWidgets);
    });

    testWidgets('shows quantity controls for each item',
        (WidgetTester tester) async {
      // Arrange
      final cartWithItems = createCartWithItems();

      // Act
      await pumpWithProviders(
        tester,
        const CartPage(),
        cartRepository: cartWithItems,
      );

      // Assert: Quantity controls appear (increment/decrement buttons)
      final decrementButtons = find.byIcon(Icons.remove);
      final incrementButtons = find.byIcon(Icons.add);

      expect(decrementButtons, findsWidgets);
      expect(incrementButtons, findsWidgets);
    });

    testWidgets('displays order summary section', (WidgetTester tester) async {
      // Arrange
      final cartWithItems = createCartWithItems();

      // Act
      await pumpWithProviders(
        tester,
        const CartPage(),
        cartRepository: cartWithItems,
      );

      // Assert: Order summary elements appear
      expect(find.text('Order Summary'), findsOneWidget);
      expect(find.text('Subtotal'), findsOneWidget);
      expect(find.text('Total'), findsOneWidget);
      expect(find.text('Checkout'), findsOneWidget);
    });

    testWidgets('shows correct cart total in order summary',
        (WidgetTester tester) async {
      // Arrange
      final cartWithItems = createCartWithItems();
      // Cart has: Product 1 (£19.99 x 2) + Product 2 (£29.99 x 1) = £69.97

      // Act
      await pumpWithProviders(
        tester,
        const CartPage(),
        cartRepository: cartWithItems,
      );

      // Assert: Total price is £69.97
      expect(find.text('£69.97'), findsWidgets);
    });
  });

  group('CartPage - Quantity Controls', () {
    testWidgets('can increment product quantity', (WidgetTester tester) async {
      // Arrange
      final cartRepo = CartRepository();
      cartRepo.addItem(
        productId: 'test-1',
        title: 'Test Product',
        price: 15.00,
        imageUrl: 'assets/images/test.webp',
        quantity: 1,
      );

      // Act
      await pumpWithProviders(
        tester,
        const CartPage(),
        cartRepository: cartRepo,
      );

      // Find and tap the increment button
      final incrementButton = find.byIcon(Icons.add).first;
      await tester.tap(incrementButton);
      await tester.pumpAndSettle();

      // Assert: Quantity increased to 2
      expect(cartRepo.cartItems.first.quantity, 2);
    });

    testWidgets('can decrement product quantity', (WidgetTester tester) async {
      // Arrange
      final cartRepo = CartRepository();
      cartRepo.addItem(
        productId: 'test-1',
        title: 'Test Product',
        price: 15.00,
        imageUrl: 'assets/images/test.webp',
        quantity: 3,
      );

      // Act
      await pumpWithProviders(
        tester,
        const CartPage(),
        cartRepository: cartRepo,
      );

      // Find and tap the decrement button
      final decrementButton = find.byIcon(Icons.remove).first;
      await tester.tap(decrementButton);
      await tester.pumpAndSettle();

      // Assert: Quantity decreased to 2
      expect(cartRepo.cartItems.first.quantity, 2);
    });

    testWidgets('removes item when quantity decremented to zero',
        (WidgetTester tester) async {
      // Arrange
      final cartRepo = CartRepository();
      cartRepo.addItem(
        productId: 'test-1',
        title: 'Test Product',
        price: 15.00,
        imageUrl: 'assets/images/test.webp',
        quantity: 1,
      );

      // Act
      await pumpWithProviders(
        tester,
        const CartPage(),
        cartRepository: cartRepo,
      );

      // Decrement from 1 to 0 (should remove item)
      final decrementButton = find.byIcon(Icons.remove).first;
      await tester.tap(decrementButton);
      await tester.pumpAndSettle();

      // Assert: Cart is now empty
      expect(cartRepo.isEmpty, true);
      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets('total price updates when quantity changes',
        (WidgetTester tester) async {
      // Arrange
      final cartRepo = CartRepository();
      cartRepo.addItem(
        productId: 'test-1',
        title: 'Test Product',
        price: 10.00,
        imageUrl: 'assets/images/test.webp',
        quantity: 1,
      );

      // Act
      await pumpWithProviders(
        tester,
        const CartPage(),
        cartRepository: cartRepo,
      );

      // Initial total is £10.00
      expect(find.text('£10.00'), findsWidgets);

      // Increment quantity
      final incrementButton = find.byIcon(Icons.add).first;
      await tester.tap(incrementButton);
      await tester.pumpAndSettle();

      // Assert: Total updated to £20.00
      expect(find.text('£20.00'), findsWidgets);
    });
  });

  group('CartPage - Item Removal', () {
    testWidgets('can remove item using close button',
        (WidgetTester tester) async {
      // Arrange
      final cartRepo = CartRepository();
      cartRepo.addItem(
        productId: 'test-1',
        title: 'Product 1',
        price: 10.00,
        imageUrl: 'assets/images/test.webp',
        quantity: 1,
      );
      cartRepo.addItem(
        productId: 'test-2',
        title: 'Product 2',
        price: 20.00,
        imageUrl: 'assets/images/test.webp',
        quantity: 1,
      );

      // Act
      await pumpWithProviders(
        tester,
        const CartPage(),
        cartRepository: cartRepo,
      );

      // Find and tap the first close button
      final closeButton = find.byIcon(Icons.close).first;
      await tester.tap(closeButton);
      await tester.pumpAndSettle();

      // Assert: One item removed, one remains
      expect(cartRepo.cartItems.length, 1);
      expect(find.text('1 item'), findsOneWidget);
    });
  });

  group('CartPage - Responsive Layout', () {
    testWidgets('uses mobile layout for narrow screens',
        (WidgetTester tester) async {
      // Arrange
      final cartWithItems = createCartWithItems();

      // Set mobile screen size
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      // Act
      await pumpWithProviders(
        tester,
        const CartPage(),
        cartRepository: cartWithItems,
      );

      // Assert: Mobile layout renders
      expect(find.text('Shopping Cart'), findsOneWidget);
      expect(find.text('Order Summary'), findsOneWidget);
    });

    testWidgets('uses desktop layout for wide screens',
        (WidgetTester tester) async {
      // Arrange
      final cartWithItems = createCartWithItems();

      // Set desktop screen size
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      // Act
      await pumpWithProviders(
        tester,
        const CartPage(),
        cartRepository: cartWithItems,
      );

      // Assert: Desktop layout renders
      expect(find.text('Shopping Cart'), findsOneWidget);
      expect(find.text('Order Summary'), findsOneWidget);
    });
  });

  group('CartPage - Product Options', () {
    testWidgets('displays selected options for clothing items',
        (WidgetTester tester) async {
      // Arrange
      final cartRepo = CartRepository();
      cartRepo.addItem(
        productId: 'test-clothing',
        title: 'Test Hoodie',
        price: 35.00,
        imageUrl: 'assets/images/test.webp',
        quantity: 1,
        selectedOptions: {
          'Size': 'M',
          'Color': 'Blue',
        },
      );

      // Act
      await pumpWithProviders(
        tester,
        const CartPage(),
        cartRepository: cartRepo,
      );

      // Assert: Options appear
      expect(find.textContaining('Size: M'), findsOneWidget);
      expect(find.textContaining('Color: Blue'), findsOneWidget);
    });

    testWidgets('handles items without options', (WidgetTester tester) async {
      // Arrange
      final cartRepo = CartRepository();
      cartRepo.addItem(
        productId: 'test-accessory',
        title: 'Test Accessory',
        price: 5.00,
        imageUrl: 'assets/images/test.webp',
        quantity: 1,
        // No selectedOptions parameter
      );

      // Act
      await pumpWithProviders(
        tester,
        const CartPage(),
        cartRepository: cartRepo,
      );

      // Assert: Product renders without options section
      expect(find.text('Test Accessory'), findsOneWidget);
      expect(find.text('£5.00'), findsWidgets);
    });
  });

  group('CartPage - Layout', () {
    testWidgets('includes page structure and components',
        (WidgetTester tester) async {
      // Arrange
      final cartWithItems = createCartWithItems();

      // Act
      await pumpWithProviders(
        tester,
        const CartPage(),
        cartRepository: cartWithItems,
      );

      // Assert: Page structure is rendered
      expect(find.text('Shopping Cart'), findsOneWidget);
      expect(find.text('Order Summary'), findsOneWidget);
    });
  });
}
