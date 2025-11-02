/// Application-wide constants
class AppConstants {
  // Route Names
  static const String routeLanding = '/';
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeDashboard = '/dashboard';
  static const String routeMarketplace = '/marketplace';
  static const String routeCheckout = '/checkout';
  static const String routeProfile = '/profile';
  
  // Storage Keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  
  // OAuth Scopes
  static const List<String> discordScopes = [
    'identify',
    'email',
    'guilds',
    'guilds.members.read',
  ];
  
  static const List<String> twitterScopes = [
    'tweet.read',
    'users.read',
    'offline.access',
  ];
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Timeouts
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration longTimeout = Duration(minutes: 2);
  
  // Crypto Networks
  static const String networkEthereum = 'ethereum';
  static const String networkSolana = 'solana';
  static const String networkBitcoin = 'bitcoin';
  
  // Payment Methods
  static const String paymentCrypto = 'crypto';
  static const String paymentStripe = 'stripe';
  static const String paymentFlutterwave = 'flutterwave';
  
  // Product Types
  static const String productTypeScript = 'tradingview_script';
  static const String productTypeDiscordRole = 'discord_role';
  static const String productTypeSubscription = 'subscription';
  static const String productTypeOneTime = 'one_time';
  
  // Error Messages
  static const String errorGeneric = 'An error occurred. Please try again.';
  static const String errorNetwork = 'Network error. Please check your connection.';
  static const String errorAuth = 'Authentication failed. Please login again.';
  static const String errorPermission = 'You do not have permission to perform this action.';
}
