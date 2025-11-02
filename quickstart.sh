#!/bin/bash

# Flutter SaaS Platform - Quick Start Script
# This script helps you get started quickly with the project

set -e

echo "🚀 Flutter SaaS Platform - Quick Start"
echo "======================================"
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed!"
    echo "Please install Flutter from: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -n 1)"
echo ""

# Check Flutter doctor
echo "📋 Running Flutter doctor..."
flutter doctor
echo ""

# Get dependencies
echo "📦 Installing dependencies..."
flutter pub get
echo ""

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "⚠️  No .env file found!"
    echo "Creating .env template..."
    cat > .env << 'EOF'
# Supabase Configuration
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here

# Discord OAuth
DISCORD_CLIENT_ID=your-discord-client-id
DISCORD_CLIENT_SECRET=your-discord-client-secret
DISCORD_BOT_TOKEN=your-discord-bot-token

# Twitter OAuth
TWITTER_CLIENT_ID=your-twitter-client-id
TWITTER_CLIENT_SECRET=your-twitter-client-secret

# WalletConnect
WALLETCONNECT_PROJECT_ID=your-walletconnect-project-id

# Stripe
STRIPE_PUBLISHABLE_KEY=your-stripe-publishable-key
STRIPE_SECRET_KEY=your-stripe-secret-key

# App Configuration
APP_SCHEME=saasplatform
EOF
    echo "✅ Created .env template"
    echo "⚠️  Please edit .env and add your API keys before running the app"
    echo ""
fi

# Generate code
echo "🔨 Generating code (Freezed, JSON Serializable, Riverpod)..."
echo "This may take a few minutes..."
flutter pub run build_runner build --delete-conflicting-outputs
echo ""

echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Edit .env file with your API keys"
echo "2. Set up Supabase:"
echo "   - Create a project at https://supabase.com"
echo "   - Run supabase_schema.sql in SQL Editor"
echo "   - (Optional) Run seed_data.sql for example products"
echo "3. Configure OAuth apps (Discord, Twitter)"
echo "4. Run the app:"
echo "   - Web: flutter run -d chrome"
echo "   - Mobile: flutter run"
echo "   - Desktop: flutter run -d macos (or windows/linux)"
echo ""
echo "📚 Documentation:"
echo "   - README.md - Project overview"
echo "   - SETUP_GUIDE.md - Detailed setup instructions"
echo "   - ARCHITECTURE.md - Technical architecture"
echo ""
echo "Happy coding! 🎉"
