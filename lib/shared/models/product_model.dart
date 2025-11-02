import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

/// Product model for marketplace items
@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String id,
    required String name,
    required String description,
    required double price,
    required String type, // 'script', 'role', 'subscription', 'one_time'
    String? imageUrl,
    @Default([]) List<String> features,
    Map<String, dynamic>? accessConfig,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}

/// Purchase model for tracking customer purchases
@freezed
class PurchaseModel with _$PurchaseModel {
  const factory PurchaseModel({
    required String id,
    required String customerId,
    required String productId,
    required double amount,
    required String paymentMethod, // 'crypto', 'stripe', 'flutterwave'
    required String status, // 'pending', 'completed', 'failed', 'refunded'
    String? transactionHash,
    String? network,
    DateTime? createdAt,
    DateTime? completedAt,
    Map<String, dynamic>? metadata,
  }) = _PurchaseModel;

  factory PurchaseModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseModelFromJson(json);
}
