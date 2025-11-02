import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/models/product_model.dart';
import '../../../shared/repositories/product_repository.dart';
import '../../../shared/providers/auth_provider.dart';

/// Product provider for checkout
final checkoutProductProvider =
    FutureProvider.family<ProductModel?, String>((ref, productId) async {
  final repository = ProductRepository();
  return repository.getProductById(productId);
});

/// Checkout page for purchasing products
class CheckoutPage extends ConsumerStatefulWidget {
  final String productId;

  const CheckoutPage({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  String _selectedPaymentMethod = 'crypto';
  String _selectedCrypto = 'ETH';
  bool _isProcessing = false;

  Future<void> _processPayment(ProductModel product) async {
    final user = await ref.read(currentUserProvider.future);
    
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login to continue'),
            backgroundColor: Colors.red,
          ),
        );
        context.push('/login');
      }
      return;
    }

    setState(() => _isProcessing = true);

    try {
      // TODO: Implement actual payment processing
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment processed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(checkoutProductProvider(widget.productId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: productAsync.when(
        data: (product) {
          if (product == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Product not found',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/marketplace'),
                    child: const Text('Back to Marketplace'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Product Summary
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order Summary',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                if (product.imageUrl != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      product.imageUrl!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stack) {
                                        return Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.grey.shade200,
                                          child: const Icon(Icons.image),
                                        );
                                      },
                                    ),
                                  ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        product.description,
                                        style:
                                            Theme.of(context).textTheme.bodySmall,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Theme.of(context).colorScheme.primary,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Payment Method Selection
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Payment Method',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16),

                            // Crypto Payment
                            RadioListTile<String>(
                              title: const Text('Cryptocurrency'),
                              subtitle: const Text('Pay with ETH, SOL, or BTC'),
                              value: 'crypto',
                              groupValue: _selectedPaymentMethod,
                              onChanged: _isProcessing
                                  ? null
                                  : (value) {
                                      setState(() {
                                        _selectedPaymentMethod = value!;
                                      });
                                    },
                            ),

                            if (_selectedPaymentMethod == 'crypto') ...[
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Wrap(
                                  spacing: 8,
                                  children: [
                                    ChoiceChip(
                                      label: const Text('ETH'),
                                      selected: _selectedCrypto == 'ETH',
                                      onSelected: _isProcessing
                                          ? null
                                          : (selected) {
                                              if (selected) {
                                                setState(() {
                                                  _selectedCrypto = 'ETH';
                                                });
                                              }
                                            },
                                    ),
                                    ChoiceChip(
                                      label: const Text('SOL'),
                                      selected: _selectedCrypto == 'SOL',
                                      onSelected: _isProcessing
                                          ? null
                                          : (selected) {
                                              if (selected) {
                                                setState(() {
                                                  _selectedCrypto = 'SOL';
                                                });
                                              }
                                            },
                                    ),
                                    ChoiceChip(
                                      label: const Text('BTC'),
                                      selected: _selectedCrypto == 'BTC',
                                      onSelected: _isProcessing
                                          ? null
                                          : (selected) {
                                              if (selected) {
                                                setState(() {
                                                  _selectedCrypto = 'BTC';
                                                });
                                              }
                                            },
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            const Divider(height: 24),

                            // Card Payment
                            RadioListTile<String>(
                              title: const Text('Credit/Debit Card'),
                              subtitle: const Text('Pay with Stripe'),
                              value: 'stripe',
                              groupValue: _selectedPaymentMethod,
                              onChanged: _isProcessing
                                  ? null
                                  : (value) {
                                      setState(() {
                                        _selectedPaymentMethod = value!;
                                      });
                                    },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Complete Purchase Button
                    ElevatedButton(
                      onPressed: _isProcessing
                          ? null
                          : () => _processPayment(product),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isProcessing
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Complete Purchase - \$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                    ),

                    const SizedBox(height: 16),

                    // Terms and Conditions
                    Text(
                      'By completing this purchase, you agree to our Terms of Service and Privacy Policy.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading product',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/marketplace'),
                child: const Text('Back to Marketplace'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
