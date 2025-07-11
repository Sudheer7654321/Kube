import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class UpiProfilePage extends StatelessWidget {
  const UpiProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF11121A),
      appBar: AppBar(
        backgroundColor: Color(0xFF11121A),
        foregroundColor: Color(0xFF11121A),
        title: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Text(
            'Profile',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        // centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 👤 Profile Header
            Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundImage: AssetImage("assets/images/avatar_male.jpg"),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prasanna Reddy',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '+91 9876543210',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[100],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔁 UPI ID and QR Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    HugeIcons.strokeRoundedQrCode,
                    color: Color(0xFFB8D8C1),
                    size: 30,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'prasanna@ybl',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'View QR',
                      style: GoogleFonts.poppins(color: Color(0xFFB8D8C1)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ⚠️ KYC or Security Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Complete your KYC to enjoy full UPI benefits.',
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ),
                  TextButton(onPressed: () {}, child: const Text('Verify')),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ⚙️ Settings Options
            _settingsTile(HugeIcons.strokeRoundedBank, 'Bank Accounts', () {}),
            _settingsTile(
              HugeIcons.strokeRoundedLock,
              'UPI PIN Settings',
              () {},
            ),
            _settingsTile(
              HugeIcons.strokeRoundedShield01,
              'Privacy & Security',
              () {},
            ),
            _settingsTile(
              HugeIcons.strokeRoundedHelpCircle,
              'Help & Support',
              () {},
            ),

            const SizedBox(height: 30),

            /// 🚪 Logout
            Center(
              child: TextButton.icon(
                onPressed: () {
                  // TODO: Logout functionality
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: Text(
                  'Logout',
                  style: GoogleFonts.poppins(color: Colors.red, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: CircleAvatar(
        backgroundColor: Color(0xFF1F202A),
        child: Icon(icon, color: Colors.white),
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
