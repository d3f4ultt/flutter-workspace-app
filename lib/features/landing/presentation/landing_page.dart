import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Landing page with marketing content and call-to-action
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            title: const Text('SaaS Platform'),
            actions: [
              TextButton(
                onPressed: () => context.push('/login'),
                child: const Text('Login'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => context.push('/register'),
                child: const Text('Sign Up'),
              ),
              const SizedBox(width: 16),
            ],
          ),

          // Hero Section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(48),
              child: Column(
                children: [
                  const SizedBox(height: 48),
                  Text(
                    'The Ultimate SaaS Marketplace',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Sell digital products, manage Discord roles, provision TradingView scripts, and accept crypto payments - all in one platform.',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => context.push('/register'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 24,
                          ),
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton(
                        onPressed: () => context.push('/marketplace'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 24,
                          ),
                        ),
                        child: const Text(
                          'Browse Marketplace',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Features Section
          SliverPadding(
            padding: const EdgeInsets.all(48),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                childAspectRatio: 1.2,
              ),
              delegate: SliverChildListDelegate([
                _FeatureCard(
                  icon: Icons.discord,
                  title: 'Discord Integration',
                  description:
                      'Automatically manage Discord roles based on purchases',
                ),
                _FeatureCard(
                  icon: Icons.show_chart,
                  title: 'TradingView Scripts',
                  description:
                      'Provision and control access to private TradingView scripts',
                ),
                _FeatureCard(
                  icon: Icons.account_balance_wallet,
                  title: 'Crypto Payments',
                  description: 'Accept ETH, SOL, BTC, and fiat payments',
                ),
                _FeatureCard(
                  icon: Icons.dashboard,
                  title: 'Creator Dashboard',
                  description:
                      'Manage products, customers, and analytics in one place',
                ),
                _FeatureCard(
                  icon: Icons.link,
                  title: 'Social Auth',
                  description: 'Login with Discord, Twitter, or Web3 wallet',
                ),
                _FeatureCard(
                  icon: Icons.shopping_cart,
                  title: 'Marketplace',
                  description: 'Beautiful storefront for your digital products',
                ),
              ]),
            ),
          ),

          // CTA Section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(48),
              margin: const EdgeInsets.all(48),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Ready to get started?',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Join thousands of creators selling digital products',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => context.push('/register'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 24,
                      ),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Footer
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Text(
                '© 2024 SaaS Platform. All rights reserved.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
