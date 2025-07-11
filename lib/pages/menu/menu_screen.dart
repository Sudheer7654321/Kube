import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:kube/pages/authentication/login_page.dart';

class MenuScreen extends StatefulWidget {
  final Function(String) onPageChanged;
  final String currentPage;

  MenuScreen({
    super.key,
    required this.onPageChanged,
    required this.currentPage,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18, top: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  buildMenuItem(
                    context,
                    'UPI & Payments',
                    Icon(Icons.account_balance_wallet_rounded),
                    'UPI & Payments',
                  ),
                  buildMenuItem(
                    context,
                    'Cards',
                    Icon(HugeIcons.strokeRoundedCreditCard),
                    'Cards',
                  ),
                  buildMenuItem(
                    context,
                    'Crypto',
                    Icon(HugeIcons.strokeRoundedBitcoin04),
                    'Crypto',
                  ),
                  buildMenuItem(
                    context,
                    'Stocks',
                    Icon(HugeIcons.strokeRoundedBitcoinGraph),
                    'Stocks',
                  ),

                  buildMenuItem(
                    context,
                    'Dashboard',
                    Icon(HugeIcons.strokeRoundedLayout04),
                    'Dashboard',
                  ),
                  buildMenuItem(
                    context,
                    'Settings',
                    Icon(HugeIcons.strokeRoundedSettings01),
                    'Settings',
                  ),
                  const Spacer(flex: 2),
                  buildMenuItem(
                    context,
                    'Logout',
                    Icon(Icons.logout),
                    'Logout',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(
    BuildContext context,
    String title,
    Icon icon,
    String pageName,
  ) {
    bool isSelected = widget.currentPage == pageName;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        minLeadingWidth: 20,
        leading: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: icon,
        ),
        iconColor: isSelected ? Colors.white : Colors.white70,
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        onTap: () {
          if (pageName == 'Logout') {
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: Text('Logout'),
                    content: Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await _auth.signOut();
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => LoginPage()),
                              (route) => false,
                            );
                          }
                        },
                        child: Text('Logout'),
                      ),
                    ],
                  ),
            );
          } else {
            widget.onPageChanged(pageName);
          }
        },
      ),
    );
  }
}
