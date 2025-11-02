import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Social authentication buttons widget
/// Provides Discord, Twitter, and WalletConnect auth options
class SocialAuthButtons extends StatelessWidget {
  const SocialAuthButtons({super.key});

  void _handleDiscordAuth(BuildContext context) {
    // TODO: Implement Discord OAuth
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Discord auth coming soon')),
    );
  }

  void _handleTwitterAuth(BuildContext context) {
    // TODO: Implement Twitter OAuth
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Twitter auth coming soon')),
    );
  }

  void _handleWalletConnectAuth(BuildContext context) {
    // TODO: Implement WalletConnect auth
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('WalletConnect auth coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: () => _handleDiscordAuth(context),
          icon: const FaIcon(FontAwesomeIcons.discord),
          label: const Text('Continue with Discord'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => _handleTwitterAuth(context),
          icon: const FaIcon(FontAwesomeIcons.twitter),
          label: const Text('Continue with Twitter'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => _handleWalletConnectAuth(context),
          icon: const FaIcon(FontAwesomeIcons.wallet),
          label: const Text('Continue with Wallet'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }
}
