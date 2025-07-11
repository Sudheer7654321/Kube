import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'RechargeAndSubs/AppleStore/apple_store_first_page.dart';
import 'RechargeAndSubs/Cable/cable_tv_recharge_first_page.dart';
import 'RechargeAndSubs/DTH/dth_first_page.dart';
import 'RechargeAndSubs/FastTag/fastag_recharge_first_page.dart';
import 'RechargeAndSubs/GooglePlay/google_play_first_page.dart';
import 'RechargeAndSubs/NCMC/ncmc_recharge_first_page.dart';
import 'RechargeAndSubs/Recharge/mobile_recharge_contact_acess.dart';
import 'RechargeAndSubs/Subscriptions/subscription_first_page.dart';

class RechargeSubcriptionsPage extends StatefulWidget {
  const RechargeSubcriptionsPage({super.key});

  @override
  State<RechargeSubcriptionsPage> createState() =>
      _RechargeSubcriptionsPageState();
}

class _RechargeSubcriptionsPageState extends State<RechargeSubcriptionsPage> {
  final List<Map<String, dynamic>> gridItems = [
    {
      'icon': HugeIcons.strokeRoundedPhoneCheck,
      'label': "Mobile Recharge",
      'page': MobileRechargeAcessPage(),
    },
    {
      'icon': HugeIcons.strokeRoundedFastWind,
      'label': "FastTag Recharge",
      'page': FastagRechargeFirstPage(),
    },
    {
      'icon': HugeIcons.strokeRoundedSignal,
      'label': "DTH",
      'page': DthFirstPage(),
    },
    {
      'icon': HugeIcons.strokeRoundedCards01,
      'label': "NCMC Recharge",
      'page': NcmcRechargeFirstPage(),
    },
    {
      'icon': HugeIcons.strokeRoundedPlayStore,
      'label': "Play Store",
      'page': GooglePlayFirstPage(),
    },
    {
      'icon': HugeIcons.strokeRoundedAppStore,
      'label': "Apple Store",
      'page': AppleStoreFirstPage(),
    },
    {
      'icon': HugeIcons.strokeRoundedTelevisionTable,
      'label': "Cable TV",
      'page': CableTvRechargeFirstPage(),
    },
    {
      'icon': HugeIcons.strokeRoundedPlayCircle,
      'label': "Subscribe",
      'page': SubscriptionFirstPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF11121A),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFF11121A),
            expandedHeight: 220,
            pinned: true,
            leading: const BackButton(color: Colors.white),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.help_outline, color: Colors.white),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              title: Text(
                "Recharge & Subcriptions",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              background: Image.asset(
                'assets/images/banner_recharge.png', // 👈 Your banner image
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Explore",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: gridItems.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.71,
                        ),
                    itemBuilder: (context, index) {
                      final item = gridItems[index];
                      return iconsTile(
                        item['icon'],
                        item['label'],
                        item['page'],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget iconsTile(IconData icon, String label, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF8042DD),
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
      ),
    );
  }
}
