import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';
import '../../core/utils/logger.dart';

/// Customer repository for database operations
class CustomerRepository {
  final _supabase = Supabase.instance.client;

  /// Get all customers
  Future<List<CustomerModel>> getCustomers() async {
    try {
      final response = await _supabase
          .from('customers')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => CustomerModel.fromJson(json))
          .toList();
    } catch (e, stackTrace) {
      AppLogger.error('Get customers error', e, stackTrace);
      rethrow;
    }
  }

  /// Get customer by ID
  Future<CustomerModel?> getCustomerById(String id) async {
    try {
      final response = await _supabase
          .from('customers')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return CustomerModel.fromJson(response);
    } catch (e, stackTrace) {
      AppLogger.error('Get customer by ID error', e, stackTrace);
      rethrow;
    }
  }

  /// Get customer by user ID
  Future<CustomerModel?> getCustomerByUserId(String userId) async {
    try {
      final response = await _supabase
          .from('customers')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) return null;
      return CustomerModel.fromJson(response);
    } catch (e, stackTrace) {
      AppLogger.error('Get customer by user ID error', e, stackTrace);
      rethrow;
    }
  }

  /// Create new customer
  Future<CustomerModel> createCustomer(CustomerModel customer) async {
    try {
      final response = await _supabase
          .from('customers')
          .insert(customer.toJson())
          .select()
          .single();

      return CustomerModel.fromJson(response);
    } catch (e, stackTrace) {
      AppLogger.error('Create customer error', e, stackTrace);
      rethrow;
    }
  }

  /// Update customer
  Future<CustomerModel> updateCustomer(CustomerModel customer) async {
    try {
      final response = await _supabase
          .from('customers')
          .update(customer.toJson())
          .eq('id', customer.id)
          .select()
          .single();

      return CustomerModel.fromJson(response);
    } catch (e, stackTrace) {
      AppLogger.error('Update customer error', e, stackTrace);
      rethrow;
    }
  }

  /// Link Discord account
  Future<void> linkDiscordAccount({
    required String customerId,
    required String discordId,
    required String discordUsername,
  }) async {
    try {
      await _supabase.from('customers').update({
        'discord_id': discordId,
        'discord_username': discordUsername,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', customerId);
    } catch (e, stackTrace) {
      AppLogger.error('Link Discord account error', e, stackTrace);
      rethrow;
    }
  }

  /// Link Twitter account
  Future<void> linkTwitterAccount({
    required String customerId,
    required String twitterId,
    required String twitterUsername,
  }) async {
    try {
      await _supabase.from('customers').update({
        'twitter_id': twitterId,
        'twitter_username': twitterUsername,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', customerId);
    } catch (e, stackTrace) {
      AppLogger.error('Link Twitter account error', e, stackTrace);
      rethrow;
    }
  }

  /// Link wallet address
  Future<void> linkWalletAddress({
    required String customerId,
    required String walletAddress,
  }) async {
    try {
      await _supabase.from('customers').update({
        'wallet_address': walletAddress,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', customerId);
    } catch (e, stackTrace) {
      AppLogger.error('Link wallet address error', e, stackTrace);
      rethrow;
    }
  }

  /// Add product to customer
  Future<void> addProductToCustomer({
    required String customerId,
    required String productId,
  }) async {
    try {
      final customer = await getCustomerById(customerId);
      if (customer == null) {
        throw Exception('Customer not found');
      }

      final productIds = [...customer.productIds, productId];

      await _supabase.from('customers').update({
        'product_ids': productIds,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', customerId);
    } catch (e, stackTrace) {
      AppLogger.error('Add product to customer error', e, stackTrace);
      rethrow;
    }
  }
}
