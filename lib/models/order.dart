import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item.dart';

/// Represents a customer order
class Order {
  final String orderId;
  final String userId;
  final List<CartItem> items;
  final double total;
  final DateTime orderDate;
  final String status; // 'pending', 'processing', 'completed', 'cancelled'

  Order({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.total,
    required this.orderDate,
    this.status = 'pending',
  });

  /// Get total number of items in order
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Create Order from Firestore document
  factory Order.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Order(
      orderId: doc.id,
      userId: data['userId'] as String,
      items: (data['items'] as List)
          .map((item) => CartItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      total: (data['total'] as num).toDouble(),
      orderDate: (data['orderDate'] as Timestamp).toDate(),
      status: data['status'] as String? ?? 'pending',
    );
  }

  /// Convert Order to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'orderDate': Timestamp.fromDate(orderDate),
      'status': status,
    };
  }

  /// Create a copy with updated fields
  Order copyWith({
    String? orderId,
    String? userId,
    List<CartItem>? items,
    double? total,
    DateTime? orderDate,
    String? status,
  }) {
    return Order(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      total: total ?? this.total,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
    );
  }
}
