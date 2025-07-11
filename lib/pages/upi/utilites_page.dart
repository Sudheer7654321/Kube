import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class UtilitesPage extends StatefulWidget {
  const UtilitesPage({super.key});

  @override
  State<UtilitesPage> createState() => _UtilitesPageState();
}

class _UtilitesPageState extends State<UtilitesPage> {
  final List<Map<String, dynamic>> gridItems = [
    {'icon': HugeIcons.strokeRoundedPhoneCheck, 'label': "Mobile Recharge"},
    {'icon': HugeIcons.strokeRoundedCpuCharge, 'label': "FastTag Recharge"},
    {'icon': HugeIcons.strokeRoundedSignal, 'label': "DTH"},
    {'icon': HugeIcons.strokeRoundedCards01, 'label': "NCMC Recharge"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF11121A),
      appBar: AppBar(
        backgroundColor: Color(0xFF11121A),
        title: Text(
          "Recharge And Subcriptions",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: const BackButton(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help_outline, color: Colors.white),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.71,
              ),
              itemCount: gridItems.length,
              itemBuilder: (context, index) {
                final item = gridItems[index];
                return iconsTile(item['icon'], item['label']);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget iconsTile(IconData icon, String label) => Column(
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
}
