import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class BiometricAuthScreen extends StatefulWidget {
  BiometricAuthScreen({super.key});

  @override
  State<BiometricAuthScreen> createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen> {
  final LocalAuthentication auth = LocalAuthentication();

  bool isBiometricAvailable = false;
  bool isBiometricEnrolled = false;
  bool isBiometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricStatus();
  }

  Future<void> _checkBiometricStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool available = await auth.canCheckBiometrics;
    List<BiometricType> biometrics = await auth.getAvailableBiometrics();
    bool enabled = prefs.getBool('biometric_enabled') ?? false;

    setState(() {
      isBiometricAvailable = available;
      isBiometricEnrolled = biometrics.isNotEmpty;
      isBiometricEnabled = enabled;
    });
  }

  Future<void> _toggleBiometric(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isBiometricEnabled = value;
    });
    await prefs.setBool('biometric_enabled', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Biometric Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Enable Biometric Login',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
              ),
              Switch(
                value: isBiometricEnabled,
                onChanged:
                    isBiometricAvailable && isBiometricEnrolled
                        ? _toggleBiometric
                        : null,
                activeColor: Colors.red,
              ),
            ],
          ),
          Divider(color: Colors.grey),
          ListTile(
            leading: Icon(Icons.fingerprint, color: Colors.red),
            title: Text(
              'Biometric Hardware Available',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            trailing: Icon(
              isBiometricAvailable ? Icons.check_circle : Icons.cancel,
              color: isBiometricAvailable ? Colors.green : Colors.red,
            ),
          ),
          ListTile(
            leading: Icon(Icons.verified_user, color: Colors.red),
            title: Text(
              'Fingerprints Enrolled',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            trailing: Icon(
              isBiometricEnrolled ? Icons.check_circle : Icons.cancel,
              color: isBiometricEnrolled ? Colors.green : Colors.red,
            ),
          ),
          SizedBox(height: 24),
          Text(
            "Note: Due to OS restrictions, we cannot show exact number of fingerprints added. "
            "But we can detect whether any are enrolled.",
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
