import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class ToBankAndSelfFirstPage extends StatelessWidget {
  const ToBankAndSelfFirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF11121A),
      appBar: AppBar(
        backgroundColor: Color(0xFF11121A),
        title: Text(
          "Cash Out Flow",
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
            SizedBox(height: 40),
            _settingsTile(HugeIcons.strokeRoundedBank, "To Bank Account", () {
              // TODO: Implement onTap action
            }),
            _settingsTile(
              HugeIcons.strokeRoundedSelfTransfer,
              "To Self Account",
              () {
                // TODO: Implement onTap action
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      leading: CircleAvatar(
        // backgroundColor: Color(0xFF1F202A),
        backgroundColor: Color(0xFFB8D8C1),
        child: Icon(icon, color: Colors.white),
        radius: 24,
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: Colors.white,
      ),
      onTap: onTap,
    );
  }
}
