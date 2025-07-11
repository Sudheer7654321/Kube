import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:http/http.dart' as http;
//import 'package:kube/pages/crypto/crypto_settings.dart';
import 'package:kube/pages/crypto/servises.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CryptoPage extends StatefulWidget {
  const CryptoPage({super.key});

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  bool isWalletChecking = true;
  bool isConnecting = false;

  @override
  void initState() {
    super.initState();
    fetchCryptoData();
    initWalletConnect();
  }

  Future<void> initWalletConnect() async {
    try {
      wcClient = Web3App(
        core: Core(projectId: '279d8ee8fb8294bf51cb38019469668d'),
        metadata: PairingMetadata(
          name: 'Kube',
          description: 'Connect to Kube Portfolio',
          url: 'https://myapp.example',
          icons: [''],
        ),
      );

      await wcClient.init();
      await checkExistingConnection();

      wcClient.onSessionConnect.subscribe((args) {
        if (args != null) {
          final session = args.session;
          final accounts = session.namespaces['eip155']?.accounts;
          if (accounts != null && accounts.isNotEmpty) {
            final address = accounts.first.split(':').last;
            setState(() {
              walletAddress = address;
              wcUri = null;
              isConnecting = false;
            });
            fetchWalletWorth();
            _showSuccessMessage('Wallet connected successfully!');
          }
        }
      });

      wcClient.onSessionDelete.subscribe((args) {
        setState(() {
          walletAddress = null;
          wcUri = null;
          totalInr = 0;
          tokenWorths = {};
          isConnecting = false;
        });
        _showSuccessMessage('Wallet disconnected');
      });
    } catch (e) {
      print('WalletConnect Init Error: $e');
      _showErrorMessage('Failed to initialize WalletConnect: $e');
    } finally {
      setState(() {
        isWalletChecking = false;
      });
    }
  }

  Future<void> checkExistingConnection() async {
    try {
      final sessions = wcClient.getActiveSessions();
      if (sessions.isNotEmpty) {
        final session = sessions.values.first;
        final accounts = session.namespaces['eip155']?.accounts;
        if (accounts != null && accounts.isNotEmpty) {
          final address = accounts.first.split(':').last;
          setState(() => walletAddress = address);
          fetchWalletWorth();
          return;
        }
      }
    } catch (e) {
      print('Check existing connection error: $e');
    }
  }

  Future<void> connectWallet() async {
    if (isConnecting) return;

    setState(() => isConnecting = true);

    try {
      // First check if already connected
      await checkExistingConnection();
      if (walletAddress != null) {
        setState(() => isConnecting = false);
        return;
      }

      final ConnectResponse response = await wcClient.connect(
        requiredNamespaces: const {
          'eip155': RequiredNamespace(
            chains: ['eip155:1'],
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

      final uri = response.uri;
      if (uri != null) {
        final uriStr = uri.toString();
        setState(() => wcUri = uriStr);

        // Try to launch wallet app automatically
        await _tryLaunchWalletApps(uriStr);
      }
    } catch (e) {
      print('WalletConnect Error: $e');
      setState(() => isConnecting = false);
      _showErrorMessage('Connection failed: ${e.toString()}');
    }
  }

  Future<void> disconnectWallet() async {
    try {
      final sessions = wcClient.getActiveSessions();
      if (sessions.isNotEmpty) {
        final sessionTopic = sessions.keys.first;
        await wcClient.disconnectSession(
          topic: sessionTopic,
          reason: const WalletConnectError(
            code: 6000,
            message: 'User disconnected',
          ),
        );
      }
      setState(() {
        walletAddress = null;
        wcUri = null;
        totalInr = 0;
        tokenWorths = {};
        isConnecting = false;
      });
    } catch (e) {
      print('Disconnect Error: $e');
      _showErrorMessage('Disconnect failed: $e');
    }
  }

  // Improved wallet detection and launching
  Future<void> _tryLaunchWalletApps(String wcUri) async {
    final walletConfigs = [
      {
        'name': 'MetaMask',
        'universalLink':
            'https://metamask.app.link/wc?uri=${Uri.encodeComponent(wcUri)}',
        'deepLink': 'metamask://wc?uri=${Uri.encodeComponent(wcUri)}',
        'packageAndroid': 'io.metamask',
        'bundleIOS': 'metamask',
      },
      {
        'name': 'Trust Wallet',
        'universalLink':
            'https://link.trustwallet.com/wc?uri=${Uri.encodeComponent(wcUri)}',
        'deepLink': 'trust://wc?uri=${Uri.encodeComponent(wcUri)}',
        'packageAndroid': 'com.wallet.crypto.trustapp',
        'bundleIOS': 'trust',
      },
      {
        'name': 'Rainbow',
        'universalLink':
            'https://rainbow.me/wc?uri=${Uri.encodeComponent(wcUri)}',
        'deepLink': 'rainbow://wc?uri=${Uri.encodeComponent(wcUri)}',
        'packageAndroid': 'me.rainbow',
        'bundleIOS': 'rainbow',
      },
      {
        'name': 'Coinbase Wallet',
        'universalLink':
            'https://go.cb-w.com/wc?uri=${Uri.encodeComponent(wcUri)}',
        'deepLink': 'cbwallet://wc?uri=${Uri.encodeComponent(wcUri)}',
        'packageAndroid': 'org.toshi',
        'bundleIOS': 'cbwallet',
      },
    ];

    List<Map<String, String>> availableWallets = [];

    // Check which wallets are installed
    for (var wallet in walletConfigs) {
      bool isInstalled = await _isWalletInstalled(wallet);
      if (isInstalled) {
        availableWallets.add(wallet);
      }
    }

    if (availableWallets.isNotEmpty) {
      // If only one wallet is available, launch it directly
      if (availableWallets.length == 1) {
        await _launchSpecificWallet(availableWallets.first, wcUri);
      } else {
        // Show selection dialog for multiple wallets
        _showWalletSelectionDialog(availableWallets, wcUri);
      }
    } else {
      // No wallets installed, show install options
      _showWalletInstallDialog();
    }
  }

  Future<bool> _isWalletInstalled(Map<String, String> wallet) async {
    try {
      // Try deep link first
      final deepLinkUri = Uri.parse(wallet['deepLink']!);
      if (await canLaunchUrl(deepLinkUri)) {
        return true;
      }

      // Try universal link
      final universalLinkUri = Uri.parse(wallet['universalLink']!);
      if (await canLaunchUrl(universalLinkUri)) {
        return true;
      }

      return false;
    } catch (e) {
      print('Error checking wallet ${wallet['name']}: $e');
      return false;
    }
  }

  Future<void> _launchSpecificWallet(
    Map<String, String> wallet,
    String wcUri,
  ) async {
    try {
      bool launched = false;

      // Try deep link first
      try {
        final deepLinkUri = Uri.parse(wallet['deepLink']!);
        if (await canLaunchUrl(deepLinkUri)) {
          await launchUrl(deepLinkUri, mode: LaunchMode.externalApplication);
          launched = true;
        }
      } catch (e) {
        print('Deep link failed for ${wallet['name']}: $e');
      }

      // Try universal link if deep link fails
      if (!launched) {
        try {
          final universalLinkUri = Uri.parse(wallet['universalLink']!);
          if (await canLaunchUrl(universalLinkUri)) {
            await launchUrl(
              universalLinkUri,
              mode: LaunchMode.externalApplication,
            );
            launched = true;
          }
        } catch (e) {
          print('Universal link failed for ${wallet['name']}: $e');
        }
      }

      if (!launched) {
        _showErrorMessage('Failed to launch ${wallet['name']}');
      }
    } catch (e) {
      print('Launch wallet error: $e');
      _showErrorMessage('Failed to launch wallet: $e');
    }
  }

  void _showWalletSelectionDialog(
    List<Map<String, String>> wallets,
    String wcUri,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text(
              'Select Wallet',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  wallets.map((wallet) {
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _launchSpecificWallet(wallet, wcUri);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(12),
                        ),
                        child: Text(
                          'Open ${wallet['name']}',
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                      ),
                    );
                  }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void _showWalletInstallDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text(
              'No Wallet Apps Found',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'You need a cryptocurrency wallet to connect. Please install one:',
                  style: GoogleFonts.poppins(color: Colors.white70),
                ),
                const SizedBox(height: 20),

                // MetaMask install button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _installWallet('metamask');
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Install MetaMask'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Trust Wallet install button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _installWallet('trust');
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Install Trust Wallet'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'Or scan the QR code with any WalletConnect compatible wallet:',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  Future<void> _installWallet(String walletType) async {
    try {
      String storeUrl;

      if (walletType == 'metamask') {
        storeUrl =
            Platform.isAndroid
                ? 'https://play.google.com/store/apps/details?id=io.metamask'
                : 'https://apps.apple.com/app/metamask/id1438144202';
      } else if (walletType == 'trust') {
        storeUrl =
            Platform.isAndroid
                ? 'https://play.google.com/store/apps/details?id=com.wallet.crypto.trustapp'
                : 'https://apps.apple.com/app/trust-crypto-bitcoin-wallet/id1288339409';
      } else {
        return;
      }

      final storeUri = Uri.parse(storeUrl);
      if (await canLaunchUrl(storeUri)) {
        await launchUrl(storeUri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorMessage('Could not open app store');
      }
    } catch (e) {
      print('Install wallet error: $e');
      _showErrorMessage('Failed to open app store: $e');
    }
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> fetchWalletWorth() async {
    if (walletAddress == null) return;

    final url =
        'https://api.covalenthq.com/v1/1/address/$walletAddress/balances_v2/?key=$goldrushApiKey';

    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final items = data['data']['items'] as List;

        double total = 0;
        final Map<String, double> temp = {};

        for (var token in items) {
          final name = token['contract_ticker_symbol'];
          final balance = token['balance'];
          final decimals = token['contract_decimals'];
          final price = token['quote_rate'];

          if (balance != null && decimals != null && price != null) {
            final actualBalance = int.parse(balance) / (10 << (decimals - 1));
            final value = actualBalance * price;
            if (value > 1) {
              temp[name] = value;
              total += value;
            }
          }
        }

        setState(() {
          tokenWorths = temp;
          totalInr = total;
        });
      }
    } catch (e) {
      print('Wallet Worth Error: $e');
    }
  }

  Future<void> fetchCryptoData() async {
    final trendingUrl = Uri.parse(
      'https://api.coingecko.com/api/v3/search/trending',
    );
    final topCoinsUrl = Uri.parse(
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=inr&order=market_cap_desc&per_page=10&page=1',
    );

    try {
      final trendingRes = await http.get(trendingUrl);
      final topCoinsRes = await http.get(topCoinsUrl);

      if (trendingRes.statusCode == 200 && topCoinsRes.statusCode == 200) {
        setState(() {
          trending = jsonDecode(trendingRes.body)['coins'];
          topCoins = jsonDecode(topCoinsRes.body);
          isLoading = false;
        });
      }
    } catch (e) {
      print('Crypto Data Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onLongPress: () {},
          onPressed: () => ZoomDrawer.of(context)!.toggle(),
          icon: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Icon(
              HugeIcons.strokeRoundedMenuCollapse,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              HugeIcons.strokeRoundedCamera02,
              size: 30,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: Icon(
              HugeIcons.strokeRoundedNotification03,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              // Test wallet connection
              if (walletAddress != null) {
                disconnectWallet();
              } else {
                connectWallet();
              }
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body:
          isLoading || isWalletChecking
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (wcUri != null) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[700]!),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Scan with Wallet App",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: QrImageView(
                                data: wcUri!,
                                size: 200,
                                backgroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(text: wcUri!),
                                    );
                                    _showSuccessMessage(
                                      'URI copied to clipboard',
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.copy,
                                    color: Colors.blue,
                                  ),
                                  label: const Text(
                                    "Copy",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () => setState(() => wcUri = null),
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                  label: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () => _tryLaunchWalletApps(wcUri!),
                                  icon: const Icon(
                                    Icons.launch,
                                    color: Colors.green,
                                  ),
                                  label: const Text(
                                    "Open",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                    buildWalletCard(),
                    const SizedBox(height: 30),
                    if (trending.isNotEmpty) buildTrendingSection(),
                    const SizedBox(height: 20),
                    if (topCoins.isNotEmpty) buildTopMarketCapSection(),
                  ],
                ),
              ),
    );
  }

  Widget buildWalletCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6), Color(0xFF60A5FA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Wallet Balance",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              if (walletAddress != null) ...[
                IconButton(
                  onPressed: disconnectWallet,
                  icon: Icon(
                    HugeIcons.strokeRoundedLogout02,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ],
            ],
          ),
          Text(
            walletAddress == null ? "*****" : "₹${totalInr.toStringAsFixed(2)}",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (walletAddress == null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(12),
                ),
                onPressed: isConnecting ? null : connectWallet,
                child:
                    isConnecting
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.black,
                            ),
                          ),
                        )
                        : Text(
                          "Connect Wallet",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          if (walletAddress != null && tokenWorths.isNotEmpty)
            Wrap(
              spacing: 12,
              children:
                  tokenWorths.entries
                      .map(
                        (e) => Chip(
                          label: Text(
                            "${e.key}: ₹${e.value.toStringAsFixed(0)}",
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                          backgroundColor: Colors.black38,
                        ),
                      )
                      .toList(),
            ),
          const SizedBox(height: 16),
          if (walletAddress != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                walletItems(HugeIcons.strokeRoundedArrowUp02, "Send"),
                walletItems(HugeIcons.strokeRoundedArrowDown02, "Receive"),
                walletItems(Icons.swap_horiz, "Swap"),
                walletItems(HugeIcons.strokeRoundedMore02, "More"),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget buildTrendingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Trending Coins",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: trending.length,
            itemBuilder: (context, index) {
              final coin = trending[index]['item'];
              return Card(
                margin: const EdgeInsets.only(right: 12),
                color: Colors.grey[900],
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        coin['thumb'],
                        height: 40,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.error, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        coin['name'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '#${coin['market_cap_rank']}',
                        style: GoogleFonts.poppins(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildTopMarketCapSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Top Market Cap",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: topCoins.length,
          itemBuilder: (context, index) {
            final coin = topCoins[index];
            return Card(
              color: Colors.grey[900],
              child: ListTile(
                leading: Image.network(
                  coin['image'],
                  height: 30,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          const Icon(Icons.error, color: Colors.white),
                ),
                title: Text(
                  coin['name'],
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                subtitle: Text(
                  'Symbol: ${coin['symbol'].toUpperCase()}',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
                trailing: Text(
                  '₹${coin['current_price'].toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

Widget walletItems(IconData icon, String label) {
  return Padding(
    padding: const EdgeInsets.all(1),
    child: Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white.withOpacity(0.2),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
