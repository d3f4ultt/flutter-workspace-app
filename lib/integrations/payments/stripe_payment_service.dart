import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:dio/dio.dart';

import '../../core/config/env_config.dart';
import '../../core/utils/logger.dart';

/// Stripe payment service
/// Handles fiat payments via Stripe
class StripePaymentService {
  final Dio _dio;

  StripePaymentService({Dio? dio})
      : _dio = dio ?? Dio();

  /// Initialize Stripe
  static Future<void> initialize() async {
    Stripe.publishableKey = EnvConfig.stripePublishableKey;
    await Stripe.instance.applySettings();
    AppLogger.info('Stripe initialized');
  }

  /// Create payment intent on your backend
  /// This should call your Supabase Edge Function or backend API
  Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required String currency,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // TODO: Replace with your backend endpoint
      final response = await _dio.post(
        'YOUR_BACKEND_URL/create-payment-intent',
        data: {
          'amount': (amount * 100).toInt(), // Convert to cents
          'currency': currency.toLowerCase(),
          'metadata': metadata,
        },
      );

      return response.data;
    } catch (e, stackTrace) {
      AppLogger.error('Create payment intent error', e, stackTrace);
      rethrow;
    }
  }

  /// Process payment with Stripe
  Future<void> processPayment({
    required double amount,
    required String currency,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Create payment intent
      final paymentIntent = await createPaymentIntent(
        amount: amount,
        currency: currency,
        metadata: metadata,
      );

      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['clientSecret'],
          merchantDisplayName: EnvConfig.appName,
          style: ThemeMode.system,
        ),
      );

      // Present payment sheet
      await Stripe.instance.presentPaymentSheet();

      AppLogger.info('Stripe payment successful');
    } catch (e, stackTrace) {
      AppLogger.error('Stripe payment error', e, stackTrace);
      rethrow;
    }
  }

  /// Confirm payment
  Future<bool> confirmPayment(String paymentIntentId) async {
    try {
      // TODO: Call your backend to confirm payment
      final response = await _dio.post(
        'YOUR_BACKEND_URL/confirm-payment',
        data: {'payment_intent_id': paymentIntentId},
      );

      return response.data['status'] == 'succeeded';
    } catch (e, stackTrace) {
      AppLogger.error('Confirm payment error', e, stackTrace);
      return false;
    }
  }

  /// Create customer on Stripe
  Future<String> createCustomer({
    required String email,
    String? name,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _dio.post(
        'YOUR_BACKEND_URL/create-customer',
        data: {
          'email': email,
          if (name != null) 'name': name,
          'metadata': metadata,
        },
      );

      return response.data['customer_id'];
    } catch (e, stackTrace) {
      AppLogger.error('Create Stripe customer error', e, stackTrace);
      rethrow;
    }
  }

  /// Create subscription
  Future<Map<String, dynamic>> createSubscription({
    required String customerId,
    required String priceId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _dio.post(
        'YOUR_BACKEND_URL/create-subscription',
        data: {
          'customer_id': customerId,
          'price_id': priceId,
          'metadata': metadata,
        },
      );

      return response.data;
    } catch (e, stackTrace) {
      AppLogger.error('Create subscription error', e, stackTrace);
      rethrow;
    }
  }

  /// Cancel subscription
  Future<void> cancelSubscription(String subscriptionId) async {
    try {
      await _dio.post(
        'YOUR_BACKEND_URL/cancel-subscription',
        data: {'subscription_id': subscriptionId},
      );

      AppLogger.info('Subscription cancelled: $subscriptionId');
    } catch (e, stackTrace) {
      AppLogger.error('Cancel subscription error', e, stackTrace);
      rethrow;
    }
  }
}
