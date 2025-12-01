import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/cart_item.dart';

void main() {
  group('CartItem', () {
    group('Constructor', () {
      test('creates CartItem with all required fields', () {
        final item = CartItem(
          productId: 'test-1',
          title: 'Test Product',
          price: 19.99,
          quantity: 2,
          imageUrl: 'https://example.com/image.jpg',
        );

        expect(item.productId, equals('test-1'));
        expect(item.title, equals('Test Product'));
        expect(item.price, equals(19.99));
        expect(item.quantity, equals(2));
        expect(item.imageUrl, equals('https://example.com/image.jpg'));
        expect(item.selectedOptions, isNull);
      });

      test('creates CartItem with optional selectedOptions', () {
        final options = {'size': 'M', 'color': 'Blue'};
        final item = CartItem(
          productId: 'test-1',
          title: 'Test Product',
          price: 19.99,
          quantity: 1,
          imageUrl: 'https://example.com/image.jpg',
          selectedOptions: options,
        );

        expect(item.selectedOptions, equals(options));
        expect(item.selectedOptions?['size'], equals('M'));
        expect(item.selectedOptions?['color'], equals('Blue'));
      });
    });

    group('totalPrice', () {
      test('calculates total price correctly', () {
        final item = CartItem(
          productId: 'test-1',
          title: 'Test Product',
          price: 10.50,
          quantity: 3,
          imageUrl: 'https://example.com/image.jpg',
        );

        expect(item.totalPrice, equals(31.50));
      });

      test('calculates total price for quantity 1', () {
        final item = CartItem(
          productId: 'test-1',
          title: 'Test Product',
          price: 25.00,
          quantity: 1,
          imageUrl: 'https://example.com/image.jpg',
        );

        expect(item.totalPrice, equals(25.00));
      });

      test('updates when quantity changes', () {
        final item = CartItem(
          productId: 'test-1',
          title: 'Test Product',
          price: 10.00,
          quantity: 2,
          imageUrl: 'https://example.com/image.jpg',
        );

        expect(item.totalPrice, equals(20.00));

        item.quantity = 5;
        expect(item.totalPrice, equals(50.00));
      });
    });

    group('toMap', () {
      test('converts CartItem to Map correctly without options', () {
        final item = CartItem(
          productId: 'test-1',
          title: 'Test Product',
          price: 19.99,
          quantity: 2,
          imageUrl: 'https://example.com/image.jpg',
        );

        final map = item.toMap();

        expect(map['productId'], equals('test-1'));
        expect(map['title'], equals('Test Product'));
        expect(map['price'], equals(19.99));
        expect(map['quantity'], equals(2));
        expect(map['imageUrl'], equals('https://example.com/image.jpg'));
        expect(map['selectedOptions'], isNull);
      });

      test('converts CartItem to Map correctly with options', () {
        final options = {'size': 'L', 'color': 'Red'};
        final item = CartItem(
          productId: 'test-1',
          title: 'Test Product',
          price: 19.99,
          quantity: 1,
          imageUrl: 'https://example.com/image.jpg',
          selectedOptions: options,
        );

        final map = item.toMap();

        expect(map['selectedOptions'], equals(options));
        expect(map['selectedOptions']['size'], equals('L'));
      });
    });

    group('fromMap', () {
      test('creates CartItem from Map without options', () {
        final map = {
          'productId': 'test-1',
          'title': 'Test Product',
          'price': 19.99,
          'quantity': 2,
          'imageUrl': 'https://example.com/image.jpg',
          'selectedOptions': null,
        };

        final item = CartItem.fromMap(map);

        expect(item.productId, equals('test-1'));
        expect(item.title, equals('Test Product'));
        expect(item.price, equals(19.99));
        expect(item.quantity, equals(2));
        expect(item.imageUrl, equals('https://example.com/image.jpg'));
        expect(item.selectedOptions, isNull);
      });

      test('creates CartItem from Map with options', () {
        final options = {'size': 'S', 'color': 'Green'};
        final map = {
          'productId': 'test-2',
          'title': 'Another Product',
          'price': 29.99,
          'quantity': 1,
          'imageUrl': 'https://example.com/image2.jpg',
          'selectedOptions': options,
        };

        final item = CartItem.fromMap(map);

        expect(item.selectedOptions, equals(options));
        expect(item.selectedOptions?['size'], equals('S'));
      });

      test('handles integer price conversion', () {
        final map = {
          'productId': 'test-1',
          'title': 'Test Product',
          'price': 20, // Integer instead of double
          'quantity': 1,
          'imageUrl': 'https://example.com/image.jpg',
          'selectedOptions': null,
        };

        final item = CartItem.fromMap(map);

        expect(item.price, equals(20.0));
        expect(item.price, isA<double>());
      });
    });

    group('copyWith', () {
      test('creates copy with modified quantity', () {
        final original = CartItem(
          productId: 'test-1',
          title: 'Test Product',
          price: 19.99,
          quantity: 2,
          imageUrl: 'https://example.com/image.jpg',
        );

        final copy = original.copyWith(quantity: 5);

        expect(copy.productId, equals(original.productId));
        expect(copy.title, equals(original.title));
        expect(copy.price, equals(original.price));
        expect(copy.quantity, equals(5));
        expect(copy.imageUrl, equals(original.imageUrl));
      });

      test('creates copy with modified price', () {
        final original = CartItem(
          productId: 'test-1',
          title: 'Test Product',
          price: 19.99,
          quantity: 2,
          imageUrl: 'https://example.com/image.jpg',
        );

        final copy = original.copyWith(price: 24.99);

        expect(copy.price, equals(24.99));
        expect(copy.quantity, equals(original.quantity));
      });

      test('creates copy without changes when no parameters provided', () {
        final original = CartItem(
          productId: 'test-1',
          title: 'Test Product',
          price: 19.99,
          quantity: 2,
          imageUrl: 'https://example.com/image.jpg',
        );

        final copy = original.copyWith();

        expect(copy.productId, equals(original.productId));
        expect(copy.title, equals(original.title));
        expect(copy.price, equals(original.price));
        expect(copy.quantity, equals(original.quantity));
        expect(copy.imageUrl, equals(original.imageUrl));
      });

      test('creates copy with modified selectedOptions', () {
        final original = CartItem(
          productId: 'test-1',
          title: 'Test Product',
          price: 19.99,
          quantity: 2,
          imageUrl: 'https://example.com/image.jpg',
          selectedOptions: {'size': 'M'},
        );

        final newOptions = {'size': 'L', 'color': 'Blue'};
        final copy = original.copyWith(selectedOptions: newOptions);

        expect(copy.selectedOptions, equals(newOptions));
        expect(original.selectedOptions, equals({'size': 'M'}));
      });
    });

    group('Equality', () {
      test('two CartItems with same values are equal', () {
        final item1 = CartItem(
          productId: 'test-1',
          title: 'Test Product',
          price: 19.99,
          quantity: 2,
          imageUrl: 'https://example.com/image.jpg',
        );

        final item2 = CartItem(
          productId: 'test-1',
          title: 'Test Product',
          price: 19.99,
          quantity: 2,
          imageUrl: 'https://example.com/image.jpg',
        );

        expect(item1, equals(item2));
        expect(item1 == item2, isTrue);
      });

      test('two CartItems with different productIds are not equal', () {
        final item1 = CartItem(
          productId: 'test-1',
          title: 'Test Product',
          price: 19.99,
          quantity: 2,
          imageUrl: 'https://example.com/image.jpg',
        );

        final item2 = CartItem(
          productId: 'test-2',
          title: 'Test Product',
          price: 19.99,
          quantity: 2,
          imageUrl: 'https://example.com/image.jpg',
        );

        expect(item1, isNot(equals(item2)));
      });

      test('CartItem is equal to itself', () {
        final item = CartItem(
          productId: 'test-1',
          title: 'Test Product',
          price: 19.99,
          quantity: 2,
          imageUrl: 'https://example.com/image.jpg',
        );

        expect(identical(item, item), isTrue);
        expect(item == item, isTrue);
      });

      test('two CartItems with different quantities are not equal', () {
        final item1 = CartItem(
          productId: 'test-1',
          title: 'Test Product',
          price: 19.99,
          quantity: 2,
          imageUrl: 'https://example.com/image.jpg',
        );

        final item2 = CartItem(
          productId: 'test-1',
          title: 'Test Product',
          price: 19.99,
          quantity: 3,
          imageUrl: 'https://example.com/image.jpg',
        );

        expect(item1, isNot(equals(item2)));
      });
    });

    group('hashCode', () {
      test('equal items have same hashCode', () {
        final item1 = CartItem(
          productId: 'test-1',
          title: 'Test Product',
          price: 19.99,
          quantity: 2,
          imageUrl: 'https://example.com/image.jpg',
        );

        final item2 = CartItem(
          productId: 'test-1',
          title: 'Test Product',
          price: 19.99,
          quantity: 2,
          imageUrl: 'https://example.com/image.jpg',
        );

        expect(item1.hashCode, equals(item2.hashCode));
      });

      test('different items have different hashCodes', () {
        final item1 = CartItem(
          productId: 'test-1',
          title: 'Test Product',
          price: 19.99,
          quantity: 2,
          imageUrl: 'https://example.com/image.jpg',
        );

        final item2 = CartItem(
          productId: 'test-2',
          title: 'Different Product',
          price: 29.99,
          quantity: 1,
          imageUrl: 'https://example.com/image2.jpg',
        );

        expect(item1.hashCode, isNot(equals(item2.hashCode)));
      });
    });

    group('toString', () {
      test('returns formatted string representation', () {
        final item = CartItem(
          productId: 'test-1',
          title: 'Test Product',
          price: 19.99,
          quantity: 2,
          imageUrl: 'https://example.com/image.jpg',
        );

        final str = item.toString();

        expect(str, contains('CartItem'));
        expect(str, contains('test-1'));
        expect(str, contains('Test Product'));
        expect(str, contains('19.99'));
        expect(str, contains('2'));
      });
    });

    group('Round-trip serialization', () {
      test('toMap and fromMap preserve all data', () {
        final original = CartItem(
          productId: 'test-1',
          title: 'Test Product',
          price: 19.99,
          quantity: 2,
          imageUrl: 'https://example.com/image.jpg',
          selectedOptions: {'size': 'M', 'color': 'Blue'},
        );

        final map = original.toMap();
        final restored = CartItem.fromMap(map);

        expect(restored.productId, equals(original.productId));
        expect(restored.title, equals(original.title));
        expect(restored.price, equals(original.price));
        expect(restored.quantity, equals(original.quantity));
        expect(restored.imageUrl, equals(original.imageUrl));
        expect(restored.selectedOptions, equals(original.selectedOptions));
      });
    });
  });
}
