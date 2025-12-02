/// Represents a single item in the shopping cart
/// Supports product variants through selectedOptions (size, color, etc.)
class CartItem {
  final String productId;
  final String title;
  final double price;
  int quantity;
  final String imageUrl;
  final Map<String, dynamic>? selectedOptions;

  CartItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    this.selectedOptions,
  });

  /// Calculate the total price for this cart item (price * quantity)
  double get totalPrice => price * quantity;

  /// Create a CartItem from a Map (useful for JSON serialization)
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'] as String,
      title: map['title'] as String,
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'] as int,
      imageUrl: map['imageUrl'] as String,
      selectedOptions: map['selectedOptions'] as Map<String, dynamic>?,
    );
  }

  /// Convert CartItem to a Map (useful for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'selectedOptions': selectedOptions,
    };
  }

  /// Create a copy of this CartItem with modified fields
  CartItem copyWith({
    String? productId,
    String? title,
    double? price,
    int? quantity,
    String? imageUrl,
    Map<String, dynamic>? selectedOptions,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      title: title ?? this.title,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      selectedOptions: selectedOptions ?? this.selectedOptions,
    );
  }

  @override
  String toString() {
    return 'CartItem(productId: $productId, title: $title, price: $price, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartItem &&
        other.productId == productId &&
        other.title == title &&
        other.price == price &&
        other.quantity == quantity &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return productId.hashCode ^
        title.hashCode ^
        price.hashCode ^
        quantity.hashCode ^
        imageUrl.hashCode;
  }
}
