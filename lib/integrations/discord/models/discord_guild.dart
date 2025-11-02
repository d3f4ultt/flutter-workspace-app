import 'package:freezed_annotation/freezed_annotation.dart';

part 'discord_guild.freezed.dart';
part 'discord_guild.g.dart';

/// Discord guild (server) model
@freezed
class DiscordGuild with _$DiscordGuild {
  const factory DiscordGuild({
    required String id,
    required String name,
    String? icon,
    bool? owner,
    int? permissions,
    @Default([]) List<String> features,
  }) = _DiscordGuild;

  factory DiscordGuild.fromJson(Map<String, dynamic> json) =>
      _$DiscordGuildFromJson(json);
}
