import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Privacy Policy"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: ListView(
          children: [
            Text(
              "1. Introduction",
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "We value your privacy and are committed to protecting your personal data. This policy explains how we collect, use, and safeguard your information.",
              style: GoogleFonts.poppins(color: Colors.white70),
            ),
            SizedBox(height: 16),

            Text(
              "2. Information We Collect",
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "- Personal details (e.g., name, email)\n"
              "- Usage data (e.g., app activity)\n"
              "- Device information (e.g., OS version, model)",
              style: GoogleFonts.poppins(color: Colors.white70),
            ),
            SizedBox(height: 16),

            Text(
              "3. How We Use Your Data",
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "- To provide and maintain the app\n"
              "- To improve user experience\n"
              "- To send important notifications\n"
              "- For security and legal compliance",
              style: GoogleFonts.poppins(color: Colors.white70),
            ),
            SizedBox(height: 16),

            Text(
              "4. Data Sharing",
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "We do not sell or rent your personal information. We may share data with trusted partners for functionality, legal compliance, or app analytics.",
              style: GoogleFonts.poppins(color: Colors.white70),
            ),
            SizedBox(height: 16),

            Text(
              "5. Data Security",
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "We implement reasonable security measures to protect your data from unauthorized access or misuse.",
              style: GoogleFonts.poppins(color: Colors.white70),
            ),
            SizedBox(height: 16),

            Text(
              "6. Your Rights",
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "You have the right to access, correct, or delete your personal information. You may also request us to stop using your data.",
              style: GoogleFonts.poppins(color: Colors.white70),
            ),
            SizedBox(height: 16),

            Text(
              "7. Changes to This Policy",
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "We may update this privacy policy from time to time. You will be notified of any significant changes.",
              style: GoogleFonts.poppins(color: Colors.white70),
            ),
            SizedBox(height: 32),

            Center(
              child: Text(
                "Last updated: June 25, 2025",
                style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
