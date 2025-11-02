import 'package:freezed_annotation/freezed_annotation.dart';

part 'discord_user.freezed.dart';
part 'discord_user.g.dart';

/// Discord user model
@freezed
class DiscordUser with _$DiscordUser {
  const factory DiscordUser({
    required String id,
    required String username,
    required String discriminator,
    String? email,
    bool? verified,
    String? avatar,
    String? banner,
    int? accentColor,
    bool? bot,
    bool? system,
    bool? mfaEnabled,
    String? locale,
    int? flags,
    int? premiumType,
    int? publicFlags,
  }) = _DiscordUser;

  factory DiscordUser.fromJson(Map<String, dynamic> json) =>
      _$DiscordUserFromJson(json);
}
