/// Environment configuration for API keys and secrets
/// 
/// IMPORTANT: In production, use environment variables or secure secret management
/// Never commit real API keys to version control
class EnvConfig {
  // Supabase Configuration
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'YOUR_SUPABASE_URL_HERE',
  );
  
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'YOUR_SUPABASE_ANON_KEY_HERE',
  );

  // Discord OAuth2 Configuration
  static const String discordClientId = String.fromEnvironment(
    'DISCORD_CLIENT_ID',
    defaultValue: 'YOUR_DISCORD_CLIENT_ID_HERE',
  );
  
  static const String discordClientSecret = String.fromEnvironment(
    'DISCORD_CLIENT_SECRET',
    defaultValue: 'YOUR_DISCORD_CLIENT_SECRET_HERE',
  );
  
  static const String discordRedirectUri = String.fromEnvironment(
    'DISCORD_REDIRECT_URI',
    defaultValue: 'YOUR_APP_SCHEME://discord-callback',
  );
  
  static const String discordBotToken = String.fromEnvironment(
    'DISCORD_BOT_TOKEN',
    defaultValue: 'YOUR_DISCORD_BOT_TOKEN_HERE',
  );

  // Twitter OAuth2 Configuration
  static const String twitterClientId = String.fromEnvironment(
    'TWITTER_CLIENT_ID',
    defaultValue: 'YOUR_TWITTER_CLIENT_ID_HERE',
  );
  
  static const String twitterClientSecret = String.fromEnvironment(
    'TWITTER_CLIENT_SECRET',
    defaultValue: 'YOUR_TWITTER_CLIENT_SECRET_HERE',
  );
  
  static const String twitterRedirectUri = String.fromEnvironment(
    'TWITTER_REDIRECT_URI',
    defaultValue: 'YOUR_APP_SCHEME://twitter-callback',
  );

  // TradingView Configuration
  static const String tradingViewApiUrl = String.fromEnvironment(
    'TRADINGVIEW_API_URL',
    defaultValue: 'YOUR_TRADINGVIEW_API_URL_HERE',
  );
  
  static const String tradingViewApiKey = String.fromEnvironment(
    'TRADINGVIEW_API_KEY',
    defaultValue: 'YOUR_TRADINGVIEW_API_KEY_HERE',
  );

  // WalletConnect Configuration
  static const String walletConnectProjectId = String.fromEnvironment(
    'WALLETCONNECT_PROJECT_ID',
    defaultValue: 'YOUR_WALLETCONNECT_PROJECT_ID_HERE',
  );

  // Stripe Configuration
  static const String stripePublishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue: 'YOUR_STRIPE_PUBLISHABLE_KEY_HERE',
  );
  
  static const String stripeSecretKey = String.fromEnvironment(
    'STRIPE_SECRET_KEY',
    defaultValue: 'YOUR_STRIPE_SECRET_KEY_HERE',
  );

  // Flutterwave Configuration
  static const String flutterwavePublicKey = String.fromEnvironment(
    'FLUTTERWAVE_PUBLIC_KEY',
    defaultValue: 'YOUR_FLUTTERWAVE_PUBLIC_KEY_HERE',
  );

  // App Configuration
  static const String appScheme = String.fromEnvironment(
    'APP_SCHEME',
    defaultValue: 'saasplatform',
  );
  
  static const String appName = 'SaaS Platform';
  
  // API Endpoints
  static String get discordApiBaseUrl => 'https://discord.com/api/v10';
  static String get twitterApiBaseUrl => 'https://api.twitter.com/2';
}
