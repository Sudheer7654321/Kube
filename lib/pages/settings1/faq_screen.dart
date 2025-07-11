import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FAQScreen extends StatelessWidget {
  FAQScreen({super.key});

  final List<Map<String, String>> faqs = [
    {
      "question": "How to enable biometric authentication?",
      "answer": "Go to 'Biometric Authentication' and follow the prompts.",
    },
    {
      "question": "How to update my bank account details?",
      "answer": "Visit 'Bank Accounts' section to add or remove accounts.",
    },
    {
      "question": "How do I report a problem?",
      "answer": "Go to 'Report an Issue' in the Help & Support section.",
    },
    {
      "question": "Where can I view my KYC status?",
      "answer": "Check the 'KYC Verification Status' under Account Settings.",
    },
    {
      "question": "How can I check my app version?",
      "answer":
          "Go to 'About > App Version' at the bottom of the settings screen.",
    },
    {
      "question": "How to manage permissions?",
      "answer": "Tap 'Permissions' under the 'Security & Privacy' section.",
    },
    {
      "question": "Can I disable payment alerts?",
      "answer":
          "Yes, go to 'Payment Alerts' in Notifications to toggle alerts.",
    },
    {
      "question": "How to delete my account?",
      "answer": "Please contact support through the 'Contact Support' option.",
    },
    {
      "question": "How to set App Lock?",
      "answer":
          "Enable it from the 'App Lock' option under Security & Privacy.",
    },
    {
      "question": "How can I update the app?",
      "answer": "Go to 'App Updates' to check if any updates are available.",
    },
    {
      "question": "What is the privacy policy?",
      "answer": "Tap 'Privacy Policy' under Security to view full details.",
    },
    {
      "question": "Where can I read Terms & Conditions?",
      "answer": "In the About section, tap 'Terms & Conditions'.",
    },
    {
      "question": "How to add another bank account?",
      "answer": "Go to Bank Accounts > Add New Account.",
    },
    {
      "question": "Is my biometric data stored?",
      "answer": "No, biometric data is stored securely by your device.",
    },
    {
      "question": "How to contact support?",
      "answer": "Use the 'Contact Support' option in Help & Support.",
    },
    {
      "question": "Can I change my registered UPI ID?",
      "answer": "Yes, through the 'UPI ID Management' option.",
    },
    {
      "question": "Where to report a bug?",
      "answer": "Use the 'Report an Issue' section in Help & Support.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("FAQs"),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemCount: faqs.length,
        padding: EdgeInsets.all(16),
        separatorBuilder: (_, __) => SizedBox(height: 10),
        itemBuilder: (context, index) {
          return ExpansionTile(
            collapsedBackgroundColor: Colors.deepPurple.shade50.withOpacity(
              0.1,
            ),
            backgroundColor: Colors.deepPurple.shade100.withOpacity(0.1),
            title: Text(
              faqs[index]["question"]!,
              style: GoogleFonts.poppins(color: Colors.red),
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  faqs[index]["answer"]!,
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
