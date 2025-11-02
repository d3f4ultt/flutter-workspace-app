import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/landing/presentation/landing_page.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/register_page.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/marketplace/presentation/marketplace_page.dart';
import '../../features/checkout/presentation/checkout_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../shared/providers/auth_provider.dart';

part 'app_router.g.dart';

/// App router provider using GoRouter
/// Handles navigation and route guards
@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuthenticated = authState.value != null;
      final isAuthRoute = state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/register');
      final isPublicRoute = state.matchedLocation == '/' ||
          state.matchedLocation.startsWith('/marketplace');

      // Redirect to dashboard if authenticated and trying to access auth pages
      if (isAuthenticated && isAuthRoute) {
        return '/dashboard';
      }

      // Redirect to login if not authenticated and trying to access protected pages
      if (!isAuthenticated && !isPublicRoute && !isAuthRoute) {
        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'landing',
        builder: (context, state) => const LandingPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/marketplace',
        name: 'marketplace',
        builder: (context, state) => const MarketplacePage(),
      ),
      GoRoute(
        path: '/checkout/:productId',
        name: 'checkout',
        builder: (context, state) {
          final productId = state.pathParameters['productId']!;
          return CheckoutPage(productId: productId);
        },
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              '404 - Page Not Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
