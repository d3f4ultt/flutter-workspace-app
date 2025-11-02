import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth_service.dart';
import '../models/user_model.dart';

part 'auth_provider.g.dart';

/// Auth state provider - watches current authentication state
@riverpod
Stream<User?> authState(AuthStateRef ref) {
  final supabase = Supabase.instance.client;
  return supabase.auth.onAuthStateChange.map((data) => data.session?.user);
}

/// Current user provider - provides the current authenticated user
@riverpod
Future<UserModel?> currentUser(CurrentUserRef ref) async {
  final authState = await ref.watch(authStateProvider.future);
  if (authState == null) return null;
  
  final authService = ref.watch(authServiceProvider);
  return authService.getCurrentUser();
}

/// Auth service provider
@riverpod
AuthService authService(AuthServiceRef ref) {
  return AuthService();
}
