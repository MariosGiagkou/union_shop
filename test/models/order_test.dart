import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/order.dart' as model;
import 'package:union_shop/models/cart_item.dart';

void main() {
  group('Order', () {
    final testItems = [
      CartItem(
        productId: 'item-1',
        title: 'Product 1',
        price: 10.00,
        quantity: 2,
        imageUrl: 'https://example.com/image1.jpg',
      ),
      CartItem(
        productId: 'item-2',
        title: 'Product 2',
        price: 15.00,
        quantity: 1,
        imageUrl: 'https://example.com/image2.jpg',
      ),
    ];

    final testDate = DateTime(2024, 12, 1, 10, 30);

    group('Constructor', () {
      test('creates Order with all required fields', () {
        final order = model.Order(
          orderId: 'order-123',
          userId: 'user-456',
          items: testItems,
          total: 35.00,
          orderDate: testDate,
        );

        expect(order.orderId, equals('order-123'));
        expect(order.userId, equals('user-456'));
        expect(order.items, equals(testItems));
        expect(order.total, equals(35.00));
        expect(order.orderDate, equals(testDate));
        expect(order.status, equals('pending')); // default value
      });

      test('creates Order with custom status', () {
        final order = model.Order(
          orderId: 'order-123',
          userId: 'user-456',
          items: testItems,
          total: 35.00,
          orderDate: testDate,
          status: 'completed',
        );

        expect(order.status, equals('completed'));
      });

      test('creates Order with empty items list', () {
        final order = model.Order(
          orderId: 'order-123',
          userId: 'user-456',
          items: [],
          total: 0.00,
          orderDate: testDate,
        );

        expect(order.items, isEmpty);
        expect(order.total, equals(0.00));
      });
    });

    group('itemCount', () {
      test('calculates total item count correctly', () {
        final order = model.Order(
          orderId: 'order-123',
          userId: 'user-456',
          items: testItems,
          total: 35.00,
          orderDate: testDate,
        );

        // item-1 has quantity 2, item-2 has quantity 1
        expect(order.itemCount, equals(3));
      });

      test('returns 0 for empty order', () {
        final order = model.Order(
          orderId: 'order-123',
          userId: 'user-456',
          items: [],
          total: 0.00,
          orderDate: testDate,
        );

        expect(order.itemCount, equals(0));
      });

      test('calculates item count with single item', () {
        final singleItem = [
          CartItem(
            productId: 'item-1',
            title: 'Product 1',
            price: 10.00,
            quantity: 5,
            imageUrl: 'https://example.com/image1.jpg',
          ),
        ];

        final order = model.Order(
          orderId: 'order-123',
          userId: 'user-456',
          items: singleItem,
          total: 50.00,
          orderDate: testDate,
        );

        expect(order.itemCount, equals(5));
      });
    });

    group('toMap', () {
      test('converts Order to Map correctly', () {
        final order = model.Order(
          orderId: 'order-123',
          userId: 'user-456',
          items: testItems,
          total: 35.00,
          orderDate: testDate,
          status: 'processing',
        );

        final map = order.toMap();

        expect(map['userId'], equals('user-456'));
        expect(map['total'], equals(35.00));
        expect(map['status'], equals('processing'));
        expect(map['items'], isA<List>());
        expect(map['items'].length, equals(2));
        expect(map['orderDate'], isA<Timestamp>());
      });

      test('converts items to Map correctly', () {
        final order = model.Order(
          orderId: 'order-123',
          userId: 'user-456',
          items: testItems,
          total: 35.00,
          orderDate: testDate,
        );

        final map = order.toMap();
        final items = map['items'] as List;

        expect(items[0]['productId'], equals('item-1'));
        expect(items[0]['title'], equals('Product 1'));
        expect(items[1]['productId'], equals('item-2'));
        expect(items[1]['title'], equals('Product 2'));
      });

      test('converts orderDate to Timestamp correctly', () {
        final order = model.Order(
          orderId: 'order-123',
          userId: 'user-456',
          items: testItems,
          total: 35.00,
          orderDate: testDate,
        );

        final map = order.toMap();
        final timestamp = map['orderDate'] as Timestamp;

        expect(timestamp.toDate(), equals(testDate));
      });

      test('does not include orderId in map', () {
        final order = model.Order(
          orderId: 'order-123',
          userId: 'user-456',
          items: testItems,
          total: 35.00,
          orderDate: testDate,
        );

        final map = order.toMap();

        expect(map.containsKey('orderId'), isFalse);
      });
    });

    group('copyWith', () {
      test('creates copy with modified status', () {
        final original = model.Order(
          orderId: 'order-123',
          userId: 'user-456',
          items: testItems,
          total: 35.00,
          orderDate: testDate,
          status: 'pending',
        );

        final copy = original.copyWith(status: 'completed');

        expect(copy.status, equals('completed'));
        expect(copy.orderId, equals(original.orderId));
        expect(copy.userId, equals(original.userId));
        expect(copy.total, equals(original.total));
        expect(copy.orderDate, equals(original.orderDate));
      });

      test('creates copy with modified total', () {
        final original = model.Order(
          orderId: 'order-123',
          userId: 'user-456',
          items: testItems,
          total: 35.00,
          orderDate: testDate,
        );

        final copy = original.copyWith(total: 40.00);

        expect(copy.total, equals(40.00));
        expect(copy.items, equals(original.items));
      });

      test('creates copy without changes when no parameters provided', () {
        final original = model.Order(
          orderId: 'order-123',
          userId: 'user-456',
          items: testItems,
          total: 35.00,
          orderDate: testDate,
          status: 'processing',
        );

        final copy = original.copyWith();

        expect(copy.orderId, equals(original.orderId));
        expect(copy.userId, equals(original.userId));
        expect(copy.items, equals(original.items));
        expect(copy.total, equals(original.total));
        expect(copy.orderDate, equals(original.orderDate));
        expect(copy.status, equals(original.status));
      });

      test('creates copy with new items list', () {
        final original = model.Order(
          orderId: 'order-123',
          userId: 'user-456',
          items: testItems,
          total: 35.00,
          orderDate: testDate,
        );

        final newItems = [
          CartItem(
            productId: 'item-3',
            title: 'Product 3',
            price: 20.00,
            quantity: 1,
            imageUrl: 'https://example.com/image3.jpg',
          ),
        ];

        final copy = original.copyWith(items: newItems);

        expect(copy.items, equals(newItems));
        expect(copy.items.length, equals(1));
        expect(original.items, equals(testItems)); // original unchanged
      });
    });

    group('Status values', () {
      test('supports pending status', () {
        final order = model.Order(
          orderId: 'order-123',
          userId: 'user-456',
          items: testItems,
          total: 35.00,
          orderDate: testDate,
          status: 'pending',
        );

        expect(order.status, equals('pending'));
      });

      test('supports processing status', () {
        final order = model.Order(
          orderId: 'order-123',
          userId: 'user-456',
          items: testItems,
          total: 35.00,
          orderDate: testDate,
          status: 'processing',
        );

        expect(order.status, equals('processing'));
      });

      test('supports completed status', () {
        final order = model.Order(
          orderId: 'order-123',
          userId: 'user-456',
          items: testItems,
          total: 35.00,
          orderDate: testDate,
          status: 'completed',
        );

        expect(order.status, equals('completed'));
      });

      test('supports cancelled status', () {
        final order = model.Order(
          orderId: 'order-123',
          userId: 'user-456',
          items: testItems,
          total: 35.00,
          orderDate: testDate,
          status: 'cancelled',
        );

        expect(order.status, equals('cancelled'));
      });
    });

    group('Edge cases', () {
      test('handles large quantities', () {
        final largeQuantityItems = [
          CartItem(
            productId: 'item-1',
            title: 'Product 1',
            price: 10.00,
            quantity: 100,
            imageUrl: 'https://example.com/image1.jpg',
          ),
        ];

        final order = model.Order(
          orderId: 'order-123',
          userId: 'user-456',
          items: largeQuantityItems,
          total: 1000.00,
          orderDate: testDate,
        );

        expect(order.itemCount, equals(100));
        expect(order.total, equals(1000.00));
      });

      test('handles decimal prices correctly', () {
        final order = model.Order(
          orderId: 'order-123',
          userId: 'user-456',
          items: testItems,
          total: 35.99,
          orderDate: testDate,
        );

        expect(order.total, equals(35.99));
      });

      test('preserves item order in list', () {
        final order = model.Order(
          orderId: 'order-123',
          userId: 'user-456',
          items: testItems,
          total: 35.00,
          orderDate: testDate,
        );

        expect(order.items[0].productId, equals('item-1'));
        expect(order.items[1].productId, equals('item-2'));
      });
    });
  });
}
