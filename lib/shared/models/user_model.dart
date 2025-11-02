import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User model representing authenticated users
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    String? discordId,
    String? twitterId,
    String? walletAddress,
    @Default([]) List<String> roles,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

/// Customer model with extended profile information
@freezed
class CustomerModel with _$CustomerModel {
  const factory CustomerModel({
    required String id,
    required String userId,
    String? discordId,
    String? discordUsername,
    String? twitterId,
    String? twitterUsername,
    String? walletAddress,
    @Default([]) List<String> productIds,
    @Default([]) List<String> roles,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) = _CustomerModel;

  factory CustomerModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerModelFromJson(json);
}
