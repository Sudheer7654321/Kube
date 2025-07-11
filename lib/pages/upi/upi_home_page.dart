import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'housing_society_page.dart';
import 'other_utitles_page.dart';
import 'recharge_subcriptions_page.dart';
import 'to_bank_and_self_one.dart';
import 'to_mobile_money_transfer.dart';
import 'utilites_page.dart';

class UpiHomePage extends StatefulWidget {
  const UpiHomePage({super.key});

  @override
  State<UpiHomePage> createState() => _UpiHomePageState();
}

class _UpiHomePageState extends State<UpiHomePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final List<Map<String, dynamic>> gridItems = [
    {'icon': HugeIcons.strokeRoundedWallet01, 'label': "Wallet"},
    {'icon': HugeIcons.strokeRoundedFlash, 'label': "UPI Lite"},
    {'icon': HugeIcons.strokeRoundedGroup01, 'label': "UPI Circle"},
    {'icon': HugeIcons.strokeRoundedWallet02, 'label': "RuPay on UPI"},
  ];
  Future<String> getUserName() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return 'User';
    final data = await _firestore.collection('user').doc(uid).get();
    final userName = data['username'];
    return userName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        ZoomDrawer.of(context)!.toggle();
                      },
                      icon: const Icon(
                        HugeIcons.strokeRoundedMenuCollapse,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const Icon(
                      HugeIcons.strokeRoundedNotification02,
                      size: 28,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage(
                        'assets/images/avatar_male.jpg',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${getGreeting()} 👋",
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        FutureBuilder(
                          future: getUserName(),
                          builder: (context, snapshot) {
                            if (snapshot.data == null)
                              return Text('User');
                            else if (snapshot.data != null) {
                              return Text(snapshot.data!);
                            }
                            return Text("Guest");
                          },
                        ),
                        Text(
                          '',
                          // _firestore.collection('user').doc(_auth.currentUser!.uid),
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Container(
                height: 120,
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [
                      const Color(0xff222222),
                      const Color(0xff383838),
                      const Color(0xff3c3c3c),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.credit_card,
                      color: Colors.white,
                      size: 32,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Current Balance",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "₹1,740.20",
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Cash Flow",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _actionButton(
                              HugeIcons.strokeRoundedCall,
                              "To Mobile Number",
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => const ToMobileMoneyTransferPage(),
                                ),
                              ),
                            ),
                            _actionButton(
                              HugeIcons.strokeRoundedId,
                              "Pay via Upi Id",
                              () {},
                            ),
                            _actionButton(
                              HugeIcons.strokeRoundedBank,
                              "To Bank & Self A/c",
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ToBankAndSelfFirstPage(),
                                ),
                              ),
                            ),
                            _actionButton(
                              Icons.account_balance_wallet_outlined,
                              "Check Balance",
                              () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildBankingServicesSection(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Services",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "See all",
                            style: GoogleFonts.poppins(
                              color: Colors.deepPurple,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.71,
                            ),
                        itemCount: gridItems.length,
                        itemBuilder: (context, index) {
                          final item = gridItems[index];
                          return _serviceTile(item['icon'], item['label']);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              _buildSectionTitle("Recent Transactions"),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _transactionTile("From Paul", "+₹5,000.00", true),
                    const SizedBox(height: 12),
                    _transactionTile("Netflix Auto Pay", "-₹499.00", false),
                    const SizedBox(height: 12),
                    _transactionTile("Mobile Recharge", "-₹149.00", false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBankingServicesSection() {
    final services = [
      {
        "icon": HugeIcons.strokeRoundedPhoneDeveloperMode,
        "title": "Recharges And Subcriptions",
        "subtitle":
            "Perform all Recharges and Subcriptions in the fastest time & Enjoy the best internet & mobile services at any time and place",
        "cta": "Explore Now",
        "color": Colors.orangeAccent,
        "page": RechargeSubcriptionsPage(),
      },
      {
        "icon": Icons.receipt_long,
        "title": "Utilites",
        "subtitle":
            "Pay your Monthly bills and utilites with UPI & manage essential services with ease and security",
        "cta": "Explore Now",
        "color": Colors.redAccent,
        "page": UtilitesPage(),
      },
      {
        "icon": HugeIcons.strokeRoundedCpuCharge,
        "title": "Housing & Society",
        "subtitle":
            "Pay your periodic expenses secure & electronically, Simplify your Housing Taxes, maintenance, and society payments digitally",
        "cta": "Explore Now",
        "color": Colors.lightGreenAccent,
        "page": HousingSocietyPage(),
      },
      {
        "icon": HugeIcons.strokeRoundedGroupItems,
        "title": "Others",
        "subtitle":
            "Pay your periodic expenses secure & electronically, Explore additional services for a complete payment experience",
        "cta": "Explore Now",
        "color": Colors.deepOrange,
        "page": OtherUtitlesPage(),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          services.map((item) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => item['page'] as Widget),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1F2F),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        offset: const Offset(4, 6),
                        blurRadius: 12,
                      ),
                    ],
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Row(
                    children: [
                      // Icon
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: (item['color'] as Color).withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: item['color'] as Color,
                          size: 26,
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'] as String,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['subtitle'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.65),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item['cta'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.indigoAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ),
  );

  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        margin: const EdgeInsets.only(right: 6),
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Color(0xFF1F202A),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _serviceTile(IconData icon, String label) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1F202A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
      const SizedBox(height: 6),
      Text(
        label,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
      ),
    ],
  );

  Widget _transactionTile(String title, String amount, bool isCredit) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1B24),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
          ),
          Text(
            amount,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isCredit ? Colors.greenAccent : Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }
}

String getGreeting() {
  final now = DateTime.now();
  final hour = now.hour;
  final minute = now.minute;

  if (hour < 12 || (hour == 11 && minute <= 59)) {
    return "Good Morning";
  } else if ((hour == 12 || hour < 15) || (hour == 15 && minute <= 30)) {
    return "Good Afternoon";
  } else if ((hour > 15 && hour < 20) ||
      (hour == 15 && minute > 30) ||
      (hour == 20 && minute <= 30)) {
    return "Good Evening";
  } else {
    return "Good Night";
  }
}
