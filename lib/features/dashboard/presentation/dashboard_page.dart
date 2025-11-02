import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/providers/auth_provider.dart';

/// Dashboard page for creators/admins
/// Provides management interface for products, customers, and integrations
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Show notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.rocket_launch,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'SaaS Platform',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  userAsync.when(
                    data: (user) => Text(
                      user?.email ?? '',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    loading: () => const SizedBox(),
                    error: (_, __) => const SizedBox(),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              selected: true,
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text('Products'),
              onTap: () {
                // TODO: Navigate to products
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Customers'),
              onTap: () {
                // TODO: Navigate to customers
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Payments'),
              onTap: () {
                // TODO: Navigate to payments
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.discord),
              title: const Text('Discord Integration'),
              onTap: () {
                // TODO: Navigate to Discord settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.show_chart),
              title: const Text('TradingView Scripts'),
              onTap: () {
                // TODO: Navigate to TradingView scripts
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // TODO: Navigate to settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                final authService = ref.read(authServiceProvider);
                await authService.signOut();
                if (context.mounted) {
                  context.go('/');
                }
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Here\'s what\'s happening with your business today.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),

            // Stats Cards
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = constraints.maxWidth > 800
                    ? (constraints.maxWidth - 48) / 4
                    : (constraints.maxWidth - 24) / 2;

                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(
                      width: cardWidth,
                      child: _StatCard(
                        title: 'Total Revenue',
                        value: '\$12,345',
                        icon: Icons.attach_money,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: _StatCard(
                        title: 'Active Customers',
                        value: '234',
                        icon: Icons.people,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: _StatCard(
                        title: 'Products',
                        value: '12',
                        icon: Icons.shopping_bag,
                        color: Colors.purple,
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: _StatCard(
                        title: 'Conversions',
                        value: '89%',
                        icon: Icons.trending_up,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 48),

            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _ActionCard(
                  title: 'Create Product',
                  icon: Icons.add_shopping_cart,
                  onTap: () {
                    // TODO: Create product
                  },
                ),
                _ActionCard(
                  title: 'Manage Discord Roles',
                  icon: Icons.discord,
                  onTap: () {
                    // TODO: Manage Discord roles
                  },
                ),
                _ActionCard(
                  title: 'Add TradingView Script',
                  icon: Icons.show_chart,
                  onTap: () {
                    // TODO: Add TradingView script
                  },
                ),
                _ActionCard(
                  title: 'View Analytics',
                  icon: Icons.analytics,
                  onTap: () {
                    // TODO: View analytics
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Icon(icon, color: color),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
