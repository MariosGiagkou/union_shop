import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/layout.dart';
import '../repositories/cart_repository.dart';
import '../models/cart_item.dart';
import '../services/auth_service.dart';
import '../services/order_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isProcessing = false;

  Future<void> _handleCheckout(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final cartRepo = Provider.of<CartRepository>(context, listen: false);

    // Check if user is signed in
    if (!authService.isSignedIn) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please sign in to checkout'),
            backgroundColor: Color(0xFF4d2963),
          ),
        );
        context.go('/sign-in');
      }
      return;
    }

    // Check if cart is empty
    if (cartRepo.isEmpty) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final orderService = OrderService();

      // Create order
      final orderId = await orderService.createOrder(
        userId: authService.currentUser!.uid,
        items: cartRepo.cartItems,
        total: cartRepo.cartTotal,
      );

      // Clear cart
      cartRepo.clearCart();

      if (context.mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Order placed successfully! Order ID: ${orderId.substring(0, 8)}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );

        // Navigate to order history
        context.go('/order-history');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error placing order: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

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
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pushNamed('/'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4d2963),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            ),
            child: const Text(
              'Continue Shopping',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartRepository cartRepo) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page Title
                Text(
                  'Shopping Cart',
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[900],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${cartRepo.itemCount} ${cartRepo.itemCount == 1 ? 'item' : 'items'}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),

                // Cart Items and Summary
                isMobile
                    ? _buildMobileLayout(context, cartRepo)
                    : _buildDesktopLayout(context, cartRepo),
              ],
            ),
          ),
          // Footer at the bottom of scrollable content
          const SiteFooter(),
        ],
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
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
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
        // Product Image - very compact for tight spacing
        _buildProductImage(item, 60),
        const SizedBox(width: 8),
        // Product Info - Expanded to take available space
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 4),
              if (item.selectedOptions != null &&
                  item.selectedOptions!.isNotEmpty)
                _buildSelectedOptions(item),
            ],
          ),
        ),
        const SizedBox(width: 4),
        // Price - Very compact display
        Text(
          '£${item.price.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 12),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(width: 4),
        // Quantity Controls - Already has intrinsic width (~84px)
        _buildQuantityControls(cartRepo, item),
        const SizedBox(width: 4),
        // Total Price - Compact display
        Text(
          '£${item.totalPrice.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF4d2963),
          ),
          overflow: TextOverflow.ellipsis,
        ),
        // Remove button - minimal padding
        IconButton(
          icon: const Icon(Icons.close, size: 18),
          padding: const EdgeInsets.all(2),
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
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
            icon: const Icon(Icons.remove, size: 16),
            onPressed: () => cartRepo.decrementQuantity(item),
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            constraints: const BoxConstraints(minWidth: 24),
            child: Text(
              '${item.quantity}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 16),
            onPressed: () => cartRepo.incrementQuantity(item),
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(
      BuildContext context, CartRepository cartRepo, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow(
              'Subtotal', '£${cartRepo.cartTotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Total',
            '£${cartRepo.cartTotal.toStringAsFixed(2)}',
            isTotal: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isProcessing ? null : () => _handleCheckout(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4d2963),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: _isProcessing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Checkout',
                    style: TextStyle(
                      fontSize: 15,
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
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 15,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: isTotal ? Colors.black : Colors.grey[700],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 15,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            color: isTotal ? const Color(0xFF4d2963) : Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
