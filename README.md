# Flutter SaaS Platform

A composable, cross-platform SaaS marketplace built with Flutter/Dart - a powerful alternative to Whop.com. Sell digital products, manage Discord roles, provision TradingView scripts, and accept crypto payments all in one platform.

## Features

### Core Functionality
- **Multi-Platform Support**: Web, iOS, Android, macOS, Windows, Linux
- **Product Marketplace**: Beautiful storefront for digital products
- **Creator Dashboard**: Comprehensive management interface
- **Customer Management**: Track and manage your customer base
- **Analytics**: Real-time insights into your business

### Authentication
- Email/Password authentication
- Discord OAuth2 integration
- Twitter OAuth2 integration
- WalletConnect (Web3 wallet authentication)

### Integrations
- **Discord**: Automatic role management based on purchases
- **Twitter**: Social login and identity linking
- **TradingView**: Private script provisioning and access control
- **WalletConnect**: Multi-chain Web3 wallet support

### Payment Processing
- **Crypto Payments**: ETH, SOL, BTC support
- **Fiat Payments**: Stripe and Flutterwave integration
- **Subscription Management**: Recurring billing support

## Tech Stack

- **Framework**: Flutter 3.x
- **Language**: Dart 3.x
- **State Management**: Riverpod
- **Backend**: Supabase (PostgreSQL, Auth, Storage)
- **Navigation**: GoRouter
- **Code Generation**: Freezed, JSON Serializable
- **Web3**: WalletConnect v2, web3dart
- **Payments**: Stripe, Crypto wallets

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── app.dart                  # Root app widget
├── core/                     # Core utilities and configuration
│   ├── config/              # Environment configuration
│   ├── constants/           # App-wide constants
│   ├── theme/               # Theme configuration
│   ├── utils/               # Utility functions
│   └── router/              # Navigation configuration
├── features/                # Feature modules
│   ├── auth/               # Authentication
│   ├── dashboard/          # Creator dashboard
│   ├── marketplace/        # Product marketplace
│   ├── checkout/           # Payment checkout
│   ├── profile/            # User profile
│   └── landing/            # Landing page
├── shared/                  # Shared resources
│   ├── models/             # Data models
│   ├── providers/          # Riverpod providers
│   ├── services/           # Business logic services
│   ├── repositories/       # Data access layer
│   └── widgets/            # Reusable widgets
└── integrations/           # Third-party integrations
    ├── discord/            # Discord OAuth & API
    ├── twitter/            # Twitter OAuth & API
    ├── tradingview/        # TradingView integration
    ├── walletconnect/      # Web3 wallet connection
    └── payments/           # Payment processing
```

## Getting Started

### Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- Supabase account
- Discord Developer account (for Discord integration)
- Twitter Developer account (for Twitter integration)
- WalletConnect Project ID
- Stripe account (for fiat payments)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd flutter-workspace-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Supabase**
   - Create a new Supabase project at https://supabase.com
   - Run the SQL schema from `supabase_schema.sql` in your Supabase SQL Editor
   - Copy your Supabase URL and anon key

4. **Configure environment variables**
   
   Create a `.env` file or use build arguments:
   ```
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   DISCORD_CLIENT_ID=your_discord_client_id
   DISCORD_CLIENT_SECRET=your_discord_client_secret
   DISCORD_BOT_TOKEN=your_discord_bot_token
   TWITTER_CLIENT_ID=your_twitter_client_id
   TWITTER_CLIENT_SECRET=your_twitter_client_secret
   WALLETCONNECT_PROJECT_ID=your_walletconnect_project_id
   STRIPE_PUBLISHABLE_KEY=your_stripe_publishable_key
   ```

5. **Generate code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

6. **Run the app**
   ```bash
   # Web
   flutter run -d chrome
   
   # iOS
   flutter run -d ios
   
   # Android
   flutter run -d android
   
   # Desktop
   flutter run -d macos  # or windows, linux
   ```

## Configuration

### Discord Integration

1. Create a Discord application at https://discord.com/developers/applications
2. Set up OAuth2 redirect URI: `your-app-scheme://discord-callback`
3. Enable required OAuth2 scopes: `identify`, `email`, `guilds`, `guilds.members.read`
4. Create a bot and get the bot token for role management

### Twitter Integration

1. Create a Twitter app at https://developer.twitter.com
2. Enable OAuth 2.0
3. Set redirect URI: `your-app-scheme://twitter-callback`
4. Request elevated access for user data

### TradingView Integration

**Note**: TradingView does not have an official public API. You'll need to:
1. Build a custom backend service to interface with TradingView
2. Implement script provisioning logic
3. Update the `tradingview_service.dart` with your API endpoints

**Useful Resources**:
- TradingView Pine Script Documentation: https://www.tradingview.com/pine-script-docs/
- TradingView Pine Script Reference (v5): https://www.tradingview.com/pine-script-reference/v5/
- TradingView Pine Script Reference (v4): https://www.tradingview.com/pine-script-reference/v4/
- TradingView Pine Script Reference (v3): https://www.tradingview.com/pine-script-reference/v3/

### WalletConnect

1. Get a project ID at https://cloud.walletconnect.com
2. Configure supported chains in `walletconnect_service.dart`

### Stripe

1. Create a Stripe account at https://stripe.com
2. Get your publishable and secret keys
3. Set up webhooks for payment events
4. Implement backend endpoints for payment intent creation

## Development

### Code Generation

This project uses code generation for models and providers:

```bash
# Watch mode (auto-regenerate on changes)
flutter pub run build_runner watch

# One-time generation
flutter pub run build_runner build --delete-conflicting-outputs
```

### Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

### Building for Production

```bash
# Web
flutter build web --release

# iOS
flutter build ios --release

# Android
flutter build apk --release
flutter build appbundle --release

# Desktop
flutter build macos --release
flutter build windows --release
flutter build linux --release
```

## Database Schema

The complete database schema is in `supabase_schema.sql`. Key tables:

- **users**: User accounts (extends Supabase auth)
- **customers**: Extended customer profiles with social links
- **products**: Digital products and services
- **purchases**: Purchase transactions
- **oauth_tokens**: OAuth access/refresh tokens
- **tradingview_scripts**: TradingView script metadata
- **discord_roles**: Discord role configurations
- **referrals**: Referral tracking

## API Integration Examples

### Discord Role Assignment

```dart
final discordService = DiscordService();
await discordService.assignRole(
  guildId: 'your-guild-id',
  userId: 'discord-user-id',
  roleId: 'role-id',
);
```

### Crypto Payment

```dart
final cryptoService = CryptoPaymentService(
  walletConnectService: walletConnectService,
);
final txHash = await cryptoService.processEthereumPayment(
  recipientAddress: '0x...',
  amountInEth: 0.1,
);
```

### TradingView Script Provisioning

```dart
final tvService = TradingViewService();
await tvService.provisionScriptAccess(
  scriptId: 'script-id',
  customerId: 'customer-id',
  customerEmail: 'customer@example.com',
);
```

## Deployment

### Web Deployment

Deploy to any static hosting service:
- Vercel
- Netlify
- Firebase Hosting
- GitHub Pages

### Mobile Deployment

- **iOS**: App Store via Xcode
- **Android**: Google Play Store via Play Console

### Desktop Deployment

- Package as native installers for each platform
- Distribute via your website or app stores

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is open source and available under the MIT License.

## Support

For issues and questions:
- Create an issue on GitHub
- Check existing documentation
- Review code comments

## Roadmap

- [ ] Advanced analytics dashboard
- [ ] Multi-currency support
- [ ] Affiliate program management
- [ ] Email marketing integration
- [ ] Mobile app optimization
- [ ] Advanced Discord bot features
- [ ] Solana and Bitcoin payment implementation
- [ ] Subscription management UI
- [ ] Product reviews and ratings
- [ ] Multi-language support

## Acknowledgments

Built with Flutter and powered by:
- Supabase for backend
- Riverpod for state management
- WalletConnect for Web3
- Stripe for payments
- Discord and Twitter APIs

---

**Ready to launch your SaaS platform? Get started now!**
