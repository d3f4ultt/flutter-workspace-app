import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

import 'app.dart';
import 'core/config/env_config.dart';

/// Main entry point for the Flutter SaaS Platform
/// Initializes all required services and dependencies
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: EnvConfig.supabaseUrl,
    anonKey: EnvConfig.supabaseAnonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  // Run the app with Riverpod provider scope
  runApp(
    const ProviderScope(
      child: SaaSPlatformApp(),
    ),
  );
}
