import 'package:flutter/material.dart';
import 'package:kube/pages/settings1/bank_accounts_screen.dart';
import 'package:kube/pages/settings1/biometric_auth_screen.dart';
import 'package:kube/pages/settings1/change_password.dart';
import 'package:kube/pages/settings1/edit_profile_screen.dart';
import 'package:kube/pages/settings1/faq_screen.dart';
import 'package:kube/pages/settings1/kyc_verification_screen.dart';
import 'package:kube/pages/settings1/privacy_policy_screen.dart';
import 'package:kube/pages/settings1/report_issue_screen.dart';
import 'package:kube/pages/settings1/terms_conditions_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricPreference();
  }

  Future<void> _loadBiometricPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _biometricEnabled = prefs.getBool('biometric_enabled') ?? false;
    });
  }

  void showEmailOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12),
            Text(
              "Contact via",
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
            ),
            Divider(color: Colors.grey),
            ListTile(
              leading: Image.asset('assets/gmail.png', height: 24),
              title: Text(
                "Gmail",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                launchEmailSupport();
              },
            ),
            ListTile(
              leading: Image.asset('assets/outlook.png', height: 24),
              title: Text(
                "Outlook",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                launchEmailSupport();
              },
            ),
            SizedBox(height: 10),
          ],
        );
      },
    );
  }

  void launchEmailSupport() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@kube.com',
      query: Uri.encodeFull(
        'subject=Support Request&body=Hi Team,\n\nI need help with...',
      ),
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      debugPrint("Could not launch email");
    }
  }

  Widget userProfileHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EditProfileScreen()),
          );
        },
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey[300],
              child: Icon(
                Icons.person_3_rounded,
                size: 45,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Naveen Kumar",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "naveen.kumar@example.com",
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
            ),
            SizedBox(height: 5),
            Text(
              "Tap to edit",
              style: GoogleFonts.poppins(color: Colors.red, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTile(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    String? subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(title, style: GoogleFonts.poppins(color: Colors.white)),
      subtitle:
          subtitle != null
              ? Text(subtitle, style: GoogleFonts.poppins(color: Colors.grey))
              : null,
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("App Settings"),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: 32),
        children: [
          SizedBox(height: 10),
          userProfileHeader(),

          sectionTitle("Account Settings"),
          buildTile(context, Icons.badge, "Verify Identity", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => KycVerificationScreen()),
            );
          }),
          buildTile(context, Icons.account_balance, "Bank Accounts", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BankAccountsScreen()),
            );
          }),
          buildTile(context, Icons.link, "UPI ID Management", () {}),

          sectionTitle("Privacy & App Security"),
          buildTile(
            context,
            Icons.fingerprint,
            "Biometric Authentication",
            () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BiometricAuthScreen()),
              );
              _loadBiometricPreference();
            },
            subtitle: _biometricEnabled ? 'Enabled' : 'Disabled',
          ),
          buildTile(context, Icons.shield, "App Lock", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ChangePasswordScreen()),
            );
          }),
          buildTile(context, Icons.policy, "Privacy Policy", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PrivacyPolicyScreen()),
            );
          }),
          buildTile(context, Icons.settings_applications, "Permissions", () {}),

          sectionTitle("Notifications"),
          buildTile(context, Icons.notifications, "Payment Alerts", () {}),
          buildTile(context, Icons.system_update, "App Updates", () {}),

          sectionTitle("Help & Support"),
          buildTile(context, Icons.help, "FAQs", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FAQScreen()),
            );
          }),
          buildTile(context, Icons.support_agent, "Contact Support", () {
            showEmailOptions(context);
          }),
          buildTile(context, Icons.report_problem, "Report an Issue", () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 12),
                    Text(
                      "Choose a method",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Divider(color: Colors.grey),
                    ListTile(
                      leading: Icon(Icons.email, color: Colors.redAccent),
                      title: Text(
                        "Send via Email",
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        launchEmailSupport();
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.edit, color: Colors.blueAccent),
                      title: Text(
                        "Report via Form",
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReportIssueScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                  ],
                );
              },
            );
          }),

          sectionTitle("About"),
          buildTile(context, Icons.info, "App Version", () {}),
          buildTile(context, Icons.description, "Terms & Conditions", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TermsAndConditionsScreen()),
            );
          }),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}
