import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/product_model.dart';
import '../../core/utils/logger.dart';

/// Product repository for database operations
class ProductRepository {
  final _supabase = Supabase.instance.client;

  /// Get all products
  Future<List<ProductModel>> getProducts({bool? isActive}) async {
    try {
      var query = _supabase.from('products').select();
      
      if (isActive != null) {
        query = query.eq('is_active', isActive);
      }

      final response = await query.order('created_at', ascending: false);
      
      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e, stackTrace) {
      AppLogger.error('Get products error', e, stackTrace);
      rethrow;
    }
  }

  /// Get product by ID
  Future<ProductModel?> getProductById(String id) async {
    try {
      final response = await _supabase
          .from('products')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return ProductModel.fromJson(response);
    } catch (e, stackTrace) {
      AppLogger.error('Get product by ID error', e, stackTrace);
      rethrow;
    }
  }

  /// Create new product
  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      final response = await _supabase
          .from('products')
          .insert(product.toJson())
          .select()
          .single();

      return ProductModel.fromJson(response);
    } catch (e, stackTrace) {
      AppLogger.error('Create product error', e, stackTrace);
      rethrow;
    }
  }

  /// Update product
  Future<ProductModel> updateProduct(ProductModel product) async {
    try {
      final response = await _supabase
          .from('products')
          .update(product.toJson())
          .eq('id', product.id)
          .select()
          .single();

      return ProductModel.fromJson(response);
    } catch (e, stackTrace) {
      AppLogger.error('Update product error', e, stackTrace);
      rethrow;
    }
  }

  /// Delete product
  Future<void> deleteProduct(String id) async {
    try {
      await _supabase.from('products').delete().eq('id', id);
    } catch (e, stackTrace) {
      AppLogger.error('Delete product error', e, stackTrace);
      rethrow;
    }
  }

  /// Get products by type
  Future<List<ProductModel>> getProductsByType(String type) async {
    try {
      final response = await _supabase
          .from('products')
          .select()
          .eq('type', type)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e, stackTrace) {
      AppLogger.error('Get products by type error', e, stackTrace);
      rethrow;
    }
  }
}
