import 'package:dio/dio.dart';

import '../../core/config/env_config.dart';
import '../../core/utils/logger.dart';
import 'models/tradingview_script.dart';

/// TradingView integration service
/// Handles private script provisioning and access control
/// 
/// NOTE: This is a custom integration. TradingView does not have an official public API
/// for script management. This service assumes you have built or are using a backend
/// service that interfaces with TradingView's private script system.
/// 
/// Reference documentation:
/// - TradingView Pine Script: https://www.tradingview.com/pine-script-docs/
/// - TradingView API (unofficial): Custom implementation required
class TradingViewService {
  final Dio _dio;

  TradingViewService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: EnvConfig.tradingViewApiUrl,
              headers: {
                'Authorization': 'Bearer ${EnvConfig.tradingViewApiKey}',
              },
            ));

  /// Get all available scripts
  Future<List<TradingViewScript>> getScripts() async {
    try {
      final response = await _dio.get('/scripts');
      return (response.data as List)
          .map((json) => TradingViewScript.fromJson(json))
          .toList();
    } catch (e, stackTrace) {
      AppLogger.error('Get TradingView scripts error', e, stackTrace);
      rethrow;
    }
  }

  /// Get script by ID
  Future<TradingViewScript> getScriptById(String scriptId) async {
    try {
      final response = await _dio.get('/scripts/$scriptId');
      return TradingViewScript.fromJson(response.data);
    } catch (e, stackTrace) {
      AppLogger.error('Get TradingView script error', e, stackTrace);
      rethrow;
    }
  }

  /// Provision script access for a customer
  /// This grants a customer access to a private TradingView script
  Future<void> provisionScriptAccess({
    required String scriptId,
    required String customerId,
    required String customerEmail,
  }) async {
    try {
      await _dio.post('/scripts/$scriptId/provision', data: {
        'customer_id': customerId,
        'customer_email': customerEmail,
      });

      AppLogger.info('Script access provisioned: $scriptId for $customerId');
    } catch (e, stackTrace) {
      AppLogger.error('Provision script access error', e, stackTrace);
      rethrow;
    }
  }

  /// Revoke script access for a customer
  Future<void> revokeScriptAccess({
    required String scriptId,
    required String customerId,
  }) async {
    try {
      await _dio.delete('/scripts/$scriptId/provision/$customerId');

      AppLogger.info('Script access revoked: $scriptId for $customerId');
    } catch (e, stackTrace) {
      AppLogger.error('Revoke script access error', e, stackTrace);
      rethrow;
    }
  }

  /// Get customer's accessible scripts
  Future<List<TradingViewScript>> getCustomerScripts(String customerId) async {
    try {
      final response = await _dio.get('/customers/$customerId/scripts');
      return (response.data as List)
          .map((json) => TradingViewScript.fromJson(json))
          .toList();
    } catch (e, stackTrace) {
      AppLogger.error('Get customer scripts error', e, stackTrace);
      rethrow;
    }
  }

  /// Create a new script listing
  Future<TradingViewScript> createScript({
    required String name,
    required String description,
    required String scriptUrl,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _dio.post('/scripts', data: {
        'name': name,
        'description': description,
        'script_url': scriptUrl,
        'metadata': metadata,
      });

      return TradingViewScript.fromJson(response.data);
    } catch (e, stackTrace) {
      AppLogger.error('Create TradingView script error', e, stackTrace);
      rethrow;
    }
  }

  /// Update script information
  Future<TradingViewScript> updateScript({
    required String scriptId,
    String? name,
    String? description,
    String? scriptUrl,
    bool? isActive,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _dio.patch('/scripts/$scriptId', data: {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (scriptUrl != null) 'script_url': scriptUrl,
        if (isActive != null) 'is_active': isActive,
        if (metadata != null) 'metadata': metadata,
      });

      return TradingViewScript.fromJson(response.data);
    } catch (e, stackTrace) {
      AppLogger.error('Update TradingView script error', e, stackTrace);
      rethrow;
    }
  }

  /// Delete a script
  Future<void> deleteScript(String scriptId) async {
    try {
      await _dio.delete('/scripts/$scriptId');
      AppLogger.info('Script deleted: $scriptId');
    } catch (e, stackTrace) {
      AppLogger.error('Delete TradingView script error', e, stackTrace);
      rethrow;
    }
  }
}
