import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import '../models/order.dart';
import '../models/cart_item.dart';

/// Service for managing orders in Firestore
class OrderService {
  final FirebaseFirestore _firestore;
  final String _ordersCollection = 'orders';

  OrderService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Create a new order
  Future<String> createOrder({
    required String userId,
    required List<CartItem> items,
    required double total,
  }) async {
    try {
      final orderData = {
        'userId': userId,
        'items': items.map((item) => item.toMap()).toList(),
        'total': total,
        'orderDate': FieldValue.serverTimestamp(),
        'status': 'completed',
      };

      final docRef =
          await _firestore.collection(_ordersCollection).add(orderData);
      return docRef.id;
    } catch (e) {
      throw 'Failed to create order: $e';
    }
  }

  /// Get all orders for a specific user
  Stream<List<Order>> getUserOrders(String userId) {
    return _firestore
        .collection(_ordersCollection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final orders =
          snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList();
      orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      return orders;
    });
  }

  /// Get a specific order by ID
  Future<Order?> getOrder(String orderId) async {
    try {
      final doc =
          await _firestore.collection(_ordersCollection).doc(orderId).get();
      if (doc.exists) {
        return Order.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw 'Failed to get order: $e';
    }
  }

  /// Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore.collection(_ordersCollection).doc(orderId).update({
        'status': status,
      });
    } catch (e) {
      throw 'Failed to update order status: $e';
    }
  }

  /// Delete an order (admin only - use with caution)
  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection(_ordersCollection).doc(orderId).delete();
    } catch (e) {
      throw 'Failed to delete order: $e';
    }
  }
}
