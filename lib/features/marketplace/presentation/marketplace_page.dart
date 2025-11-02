import 'package:flutter/material.dart';

/// Marketplace page displaying available products
class MarketplacePage extends StatelessWidget {
  const MarketplacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
      ),
      body: const Center(
        child: Text('Marketplace - Coming Soon'),
      ),
    );
  }
}
