import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/cart_item.dart';
import 'package:union_shop/models/order.dart';
import 'package:union_shop/services/order_service.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late OrderService orderService;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    orderService = OrderService(firestore: fakeFirestore);
  });

  group('Constructor', () {
    test('creates instance with mocked Firestore', () {
      expect(orderService, isNotNull);
      expect(orderService, isA<OrderService>());
    });
  });

  group('Create Order', () {
    test('createOrder returns a document ID', () async {
      final items = [
        CartItem(
          productId: 'item1',
          title: 'Test Product',
          price: 10.0,
          quantity: 2,
          imageUrl: 'test.jpg',
        ),
      ];

      final orderId = await orderService.createOrder(
        userId: 'user123',
        items: items,
        total: 20.0,
      );

      expect(orderId, isNotNull);
      expect(orderId, isA<String>());
      expect(orderId.isNotEmpty, isTrue);
    });

    test('createOrder stores order data correctly', () async {
      final items = [
        CartItem(
          productId: 'item1',
          title: 'Product A',
          price: 15.0,
          quantity: 1,
          imageUrl: 'a.jpg',
        ),
        CartItem(
          productId: 'item2',
          title: 'Product B',
          price: 25.0,
          quantity: 2,
          imageUrl: 'b.jpg',
        ),
      ];

      final orderId = await orderService.createOrder(
        userId: 'user456',
        items: items,
        total: 65.0,
      );

      // Verify the order was stored
      final doc = await fakeFirestore.collection('orders').doc(orderId).get();
      expect(doc.exists, isTrue);
      expect(doc.data()?['userId'], equals('user456'));
      expect(doc.data()?['total'], equals(65.0));
      expect(doc.data()?['status'], equals('completed'));
      expect(doc.data()?['items'], isA<List>());
      expect((doc.data()?['items'] as List).length, equals(2));
    });

    test('createOrder sets default status to completed', () async {
      final items = [
        CartItem(
          id: 'item1',
          name: 'Test',
          price: 5.0,
          quantity: 1,
          imageUrl: 'test.jpg',
        ),
      ];

      final orderId = await orderService.createOrder(
        userId: 'user789',
        items: items,
        total: 5.0,
      );

      final doc = await fakeFirestore.collection('orders').doc(orderId).get();
      expect(doc.data()?['status'], equals('completed'));
    });

    test('createOrder handles multiple items correctly', () async {
      final items = List.generate(
        5,
        (i) => CartItem(
          id: 'item$i',
          name: 'Product $i',
          price: (i + 1) * 10.0,
          quantity: i + 1,
          imageUrl: 'product$i.jpg',
        ),
      );

      final orderId = await orderService.createOrder(
        userId: 'userMulti',
        items: items,
        total: 150.0,
      );

      final doc = await fakeFirestore.collection('orders').doc(orderId).get();
      expect((doc.data()?['items'] as List).length, equals(5));
    });
  });

  group('Get User Orders', () {
    test('getUserOrders returns empty stream for user with no orders',
        () async {
      final stream = orderService.getUserOrders('noOrdersUser');

      await expectLater(
        stream.first,
        completion(isEmpty),
      );
    });

    test('getUserOrders returns orders for specific user', () async {
      // Create orders for different users
      await orderService.createOrder(
        userId: 'user1',
        items: [
          CartItem(
            id: 'item1',
            name: 'Product 1',
            price: 10.0,
            quantity: 1,
            imageUrl: 'p1.jpg',
          ),
        ],
        total: 10.0,
      );

      await orderService.createOrder(
        userId: 'user2',
        items: [
          CartItem(
            id: 'item2',
            name: 'Product 2',
            price: 20.0,
            quantity: 1,
            imageUrl: 'p2.jpg',
          ),
        ],
        total: 20.0,
      );

      await orderService.createOrder(
        userId: 'user1',
        items: [
          CartItem(
            id: 'item3',
            name: 'Product 3',
            price: 30.0,
            quantity: 1,
            imageUrl: 'p3.jpg',
          ),
        ],
        total: 30.0,
      );

      final stream = orderService.getUserOrders('user1');
      final orders = await stream.first;

      expect(orders.length, equals(2));
      expect(orders.every((order) => order.userId == 'user1'), isTrue);
    });

    test('getUserOrders stream emits Order objects', () async {
      await orderService.createOrder(
        userId: 'streamUser',
        items: [
          CartItem(
            id: 'item1',
            name: 'Test',
            price: 5.0,
            quantity: 1,
            imageUrl: 'test.jpg',
          ),
        ],
        total: 5.0,
      );

      final stream = orderService.getUserOrders('streamUser');
      final orders = await stream.first;

      expect(orders.first, isA<Order>());
      expect(orders.first.userId, equals('streamUser'));
    });

    test('getUserOrders sorts orders by date (newest first)', () async {
      // Create orders with slight delays to ensure different timestamps
      final order1Id = await orderService.createOrder(
        userId: 'sortUser',
        items: [
          CartItem(
            id: 'item1',
            name: 'First',
            price: 10.0,
            quantity: 1,
            imageUrl: 'f.jpg',
          ),
        ],
        total: 10.0,
      );

      await Future.delayed(const Duration(milliseconds: 50));

      final order2Id = await orderService.createOrder(
        userId: 'sortUser',
        items: [
          CartItem(
            id: 'item2',
            name: 'Second',
            price: 20.0,
            quantity: 1,
            imageUrl: 's.jpg',
          ),
        ],
        total: 20.0,
      );

      final stream = orderService.getUserOrders('sortUser');
      final orders = await stream.first;

      expect(orders.length, equals(2));
      // The second order should be first (newest)
      expect(orders[0].id, equals(order2Id));
      expect(orders[1].id, equals(order1Id));
    });
  });

  group('Get Order', () {
    test('getOrder returns null for non-existent order', () async {
      final order = await orderService.getOrder('nonExistentId');
      expect(order, isNull);
    });

    test('getOrder returns Order object for existing order', () async {
      final orderId = await orderService.createOrder(
        userId: 'testUser',
        items: [
          CartItem(
            id: 'item1',
            name: 'Test Product',
            price: 15.0,
            quantity: 1,
            imageUrl: 'test.jpg',
          ),
        ],
        total: 15.0,
      );

      final order = await orderService.getOrder(orderId);

      expect(order, isNotNull);
      expect(order, isA<Order>());
      expect(order!.id, equals(orderId));
      expect(order.userId, equals('testUser'));
      expect(order.total, equals(15.0));
    });

    test('getOrder retrieves correct order data', () async {
      final items = [
        CartItem(
          id: 'item1',
          name: 'Product A',
          price: 10.0,
          quantity: 2,
          imageUrl: 'a.jpg',
        ),
        CartItem(
          id: 'item2',
          name: 'Product B',
          price: 5.0,
          quantity: 1,
          imageUrl: 'b.jpg',
        ),
      ];

      final orderId = await orderService.createOrder(
        userId: 'user999',
        items: items,
        total: 25.0,
      );

      final order = await orderService.getOrder(orderId);

      expect(order!.items.length, equals(2));
      expect(order.items[0].name, equals('Product A'));
      expect(order.items[1].name, equals('Product B'));
    });
  });

  group('Update Order Status', () {
    test('updateOrderStatus changes order status', () async {
      final orderId = await orderService.createOrder(
        userId: 'statusUser',
        items: [
          CartItem(
            id: 'item1',
            name: 'Test',
            price: 10.0,
            quantity: 1,
            imageUrl: 'test.jpg',
          ),
        ],
        total: 10.0,
      );

      await orderService.updateOrderStatus(orderId, 'shipped');

      final doc = await fakeFirestore.collection('orders').doc(orderId).get();
      expect(doc.data()?['status'], equals('shipped'));
    });

    test('updateOrderStatus accepts various status values', () async {
      final orderId = await orderService.createOrder(
        userId: 'statusUser2',
        items: [
          CartItem(
            id: 'item1',
            name: 'Test',
            price: 10.0,
            quantity: 1,
            imageUrl: 'test.jpg',
          ),
        ],
        total: 10.0,
      );

      // Test different status values
      final statuses = ['processing', 'shipped', 'delivered', 'cancelled'];
      for (final status in statuses) {
        await orderService.updateOrderStatus(orderId, status);
        final doc = await fakeFirestore.collection('orders').doc(orderId).get();
        expect(doc.data()?['status'], equals(status));
      }
    });

    test('updateOrderStatus completes without error for valid order', () async {
      final orderId = await orderService.createOrder(
        userId: 'user',
        items: [
          CartItem(
            id: 'item1',
            name: 'Test',
            price: 10.0,
            quantity: 1,
            imageUrl: 'test.jpg',
          ),
        ],
        total: 10.0,
      );

      expect(
        () => orderService.updateOrderStatus(orderId, 'processing'),
        returnsNormally,
      );
    });
  });

  group('Delete Order', () {
    test('deleteOrder removes order from Firestore', () async {
      final orderId = await orderService.createOrder(
        userId: 'deleteUser',
        items: [
          CartItem(
            id: 'item1',
            name: 'Test',
            price: 10.0,
            quantity: 1,
            imageUrl: 'test.jpg',
          ),
        ],
        total: 10.0,
      );

      // Verify order exists
      var doc = await fakeFirestore.collection('orders').doc(orderId).get();
      expect(doc.exists, isTrue);

      // Delete order
      await orderService.deleteOrder(orderId);

      // Verify order is deleted
      doc = await fakeFirestore.collection('orders').doc(orderId).get();
      expect(doc.exists, isFalse);
    });

    test('deleteOrder completes without error for valid order', () async {
      final orderId = await orderService.createOrder(
        userId: 'user',
        items: [
          CartItem(
            id: 'item1',
            name: 'Test',
            price: 10.0,
            quantity: 1,
            imageUrl: 'test.jpg',
          ),
        ],
        total: 10.0,
      );

      expect(
        () => orderService.deleteOrder(orderId),
        returnsNormally,
      );
    });

    test('deleteOrder works for recently created order', () async {
      final orderId = await orderService.createOrder(
        userId: 'immediateDelete',
        items: [
          CartItem(
            id: 'item1',
            name: 'Quick Delete',
            price: 5.0,
            quantity: 1,
            imageUrl: 'test.jpg',
          ),
        ],
        total: 5.0,
      );

      await orderService.deleteOrder(orderId);

      final order = await orderService.getOrder(orderId);
      expect(order, isNull);
    });
  });

  group('Complete Order Flow', () {
    test('create, retrieve, update, delete order workflow', () async {
      // Create
      final orderId = await orderService.createOrder(
        userId: 'flowUser',
        items: [
          CartItem(
            id: 'item1',
            name: 'Flow Test',
            price: 30.0,
            quantity: 1,
            imageUrl: 'flow.jpg',
          ),
        ],
        total: 30.0,
      );
      expect(orderId, isNotNull);

      // Retrieve
      var order = await orderService.getOrder(orderId);
      expect(order, isNotNull);
      expect(order!.status, equals('completed'));

      // Update
      await orderService.updateOrderStatus(orderId, 'shipped');
      order = await orderService.getOrder(orderId);
      expect(order!.status, equals('shipped'));

      // Delete
      await orderService.deleteOrder(orderId);
      order = await orderService.getOrder(orderId);
      expect(order, isNull);
    });

    test('multiple orders for same user are handled correctly', () async {
      final userId = 'multiOrderUser';

      // Create 3 orders
      final order1 = await orderService.createOrder(
        userId: userId,
        items: [
          CartItem(
            id: 'item1',
            name: 'Order 1',
            price: 10.0,
            quantity: 1,
            imageUrl: 'o1.jpg',
          ),
        ],
        total: 10.0,
      );

      final order2 = await orderService.createOrder(
        userId: userId,
        items: [
          CartItem(
            id: 'item2',
            name: 'Order 2',
            price: 20.0,
            quantity: 1,
            imageUrl: 'o2.jpg',
          ),
        ],
        total: 20.0,
      );

      final order3 = await orderService.createOrder(
        userId: userId,
        items: [
          CartItem(
            id: 'item3',
            name: 'Order 3',
            price: 30.0,
            quantity: 1,
            imageUrl: 'o3.jpg',
          ),
        ],
        total: 30.0,
      );

      // Verify all orders are retrievable
      final stream = orderService.getUserOrders(userId);
      final orders = await stream.first;

      expect(orders.length, equals(3));
      expect(
        orders.map((o) => o.id).toSet(),
        containsAll([order1, order2, order3]),
      );
    });
  });
}
