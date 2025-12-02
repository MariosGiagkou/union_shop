import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';

/// Repository for managing shopping cart state and operations
/// Uses ChangeNotifier to notify listeners when cart changes
class CartRepository extends ChangeNotifier {
  // Private list to store cart items
  final List<CartItem> _cartItems = [];

  /// Get a copy of all cart items (unmodifiable)
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  /// Get the total number of items in the cart
  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  /// Get the total price of all items in the cart
  double get cartTotal =>
      _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Check if the cart is empty
  bool get isEmpty => _cartItems.isEmpty;

  /// Check if the cart has items
  bool get isNotEmpty => _cartItems.isNotEmpty;

  /// Add an item to the cart
  /// If the item already exists (same productId), increment quantity instead
  void addItem({
    required String productId,
    required String title,
    required double price,
    required String imageUrl,
    int quantity = 1,
    Map<String, dynamic>? selectedOptions,
  }) {
    // Check if item already exists in cart
    /// Check if identical item already exists (same product + same options)
    /// This allows same product with different sizes/colors to be separate items
    final existingIndex = _cartItems.indexWhere(
      (item) =>
          item.productId == productId &&
          _areOptionsEqual(item.selectedOptions, selectedOptions),
    );

    if (existingIndex >= 0) {
      // Item exists - increment quantity
      _cartItems[existingIndex].quantity += quantity;
    } else {
      // New item - add to cart
      _cartItems.add(CartItem(
        productId: productId,
        title: title,
        price: price,
        quantity: quantity,
        imageUrl: imageUrl,
        selectedOptions: selectedOptions,
      ));
    }

    notifyListeners();
  }

  /// Remove an item from the cart by productId
  void removeItem(String productId) {
    _cartItems.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  /// Remove a specific cart item (useful when items have different options)
  void removeCartItem(CartItem cartItem) {
    _cartItems.remove(cartItem);
    notifyListeners();
  }

  /// Update the quantity of an item in the cart
  /// If quantity becomes 0 or negative, remove the item
  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(productId);
      return;
    }

    final index = _cartItems.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      _cartItems[index].quantity = newQuantity;
      notifyListeners();
    }
  }

  /// Increment quantity of a specific cart item by 1
  void incrementQuantity(CartItem cartItem) {
    if (_cartItems.contains(cartItem)) {
      cartItem.quantity++;
      notifyListeners();
    }
  }

  /// Decrement quantity of a specific cart item by 1
  /// If quantity becomes 0, remove the item
  void decrementQuantity(CartItem cartItem) {
    if (_cartItems.contains(cartItem)) {
      if (cartItem.quantity > 1) {
        cartItem.quantity--;
        notifyListeners();
      } else {
        _cartItems.remove(cartItem);
        notifyListeners();
      }
    }
  }

  /// Clear all items from the cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  /// Get a specific item from the cart by productId
  CartItem? getItem(String productId) {
    try {
      return _cartItems.firstWhere((item) => item.productId == productId);
    } catch (e) {
      return null;
    }
  }

  /// Check if a product is in the cart
  bool containsProduct(String productId) {
    return _cartItems.any((item) => item.productId == productId);
  }

  /// Get the quantity of a specific product in the cart
  int getProductQuantity(String productId) {
    final item = getItem(productId);
    return item?.quantity ?? 0;
  }

  /// Helper method to compare selectedOptions maps
  /// Compares two option maps to determine if they're identical
  /// Handles null cases and performs deep equality check
  bool _areOptionsEqual(
      Map<String, dynamic>? options1, Map<String, dynamic>? options2) {
    if (options1 == null && options2 == null) return true;
    if (options1 == null || options2 == null) return false;
    if (options1.length != options2.length) return false;

    for (var key in options1.keys) {
      if (options1[key] != options2[key]) return false;
    }
    return true;
  }

  /// Save cart to persistent storage (for future implementation)
  /// This could use shared_preferences or local database
  Future<void> saveCart() async {}

  /// Load cart from persistent storage (for future implementation)
  Future<void> loadCart() async {}
}
