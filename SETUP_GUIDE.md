# Setup Guide

This comprehensive guide walks you through setting up the Flutter SaaS Platform from scratch. Follow these steps carefully to get your platform up and running.

## Prerequisites Setup

Before beginning, ensure you have the following tools and accounts ready.

### Development Environment

You will need Flutter SDK version 3.0 or higher installed on your system. Download it from the official Flutter website and follow the installation instructions for your operating system. The Dart SDK is included with Flutter, so no separate installation is required. For code editing, Visual Studio Code with the Flutter and Dart extensions is recommended, though Android Studio or IntelliJ IDEA also work well.

### Required Accounts

Create accounts on the following platforms before proceeding with the setup. You will need a Supabase account for your backend database and authentication services. A Discord Developer account is necessary for implementing Discord OAuth and role management features. Similarly, a Twitter Developer account enables Twitter OAuth integration. For Web3 wallet connectivity, register for a WalletConnect project ID. Finally, set up a Stripe account to handle fiat payment processing.

## Supabase Configuration

Supabase serves as the backend for authentication, database, and storage. Setting it up correctly is crucial for the platform to function.

### Creating Your Project

Navigate to the Supabase dashboard and create a new project. Choose a strong database password and select a region close to your target users for optimal performance. Once the project is created, locate your project URL and anon key from the project settings under the API section. These credentials will be used to connect your Flutter app to Supabase.

### Database Setup

Open the SQL Editor in your Supabase dashboard. Copy the entire contents of the `supabase_schema.sql` file from this project and paste it into the SQL Editor. Execute the SQL to create all necessary tables, indexes, and row-level security policies. This schema includes tables for users, customers, products, purchases, OAuth tokens, TradingView scripts, Discord roles, and referrals.

### Authentication Configuration

In the Supabase dashboard, navigate to Authentication settings. Enable email authentication as the primary method. Configure the site URL to match your application's domain. For development, you can use `http://localhost:3000` or your local development URL. Set up redirect URLs for OAuth providers by adding your custom URL schemes for Discord and Twitter callbacks.

## Discord Integration Setup

Discord integration enables OAuth authentication and automatic role management based on purchases.

### Creating a Discord Application

Visit the Discord Developer Portal and create a new application. Give it a descriptive name that represents your platform. In the OAuth2 section, add redirect URIs including your custom app scheme followed by `://discord-callback`. For development, also add `http://localhost:3000/discord-callback`. Enable the following OAuth2 scopes: identify, email, guilds, and guilds.members.read.

### Bot Configuration

Navigate to the Bot section and create a bot for your application. Copy the bot token and store it securely - you will need this for role management operations. Enable the Server Members Intent under Privileged Gateway Intents. Invite the bot to your Discord server using the OAuth2 URL generator with the bot scope and Administrator permissions.

### Permissions Setup

In your Discord server, create roles that will be assigned to customers upon purchase. Note the role IDs by enabling Developer Mode in Discord settings, then right-clicking roles to copy their IDs. Configure these role IDs in your product access configuration in the database.

## Twitter Integration Setup

Twitter OAuth allows users to authenticate using their Twitter accounts and links their social identity to their customer profile.

### Developer Portal Configuration

Access the Twitter Developer Portal and create a new project and app. In the app settings, enable OAuth 2.0 and set the app type to Web App. Add your redirect URI using your custom scheme: `your-app-scheme://twitter-callback`. Request elevated access if you need additional user data beyond basic profile information.

### OAuth Settings

Configure the OAuth 2.0 settings with the following scopes: tweet.read, users.read, and offline.access. The offline.access scope enables refresh tokens for maintaining long-term authentication. Copy your Client ID and Client Secret for use in your application configuration.

## WalletConnect Setup

WalletConnect enables Web3 wallet authentication and cryptocurrency transactions.

### Project Registration

Visit WalletConnect Cloud and create a new project. Provide your project name and URL. Once created, copy your Project ID - this is the only credential you need for WalletConnect integration. Configure the supported blockchain networks in your application code based on which cryptocurrencies you plan to accept.

## Stripe Configuration

Stripe handles fiat currency payments and subscription management.

### Account Setup

Create a Stripe account and complete the business verification process. In the Stripe Dashboard, navigate to Developers and copy your Publishable Key and Secret Key. The publishable key is used in your Flutter app, while the secret key should only be used in your backend or Supabase Edge Functions.

### Webhook Configuration

Set up webhooks to receive payment event notifications. Add a webhook endpoint URL pointing to your backend service. Subscribe to the following events: payment_intent.succeeded, payment_intent.payment_failed, customer.subscription.created, customer.subscription.updated, and customer.subscription.deleted. Copy the webhook signing secret for verifying webhook authenticity.

## Application Configuration

With all external services configured, you can now set up your Flutter application.

### Environment Variables

Create a file named `.env` in the project root (this file is gitignored for security). Add all your API keys and configuration values using the following format:

```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
DISCORD_CLIENT_ID=your-discord-client-id
DISCORD_CLIENT_SECRET=your-discord-client-secret
DISCORD_BOT_TOKEN=your-bot-token
TWITTER_CLIENT_ID=your-twitter-client-id
TWITTER_CLIENT_SECRET=your-twitter-client-secret
WALLETCONNECT_PROJECT_ID=your-walletconnect-project-id
STRIPE_PUBLISHABLE_KEY=your-stripe-publishable-key
STRIPE_SECRET_KEY=your-stripe-secret-key
APP_SCHEME=saasplatform
```

Alternatively, you can pass these values as build arguments when running or building your app.

### Code Generation

The project uses code generation for models and providers. Run the following command to generate all necessary code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

For continuous development, use watch mode to automatically regenerate code when files change:

```bash
flutter pub run build_runner watch
```

## Running the Application

After completing all configuration steps, you can run the application on your desired platform.

### Development Mode

For web development, use `flutter run -d chrome`. For mobile development on iOS, use `flutter run -d ios`, and for Android, use `flutter run -d android`. Desktop platforms can be run with `flutter run -d macos`, `flutter run -d windows`, or `flutter run -d linux` depending on your operating system.

### Production Build

When ready to deploy, build release versions using the appropriate commands. For web, use `flutter build web --release`. For iOS, use `flutter build ios --release`. For Android, build an APK with `flutter build apk --release` or an app bundle with `flutter build appbundle --release`. Desktop builds use `flutter build macos --release`, `flutter build windows --release`, or `flutter build linux --release`.

## TradingView Integration

TradingView integration requires custom implementation as there is no official public API.

### Backend Service

You need to build a custom backend service that interfaces with TradingView. This service should handle script provisioning, access control, and user management. The service should expose REST or GraphQL endpoints that your Flutter app can call. Update the `TRADINGVIEW_API_URL` and `TRADINGVIEW_API_KEY` in your environment configuration to point to your custom service.

### Documentation Resources

Refer to the official TradingView Pine Script documentation for understanding script development. The documentation is available at different version URLs for comprehensive coverage of all Pine Script features across versions.

## Testing Your Setup

Verify that all integrations are working correctly by testing each component.

### Authentication Testing

Test email/password registration and login flows. Attempt Discord OAuth login and verify that user data is correctly stored. Test Twitter OAuth login similarly. For WalletConnect, test wallet connection and signature verification.

### Payment Testing

Use Stripe test mode with test card numbers to verify payment flows. For crypto payments, use testnets like Goerli for Ethereum or Devnet for Solana to avoid using real funds during testing.

### Integration Testing

Create a test product and verify that Discord roles are assigned correctly upon purchase. Test TradingView script provisioning if you have implemented the backend service. Verify that all customer data is properly linked across Discord, Twitter, and wallet accounts.

## Troubleshooting

If you encounter issues during setup, check the following common problems and solutions.

### Supabase Connection Issues

Verify that your Supabase URL and anon key are correct. Check that row-level security policies are properly configured. Ensure your app's domain is added to the allowed URLs in Supabase settings.

### OAuth Redirect Problems

Confirm that redirect URIs exactly match in both the provider settings and your app configuration. For mobile apps, ensure custom URL schemes are properly configured in iOS Info.plist and Android AndroidManifest.xml files.

### Code Generation Errors

If code generation fails, try deleting the `.dart_tool` directory and running `flutter pub get` again. Ensure all model classes are properly annotated with Freezed and JSON Serializable decorators.

### Build Failures

Run `flutter clean` followed by `flutter pub get` to resolve dependency conflicts. Check that your Flutter SDK version meets the minimum requirements. Verify that all platform-specific configurations are correct.

## Next Steps

With your platform fully configured and running, you can begin customizing it for your specific use case. Add your own branding and styling by modifying the theme configuration. Create products in the Supabase database and configure their access rules. Set up your Discord server with the appropriate roles. Implement additional features based on your business requirements.

For ongoing development, refer to the main README for code examples and API usage patterns. The codebase is designed to be modular and extensible, allowing you to add new integrations and features as needed.
