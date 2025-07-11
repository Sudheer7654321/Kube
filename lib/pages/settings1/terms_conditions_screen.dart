import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Terms & Conditions"),
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
              "By using this app, you agree to be bound by these terms and conditions. If you do not agree, please do not use the app.",
              style: GoogleFonts.poppins(color: Colors.white70),
            ),
            SizedBox(height: 16),

            Text(
              "2. User Responsibilities",
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "You agree to use the app only for lawful purposes and not to misuse any features, attempt to hack, reverse engineer, or disrupt the service.",
              style: GoogleFonts.poppins(color: Colors.white70),
            ),
            SizedBox(height: 16),

            Text(
              "3. Privacy",
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "We respect your privacy. Your personal data will only be used as outlined in our Privacy Policy.",
              style: GoogleFonts.poppins(color: Colors.white70),
            ),
            SizedBox(height: 16),

            Text(
              "4. Intellectual Property",
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "All content, code, and design are the intellectual property of the developer. You may not copy, modify, or reuse without permission.",
              style: GoogleFonts.poppins(color: Colors.white70),
            ),
            SizedBox(height: 16),

            Text(
              "5. Limitation of Liability",
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "The app is provided 'as is' without warranty. We are not responsible for any loss or damage arising from its use.",
              style: GoogleFonts.poppins(color: Colors.white70),
            ),
            SizedBox(height: 16),

            Text(
              "6. Updates and Modifications",
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "We may update these terms at any time. Continued use of the app means you accept the new terms.",
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
