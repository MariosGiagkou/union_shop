import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/repositories/cart_repository.dart';
import 'package:union_shop/models/cart_item.dart';

void main() {
  group('CartRepository', () {
    late CartRepository repository;

    setUp(() {
      repository = CartRepository();
    });

    group('Initial state', () {
      test('starts with empty cart', () {
        expect(repository.cartItems, isEmpty);
        expect(repository.isEmpty, isTrue);
        expect(repository.isNotEmpty, isFalse);
      });

      test('has zero item count initially', () {
        expect(repository.itemCount, equals(0));
      });

      test('has zero cart total initially', () {
        expect(repository.cartTotal, equals(0.0));
      });
    });

    group('addItem', () {
      test('adds new item to empty cart', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
        );

        expect(repository.cartItems.length, equals(1));
        expect(repository.cartItems[0].productId, equals('product-1'));
        expect(repository.cartItems[0].title, equals('Test Product'));
        expect(repository.cartItems[0].price, equals(10.00));
        expect(repository.cartItems[0].quantity, equals(1)); // default quantity
      });

      test('adds item with custom quantity', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
          quantity: 5,
        );

        expect(repository.cartItems[0].quantity, equals(5));
      });

      test('increments quantity when adding existing item', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
          quantity: 2,
        );

        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
          quantity: 3,
        );

        expect(repository.cartItems.length, equals(1)); // Still one item
        expect(repository.cartItems[0].quantity, equals(5)); // 2 + 3
      });

      test('adds item with selectedOptions', () {
        final options = {'size': 'Large', 'color': 'Red'};

        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
          selectedOptions: options,
        );

        expect(repository.cartItems[0].selectedOptions, equals(options));
      });

      test('treats same product with different options as separate items', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
          selectedOptions: {'size': 'Large'},
        );

        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
          selectedOptions: {'size': 'Small'},
        );

        expect(repository.cartItems.length, equals(2));
      });

      test('notifies listeners when adding item', () {
        var notified = false;
        repository.addListener(() => notified = true);

        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
        );

        expect(notified, isTrue);
      });
    });

    group('removeItem', () {
      test('removes item from cart', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
        );

        repository.removeItem('product-1');

        expect(repository.cartItems, isEmpty);
      });

      test('removes only matching productId', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Product 1',
          price: 10.00,
          imageUrl: 'https://example.com/image1.jpg',
        );

        repository.addItem(
          productId: 'product-2',
          title: 'Product 2',
          price: 15.00,
          imageUrl: 'https://example.com/image2.jpg',
        );

        repository.removeItem('product-1');

        expect(repository.cartItems.length, equals(1));
        expect(repository.cartItems[0].productId, equals('product-2'));
      });

      test('notifies listeners when removing item', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
        );

        var notified = false;
        repository.addListener(() => notified = true);

        repository.removeItem('product-1');

        expect(notified, isTrue);
      });

      test('handles removing non-existent item gracefully', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
        );

        repository.removeItem('non-existent');

        expect(repository.cartItems.length, equals(1));
      });
    });

    group('removeCartItem', () {
      test('removes specific cart item', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
        );

        final item = repository.cartItems[0];
        repository.removeCartItem(item);

        expect(repository.cartItems, isEmpty);
      });

      test('notifies listeners when removing cart item', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
        );

        final item = repository.cartItems[0];
        var notified = false;
        repository.addListener(() => notified = true);

        repository.removeCartItem(item);

        expect(notified, isTrue);
      });
    });

    group('updateQuantity', () {
      test('updates quantity of existing item', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
          quantity: 2,
        );

        repository.updateQuantity('product-1', 5);

        expect(repository.cartItems[0].quantity, equals(5));
      });

      test('removes item when quantity is 0', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
        );

        repository.updateQuantity('product-1', 0);

        expect(repository.cartItems, isEmpty);
      });

      test('removes item when quantity is negative', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
        );

        repository.updateQuantity('product-1', -1);

        expect(repository.cartItems, isEmpty);
      });

      test('notifies listeners when updating quantity', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
        );

        var notified = false;
        repository.addListener(() => notified = true);

        repository.updateQuantity('product-1', 3);

        expect(notified, isTrue);
      });

      test('does nothing when updating non-existent item', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
        );

        repository.updateQuantity('non-existent', 5);

        expect(repository.cartItems.length, equals(1));
        expect(repository.cartItems[0].quantity, equals(1));
      });
    });

    group('incrementQuantity', () {
      test('increments quantity by 1', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
          quantity: 3,
        );

        final item = repository.cartItems[0];
        repository.incrementQuantity(item);

        expect(item.quantity, equals(4));
      });

      test('notifies listeners when incrementing', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
        );

        final item = repository.cartItems[0];
        var notified = false;
        repository.addListener(() => notified = true);

        repository.incrementQuantity(item);

        expect(notified, isTrue);
      });

      test('does nothing for non-existent item', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
        );

        final fakeItem = CartItem(
          productId: 'fake',
          title: 'Fake',
          price: 5.00,
          quantity: 1,
          imageUrl: 'https://example.com/fake.jpg',
        );

        repository.incrementQuantity(fakeItem);

        expect(repository.cartItems.length, equals(1));
        expect(repository.cartItems[0].quantity, equals(1));
      });
    });

    group('decrementQuantity', () {
      test('decrements quantity by 1', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
          quantity: 3,
        );

        final item = repository.cartItems[0];
        repository.decrementQuantity(item);

        expect(item.quantity, equals(2));
      });

      test('removes item when quantity reaches 0', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
          quantity: 1,
        );

        final item = repository.cartItems[0];
        repository.decrementQuantity(item);

        expect(repository.cartItems, isEmpty);
      });

      test('notifies listeners when decrementing', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
          quantity: 2,
        );

        final item = repository.cartItems[0];
        var notified = false;
        repository.addListener(() => notified = true);

        repository.decrementQuantity(item);

        expect(notified, isTrue);
      });

      test('notifies listeners when removing item at quantity 1', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
          quantity: 1,
        );

        final item = repository.cartItems[0];
        var notified = false;
        repository.addListener(() => notified = true);

        repository.decrementQuantity(item);

        expect(notified, isTrue);
      });
    });

    group('clearCart', () {
      test('removes all items from cart', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Product 1',
          price: 10.00,
          imageUrl: 'https://example.com/image1.jpg',
        );

        repository.addItem(
          productId: 'product-2',
          title: 'Product 2',
          price: 15.00,
          imageUrl: 'https://example.com/image2.jpg',
        );

        repository.clearCart();

        expect(repository.cartItems, isEmpty);
        expect(repository.isEmpty, isTrue);
      });

      test('notifies listeners when clearing cart', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
        );

        var notified = false;
        repository.addListener(() => notified = true);

        repository.clearCart();

        expect(notified, isTrue);
      });

      test('clearing empty cart still notifies listeners', () {
        var notified = false;
        repository.addListener(() => notified = true);

        repository.clearCart();

        expect(notified, isTrue);
      });
    });

    group('itemCount', () {
      test('calculates total quantity across all items', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Product 1',
          price: 10.00,
          imageUrl: 'https://example.com/image1.jpg',
          quantity: 3,
        );

        repository.addItem(
          productId: 'product-2',
          title: 'Product 2',
          price: 15.00,
          imageUrl: 'https://example.com/image2.jpg',
          quantity: 2,
        );

        expect(repository.itemCount, equals(5)); // 3 + 2
      });

      test('updates after quantity changes', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Product 1',
          price: 10.00,
          imageUrl: 'https://example.com/image1.jpg',
          quantity: 2,
        );

        expect(repository.itemCount, equals(2));

        repository.updateQuantity('product-1', 5);

        expect(repository.itemCount, equals(5));
      });
    });

    group('cartTotal', () {
      test('calculates total price of all items', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Product 1',
          price: 10.00,
          imageUrl: 'https://example.com/image1.jpg',
          quantity: 2,
        );

        repository.addItem(
          productId: 'product-2',
          title: 'Product 2',
          price: 15.00,
          imageUrl: 'https://example.com/image2.jpg',
          quantity: 1,
        );

        expect(repository.cartTotal, equals(35.00)); // (10 * 2) + (15 * 1)
      });

      test('updates after quantity changes', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Product 1',
          price: 10.00,
          imageUrl: 'https://example.com/image1.jpg',
          quantity: 2,
        );

        expect(repository.cartTotal, equals(20.00));

        repository.updateQuantity('product-1', 5);

        expect(repository.cartTotal, equals(50.00));
      });

      test('handles decimal prices correctly', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Product 1',
          price: 9.99,
          imageUrl: 'https://example.com/image1.jpg',
          quantity: 3,
        );

        expect(repository.cartTotal, closeTo(29.97, 0.001));
      });
    });

    group('getItem', () {
      test('returns item when it exists', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
        );

        final item = repository.getItem('product-1');

        expect(item, isNotNull);
        expect(item!.productId, equals('product-1'));
      });

      test('returns null when item does not exist', () {
        final item = repository.getItem('non-existent');

        expect(item, isNull);
      });
    });

    group('containsProduct', () {
      test('returns true when product exists', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
        );

        expect(repository.containsProduct('product-1'), isTrue);
      });

      test('returns false when product does not exist', () {
        expect(repository.containsProduct('non-existent'), isFalse);
      });
    });

    group('getProductQuantity', () {
      test('returns quantity when product exists', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
          quantity: 5,
        );

        expect(repository.getProductQuantity('product-1'), equals(5));
      });

      test('returns 0 when product does not exist', () {
        expect(repository.getProductQuantity('non-existent'), equals(0));
      });
    });

    group('isEmpty and isNotEmpty', () {
      test('isEmpty is true for empty cart', () {
        expect(repository.isEmpty, isTrue);
        expect(repository.isNotEmpty, isFalse);
      });

      test('isNotEmpty is true for cart with items', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
        );

        expect(repository.isEmpty, isFalse);
        expect(repository.isNotEmpty, isTrue);
      });
    });

    group('cartItems', () {
      test('returns unmodifiable list', () {
        repository.addItem(
          productId: 'product-1',
          title: 'Test Product',
          price: 10.00,
          imageUrl: 'https://example.com/image.jpg',
        );

        final items = repository.cartItems;

        expect(
            () => items.add(CartItem(
                  productId: 'fake',
                  title: 'Fake',
                  price: 5.00,
                  quantity: 1,
                  imageUrl: 'https://example.com/fake.jpg',
                )),
            throwsUnsupportedError);
      });
    });

    group('Complex scenarios', () {
      test('maintains cart state through multiple operations', () {
        // Add items
        repository.addItem(
          productId: 'product-1',
          title: 'Product 1',
          price: 10.00,
          imageUrl: 'https://example.com/image1.jpg',
          quantity: 3,
        );

        repository.addItem(
          productId: 'product-2',
          title: 'Product 2',
          price: 20.00,
          imageUrl: 'https://example.com/image2.jpg',
          quantity: 2,
        );

        expect(repository.itemCount, equals(5));
        expect(repository.cartTotal, equals(70.00));

        // Update quantity
        repository.updateQuantity('product-1', 1);
        expect(repository.itemCount, equals(3));
        expect(repository.cartTotal, equals(50.00));

        // Remove item
        repository.removeItem('product-2');
        expect(repository.itemCount, equals(1));
        expect(repository.cartTotal, equals(10.00));

        // Clear cart
        repository.clearCart();
        expect(repository.isEmpty, isTrue);
        expect(repository.cartTotal, equals(0.0));
      });

      test('handles items with same productId but different options', () {
        repository.addItem(
          productId: 'hoodie-1',
          title: 'Hoodie',
          price: 50.00,
          imageUrl: 'https://example.com/hoodie.jpg',
          selectedOptions: {'size': 'M', 'color': 'Red'},
        );

        repository.addItem(
          productId: 'hoodie-1',
          title: 'Hoodie',
          price: 50.00,
          imageUrl: 'https://example.com/hoodie.jpg',
          selectedOptions: {'size': 'L', 'color': 'Blue'},
        );

        expect(repository.cartItems.length, equals(2));
        expect(repository.itemCount, equals(2));
        expect(repository.cartTotal, equals(100.00));
      });
    });
  });
}
