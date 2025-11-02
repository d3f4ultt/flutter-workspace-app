import 'package:dio/dio.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/config/env_config.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/logger.dart';
import 'models/discord_user.dart';
import 'models/discord_guild.dart';

/// Discord OAuth2 and API integration service
/// Handles authentication, role management, and guild operations
class DiscordService {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  DiscordService({
    Dio? dio,
    FlutterSecureStorage? storage,
  })  : _dio = dio ?? Dio(BaseOptions(baseUrl: EnvConfig.discordApiBaseUrl)),
        _storage = storage ?? const FlutterSecureStorage();

  /// Authenticate user with Discord OAuth2
  Future<String> authenticateWithDiscord() async {
    try {
      final authUrl = Uri.https('discord.com', '/api/oauth2/authorize', {
        'client_id': EnvConfig.discordClientId,
        'redirect_uri': EnvConfig.discordRedirectUri,
        'response_type': 'code',
        'scope': AppConstants.discordScopes.join(' '),
      });

      // Open OAuth flow
      final result = await FlutterWebAuth2.authenticate(
        url: authUrl.toString(),
        callbackUrlScheme: EnvConfig.appScheme,
      );

      // Extract authorization code
      final code = Uri.parse(result).queryParameters['code'];
      if (code == null) {
        throw Exception('Authorization code not found');
      }

      // Exchange code for access token
      final tokenResponse = await _dio.post(
        'https://discord.com/api/oauth2/token',
        data: {
          'client_id': EnvConfig.discordClientId,
          'client_secret': EnvConfig.discordClientSecret,
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': EnvConfig.discordRedirectUri,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      final accessToken = tokenResponse.data['access_token'] as String;
      final refreshToken = tokenResponse.data['refresh_token'] as String;

      // Store tokens securely
      await _storage.write(key: 'discord_access_token', value: accessToken);
      await _storage.write(key: 'discord_refresh_token', value: refreshToken);

      AppLogger.info('Discord authentication successful');
      return accessToken;
    } catch (e, stackTrace) {
      AppLogger.error('Discord authentication error', e, stackTrace);
      rethrow;
    }
  }

  /// Get current Discord user information
  Future<DiscordUser> getCurrentUser() async {
    try {
      final accessToken = await _storage.read(key: 'discord_access_token');
      if (accessToken == null) {
        throw Exception('Not authenticated with Discord');
      }

      final response = await _dio.get(
        '/users/@me',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      return DiscordUser.fromJson(response.data);
    } catch (e, stackTrace) {
      AppLogger.error('Get Discord user error', e, stackTrace);
      rethrow;
    }
  }

  /// Get user's Discord guilds (servers)
  Future<List<DiscordGuild>> getUserGuilds() async {
    try {
      final accessToken = await _storage.read(key: 'discord_access_token');
      if (accessToken == null) {
        throw Exception('Not authenticated with Discord');
      }

      final response = await _dio.get(
        '/users/@me/guilds',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      return (response.data as List)
          .map((json) => DiscordGuild.fromJson(json))
          .toList();
    } catch (e, stackTrace) {
      AppLogger.error('Get Discord guilds error', e, stackTrace);
      rethrow;
    }
  }

  /// Assign role to user in a guild (requires bot token)
  Future<void> assignRole({
    required String guildId,
    required String userId,
    required String roleId,
  }) async {
    try {
      await _dio.put(
        '/guilds/$guildId/members/$userId/roles/$roleId',
        options: Options(
          headers: {'Authorization': 'Bot ${EnvConfig.discordBotToken}'},
        ),
      );

      AppLogger.info('Discord role assigned: $roleId to user $userId');
    } catch (e, stackTrace) {
      AppLogger.error('Assign Discord role error', e, stackTrace);
      rethrow;
    }
  }

  /// Remove role from user in a guild (requires bot token)
  Future<void> removeRole({
    required String guildId,
    required String userId,
    required String roleId,
  }) async {
    try {
      await _dio.delete(
        '/guilds/$guildId/members/$userId/roles/$roleId',
        options: Options(
          headers: {'Authorization': 'Bot ${EnvConfig.discordBotToken}'},
        ),
      );

      AppLogger.info('Discord role removed: $roleId from user $userId');
    } catch (e, stackTrace) {
      AppLogger.error('Remove Discord role error', e, stackTrace);
      rethrow;
    }
  }

  /// Get guild member information
  Future<Map<String, dynamic>> getGuildMember({
    required String guildId,
    required String userId,
  }) async {
    try {
      final response = await _dio.get(
        '/guilds/$guildId/members/$userId',
        options: Options(
          headers: {'Authorization': 'Bot ${EnvConfig.discordBotToken}'},
        ),
      );

      return response.data;
    } catch (e, stackTrace) {
      AppLogger.error('Get guild member error', e, stackTrace);
      rethrow;
    }
  }

  /// Refresh access token
  Future<String> refreshAccessToken() async {
    try {
      final refreshToken = await _storage.read(key: 'discord_refresh_token');
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      final response = await _dio.post(
        'https://discord.com/api/oauth2/token',
        data: {
          'client_id': EnvConfig.discordClientId,
          'client_secret': EnvConfig.discordClientSecret,
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      final accessToken = response.data['access_token'] as String;
      final newRefreshToken = response.data['refresh_token'] as String;

      await _storage.write(key: 'discord_access_token', value: accessToken);
      await _storage.write(key: 'discord_refresh_token', value: newRefreshToken);

      return accessToken;
    } catch (e, stackTrace) {
      AppLogger.error('Refresh Discord token error', e, stackTrace);
      rethrow;
    }
  }

  /// Sign out from Discord
  Future<void> signOut() async {
    await _storage.delete(key: 'discord_access_token');
    await _storage.delete(key: 'discord_refresh_token');
  }
}
