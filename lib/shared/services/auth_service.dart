import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';
import '../../core/utils/logger.dart';

/// Authentication service handling user auth operations
class AuthService {
  final _supabase = Supabase.instance.client;

  /// Sign up with email and password
  Future<UserModel?> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Sign up failed');
      }

      return await getCurrentUser();
    } catch (e, stackTrace) {
      AppLogger.error('Sign up error', e, stackTrace);
      rethrow;
    }
  }

  /// Sign in with email and password
  Future<UserModel?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Sign in failed');
      }

      return await getCurrentUser();
    } catch (e, stackTrace) {
      AppLogger.error('Sign in error', e, stackTrace);
      rethrow;
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e, stackTrace) {
      AppLogger.error('Sign out error', e, stackTrace);
      rethrow;
    }
  }

  /// Get current authenticated user
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      // Fetch additional user data from database
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response == null) {
        // Create user record if it doesn't exist
        await _supabase.from('users').insert({
          'id': user.id,
          'email': user.email,
          'created_at': DateTime.now().toIso8601String(),
        });

        return UserModel(
          id: user.id,
          email: user.email!,
          createdAt: DateTime.now(),
        );
      }

      return UserModel.fromJson(response);
    } catch (e, stackTrace) {
      AppLogger.error('Get current user error', e, stackTrace);
      return null;
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e, stackTrace) {
      AppLogger.error('Reset password error', e, stackTrace);
      rethrow;
    }
  }

  /// Update user password
  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e, stackTrace) {
      AppLogger.error('Update password error', e, stackTrace);
      rethrow;
    }
  }

  /// Check if user is authenticated
  bool get isAuthenticated => _supabase.auth.currentUser != null;

  /// Get current session
  Session? get currentSession => _supabase.auth.currentSession;
}
