import 'package:flutter/material.dart';

/// Checkout page for purchasing products
class CheckoutPage extends StatelessWidget {
  final String productId;

  const CheckoutPage({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Center(
        child: Text('Checkout for product: $productId'),
      ),
    );
  }
}
