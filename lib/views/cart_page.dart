import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/layout.dart';
import '../repositories/cart_repository.dart';
import '../models/cart_item.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SiteHeader(),
          Expanded(
            child: Consumer<CartRepository>(
              builder: (context, cartRepo, child) {
                if (cartRepo.isEmpty) {
                  return _buildEmptyCart(context);
                }
                return _buildCartContent(context, cartRepo);
              },
            ),
          ),
          const SiteFooter(),
        ],
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Add some items to get started!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pushNamed('/'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4d2963),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text(
              'Continue Shopping',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartRepository cartRepo) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            Text(
              'Shopping Cart',
              style: TextStyle(
                fontSize: isMobile ? 28 : 36,
                fontWeight: FontWeight.w700,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${cartRepo.itemCount} ${cartRepo.itemCount == 1 ? 'item' : 'items'}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),

            // Cart Items and Summary
            isMobile
                ? _buildMobileLayout(context, cartRepo)
                : _buildDesktopLayout(context, cartRepo),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, CartRepository cartRepo) {
    return Column(
      children: [
        // Cart Items
        ...cartRepo.cartItems
            .map((item) => _buildCartItemCard(context, cartRepo, item, true)),
        const SizedBox(height: 24),
        // Summary
        _buildOrderSummary(context, cartRepo, true),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, CartRepository cartRepo) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cart Items (Left side - 65%)
        Expanded(
          flex: 65,
          child: Column(
            children: cartRepo.cartItems
                .map((item) =>
                    _buildCartItemCard(context, cartRepo, item, false))
                .toList(),
          ),
        ),
        const SizedBox(width: 32),
        // Order Summary (Right side - 35%)
        Expanded(
          flex: 35,
          child: _buildOrderSummary(context, cartRepo, false),
        ),
      ],
    );
  }

  Widget _buildCartItemCard(BuildContext context, CartRepository cartRepo,
      CartItem item, bool isMobile) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: isMobile
            ? _buildMobileCartItem(context, cartRepo, item)
            : _buildDesktopCartItem(context, cartRepo, item),
      ),
    );
  }

  Widget _buildMobileCartItem(
      BuildContext context, CartRepository cartRepo, CartItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            _buildProductImage(item, 80),
            const SizedBox(width: 12),
            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '£${item.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),
                  ),
                  if (item.selectedOptions != null &&
                      item.selectedOptions!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    _buildSelectedOptions(item),
                  ],
                ],
              ),
            ),
            // Remove button
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: () => cartRepo.removeCartItem(item),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Quantity Controls and Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildQuantityControls(cartRepo, item),
            Text(
              '£${item.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4d2963),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopCartItem(
      BuildContext context, CartRepository cartRepo, CartItem item) {
    return Row(
      children: [
        // Product Image
        _buildProductImage(item, 100),
        const SizedBox(width: 20),
        // Product Info
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              if (item.selectedOptions != null &&
                  item.selectedOptions!.isNotEmpty)
                _buildSelectedOptions(item),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Price
        Expanded(
          flex: 1,
          child: Text(
            '£${item.price.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(width: 16),
        // Quantity Controls
        _buildQuantityControls(cartRepo, item),
        const SizedBox(width: 16),
        // Total Price
        SizedBox(
          width: 100,
          child: Text(
            '£${item.totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4d2963),
            ),
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(width: 8),
        // Remove button
        IconButton(
          icon: const Icon(Icons.close, size: 22),
          onPressed: () => cartRepo.removeCartItem(item),
        ),
      ],
    );
  }

  Widget _buildProductImage(CartItem item, double size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        item.imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size,
            height: size,
            color: Colors.grey[300],
            child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
          );
        },
      ),
    );
  }

  Widget _buildSelectedOptions(CartItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: item.selectedOptions!.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            '${entry.key}: ${entry.value}',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuantityControls(CartRepository cartRepo, CartItem item) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 18),
            onPressed: () => cartRepo.decrementQuantity(item),
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '${item.quantity}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 18),
            onPressed: () => cartRepo.incrementQuantity(item),
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(
      BuildContext context, CartRepository cartRepo, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          _buildSummaryRow(
              'Subtotal', '£${cartRepo.cartTotal.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          _buildSummaryRow('Shipping', 'Calculated at checkout'),
          const SizedBox(height: 12),
          const Divider(thickness: 1),
          const SizedBox(height: 12),
          _buildSummaryRow(
            'Total',
            '£${cartRepo.cartTotal.toStringAsFixed(2)}',
            isTotal: true,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement checkout
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Checkout coming soon!'),
                  backgroundColor: Color(0xFF4d2963),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4d2963),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              'Proceed to Checkout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear Cart?'),
                  content: const Text(
                      'Are you sure you want to remove all items from your cart?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        cartRepo.clearCart();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Clear Cart',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              'Clear Cart',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 15,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? Colors.black : Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 15,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            color: isTotal ? const Color(0xFF4d2963) : Colors.black,
          ),
        ),
      ],
    );
  }
}
