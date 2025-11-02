import 'package:freezed_annotation/freezed_annotation.dart';

part 'twitter_user.freezed.dart';
part 'twitter_user.g.dart';

/// Twitter user model
@freezed
class TwitterUser with _$TwitterUser {
  const factory TwitterUser({
    required String id,
    required String name,
    required String username,
    String? profileImageUrl,
    bool? verified,
    String? description,
    int? followersCount,
    int? followingCount,
  }) = _TwitterUser;

  factory TwitterUser.fromJson(Map<String, dynamic> json) =>
      _$TwitterUserFromJson(json);
}
