import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/product_model.dart';
import '../../core/utils/logger.dart';

/// Purchase repository for database operations
class PurchaseRepository {
  final _supabase = Supabase.instance.client;

  /// Get all purchases
  Future<List<PurchaseModel>> getPurchases() async {
    try {
      final response = await _supabase
          .from('purchases')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => PurchaseModel.fromJson(json))
          .toList();
    } catch (e, stackTrace) {
      AppLogger.error('Get purchases error', e, stackTrace);
      rethrow;
    }
  }

  /// Get purchase by ID
  Future<PurchaseModel?> getPurchaseById(String id) async {
    try {
      final response = await _supabase
          .from('purchases')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return PurchaseModel.fromJson(response);
    } catch (e, stackTrace) {
      AppLogger.error('Get purchase by ID error', e, stackTrace);
      rethrow;
    }
  }

  /// Get purchases by customer ID
  Future<List<PurchaseModel>> getPurchasesByCustomerId(String customerId) async {
    try {
      final response = await _supabase
          .from('purchases')
          .select()
          .eq('customer_id', customerId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => PurchaseModel.fromJson(json))
          .toList();
    } catch (e, stackTrace) {
      AppLogger.error('Get purchases by customer ID error', e, stackTrace);
      rethrow;
    }
  }

  /// Get purchases by product ID
  Future<List<PurchaseModel>> getPurchasesByProductId(String productId) async {
    try {
      final response = await _supabase
          .from('purchases')
          .select()
          .eq('product_id', productId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => PurchaseModel.fromJson(json))
          .toList();
    } catch (e, stackTrace) {
      AppLogger.error('Get purchases by product ID error', e, stackTrace);
      rethrow;
    }
  }

  /// Create new purchase
  Future<PurchaseModel> createPurchase(PurchaseModel purchase) async {
    try {
      final response = await _supabase
          .from('purchases')
          .insert(purchase.toJson())
          .select()
          .single();

      return PurchaseModel.fromJson(response);
    } catch (e, stackTrace) {
      AppLogger.error('Create purchase error', e, stackTrace);
      rethrow;
    }
  }

  /// Update purchase status
  Future<PurchaseModel> updatePurchaseStatus({
    required String id,
    required String status,
  }) async {
    try {
      final response = await _supabase
          .from('purchases')
          .update({
            'status': status,
            if (status == 'completed')
              'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id)
          .select()
          .single();

      return PurchaseModel.fromJson(response);
    } catch (e, stackTrace) {
      AppLogger.error('Update purchase status error', e, stackTrace);
      rethrow;
    }
  }

  /// Get purchases by status
  Future<List<PurchaseModel>> getPurchasesByStatus(String status) async {
    try {
      final response = await _supabase
          .from('purchases')
          .select()
          .eq('status', status)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => PurchaseModel.fromJson(json))
          .toList();
    } catch (e, stackTrace) {
      AppLogger.error('Get purchases by status error', e, stackTrace);
      rethrow;
    }
  }

  /// Get total revenue
  Future<double> getTotalRevenue() async {
    try {
      final response = await _supabase
          .from('purchases')
          .select('amount')
          .eq('status', 'completed');

      double total = 0;
      for (var purchase in response as List) {
        total += (purchase['amount'] as num).toDouble();
      }

      return total;
    } catch (e, stackTrace) {
      AppLogger.error('Get total revenue error', e, stackTrace);
      rethrow;
    }
  }
}
