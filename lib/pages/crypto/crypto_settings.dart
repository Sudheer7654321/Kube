import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CryptoSettings extends StatefulWidget {
  const CryptoSettings({super.key});

  @override
  State<CryptoSettings> createState() => _CryptoSettingsState();
}

class _CryptoSettingsState extends State<CryptoSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          Spacer(),
          OutlinedButton(onPressed: () {}, child: Text('Logout')),
        ],
      ),
    );
  }
}
