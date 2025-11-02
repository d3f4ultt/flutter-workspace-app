import 'package:dio/dio.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';

import '../../core/config/env_config.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/logger.dart';
import 'models/twitter_user.dart';

/// Twitter OAuth2 integration service
/// Handles authentication and user data retrieval using OAuth 2.0 PKCE
class TwitterService {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  TwitterService({
    Dio? dio,
    FlutterSecureStorage? storage,
  })  : _dio = dio ?? Dio(BaseOptions(baseUrl: EnvConfig.twitterApiBaseUrl)),
        _storage = storage ?? const FlutterSecureStorage();

  /// Generate code verifier for PKCE
  String _generateCodeVerifier() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    return base64UrlEncode(values).replaceAll('=', '');
  }

  /// Generate code challenge from verifier
  String _generateCodeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }

  /// Authenticate user with Twitter OAuth2 PKCE
  Future<String> authenticateWithTwitter() async {
    try {
      // Generate PKCE parameters
      final codeVerifier = _generateCodeVerifier();
      final codeChallenge = _generateCodeChallenge(codeVerifier);

      // Store code verifier for token exchange
      await _storage.write(key: 'twitter_code_verifier', value: codeVerifier);

      final authUrl = Uri.https('twitter.com', '/i/oauth2/authorize', {
        'client_id': EnvConfig.twitterClientId,
        'redirect_uri': EnvConfig.twitterRedirectUri,
        'response_type': 'code',
        'scope': AppConstants.twitterScopes.join(' '),
        'code_challenge': codeChallenge,
        'code_challenge_method': 'S256',
        'state': _generateCodeVerifier(), // Random state for CSRF protection
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
        'https://api.twitter.com/2/oauth2/token',
        data: {
          'client_id': EnvConfig.twitterClientId,
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': EnvConfig.twitterRedirectUri,
          'code_verifier': codeVerifier,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      final accessToken = tokenResponse.data['access_token'] as String;
      final refreshToken = tokenResponse.data['refresh_token'] as String?;

      // Store tokens securely
      await _storage.write(key: 'twitter_access_token', value: accessToken);
      if (refreshToken != null) {
        await _storage.write(key: 'twitter_refresh_token', value: refreshToken);
      }

      AppLogger.info('Twitter authentication successful');
      return accessToken;
    } catch (e, stackTrace) {
      AppLogger.error('Twitter authentication error', e, stackTrace);
      rethrow;
    }
  }

  /// Get current Twitter user information
  Future<TwitterUser> getCurrentUser() async {
    try {
      final accessToken = await _storage.read(key: 'twitter_access_token');
      if (accessToken == null) {
        throw Exception('Not authenticated with Twitter');
      }

      final response = await _dio.get(
        '/users/me',
        queryParameters: {
          'user.fields': 'id,name,username,profile_image_url,verified',
        },
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      return TwitterUser.fromJson(response.data['data']);
    } catch (e, stackTrace) {
      AppLogger.error('Get Twitter user error', e, stackTrace);
      rethrow;
    }
  }

  /// Get user by ID
  Future<TwitterUser> getUserById(String userId) async {
    try {
      final accessToken = await _storage.read(key: 'twitter_access_token');
      if (accessToken == null) {
        throw Exception('Not authenticated with Twitter');
      }

      final response = await _dio.get(
        '/users/$userId',
        queryParameters: {
          'user.fields': 'id,name,username,profile_image_url,verified',
        },
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      return TwitterUser.fromJson(response.data['data']);
    } catch (e, stackTrace) {
      AppLogger.error('Get Twitter user by ID error', e, stackTrace);
      rethrow;
    }
  }

  /// Refresh access token
  Future<String> refreshAccessToken() async {
    try {
      final refreshToken = await _storage.read(key: 'twitter_refresh_token');
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      final response = await _dio.post(
        'https://api.twitter.com/2/oauth2/token',
        data: {
          'client_id': EnvConfig.twitterClientId,
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      final accessToken = response.data['access_token'] as String;
      final newRefreshToken = response.data['refresh_token'] as String?;

      await _storage.write(key: 'twitter_access_token', value: accessToken);
      if (newRefreshToken != null) {
        await _storage.write(key: 'twitter_refresh_token', value: newRefreshToken);
      }

      return accessToken;
    } catch (e, stackTrace) {
      AppLogger.error('Refresh Twitter token error', e, stackTrace);
      rethrow;
    }
  }

  /// Sign out from Twitter
  Future<void> signOut() async {
    await _storage.delete(key: 'twitter_access_token');
    await _storage.delete(key: 'twitter_refresh_token');
    await _storage.delete(key: 'twitter_code_verifier');
  }
}
