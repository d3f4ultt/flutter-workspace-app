import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/config/env_config.dart';
import '../../core/utils/logger.dart';

/// WalletConnect integration service
/// Handles Web3 wallet connections for authentication and transactions
class WalletConnectService {
  Web3App? _web3App;
  final FlutterSecureStorage _storage;
  
  SessionData? _currentSession;

  WalletConnectService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Initialize WalletConnect
  Future<void> initialize() async {
    try {
      _web3App = await Web3App.createInstance(
        projectId: EnvConfig.walletConnectProjectId,
        metadata: const PairingMetadata(
          name: EnvConfig.appName,
          description: 'A composable SaaS marketplace platform',
          url: 'https://yourapp.com',
          icons: ['https://yourapp.com/icon.png'],
        ),
      );

      AppLogger.info('WalletConnect initialized');
    } catch (e, stackTrace) {
      AppLogger.error('WalletConnect initialization error', e, stackTrace);
      rethrow;
    }
  }

  /// Connect to wallet
  Future<SessionData> connect() async {
    try {
      if (_web3App == null) {
        await initialize();
      }

      final ConnectResponse response = await _web3App!.connect(
        requiredNamespaces: {
          'eip155': const RequiredNamespace(
            chains: ['eip155:1'], // Ethereum mainnet
            methods: [
              'eth_sendTransaction',
              'eth_signTransaction',
              'eth_sign',
              'personal_sign',
              'eth_signTypedData',
            ],
            events: ['chainChanged', 'accountsChanged'],
          ),
        },
      );

      final Uri? uri = response.uri;
      if (uri != null) {
        // Display QR code or deep link for wallet connection
        // You can use a QR code package to display this URI
        AppLogger.info('WalletConnect URI: $uri');
      }

      // Wait for session approval
      final SessionData session = await response.session.future;
      _currentSession = session;

      // Store session data
      await _storage.write(
        key: 'walletconnect_session',
        value: session.topic,
      );

      AppLogger.info('Wallet connected: ${session.peer.metadata.name}');
      return session;
    } catch (e, stackTrace) {
      AppLogger.error('WalletConnect connection error', e, stackTrace);
      rethrow;
    }
  }

  /// Get connected wallet address
  String? getWalletAddress() {
    if (_currentSession == null) return null;

    final namespace = _currentSession!.namespaces['eip155'];
    if (namespace == null) return null;

    final accounts = namespace.accounts;
    if (accounts.isEmpty) return null;

    // Extract address from account string (format: "eip155:1:0x...")
    final accountParts = accounts.first.split(':');
    return accountParts.length >= 3 ? accountParts[2] : null;
  }

  /// Sign message with connected wallet
  Future<String> signMessage(String message) async {
    try {
      if (_web3App == null || _currentSession == null) {
        throw Exception('Wallet not connected');
      }

      final address = getWalletAddress();
      if (address == null) {
        throw Exception('No wallet address found');
      }

      final signature = await _web3App!.request(
        topic: _currentSession!.topic,
        chainId: 'eip155:1',
        request: SessionRequestParams(
          method: 'personal_sign',
          params: [message, address],
        ),
      );

      return signature as String;
    } catch (e, stackTrace) {
      AppLogger.error('Sign message error', e, stackTrace);
      rethrow;
    }
  }

  /// Send transaction
  Future<String> sendTransaction({
    required String to,
    required String value,
    String? data,
  }) async {
    try {
      if (_web3App == null || _currentSession == null) {
        throw Exception('Wallet not connected');
      }

      final address = getWalletAddress();
      if (address == null) {
        throw Exception('No wallet address found');
      }

      final txHash = await _web3App!.request(
        topic: _currentSession!.topic,
        chainId: 'eip155:1',
        request: SessionRequestParams(
          method: 'eth_sendTransaction',
          params: [
            {
              'from': address,
              'to': to,
              'value': value,
              if (data != null) 'data': data,
            }
          ],
        ),
      );

      return txHash as String;
    } catch (e, stackTrace) {
      AppLogger.error('Send transaction error', e, stackTrace);
      rethrow;
    }
  }

  /// Disconnect wallet
  Future<void> disconnect() async {
    try {
      if (_web3App != null && _currentSession != null) {
        await _web3App!.disconnectSession(
          topic: _currentSession!.topic,
          reason: Errors.getSdkError(Errors.USER_DISCONNECTED),
        );
      }

      _currentSession = null;
      await _storage.delete(key: 'walletconnect_session');

      AppLogger.info('Wallet disconnected');
    } catch (e, stackTrace) {
      AppLogger.error('Disconnect wallet error', e, stackTrace);
      rethrow;
    }
  }

  /// Check if wallet is connected
  bool get isConnected => _currentSession != null;

  /// Get current session
  SessionData? get currentSession => _currentSession;

  /// Dispose resources
  void dispose() {
    _web3App = null;
    _currentSession = null;
  }
}
