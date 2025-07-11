import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KycVerificationScreen extends StatefulWidget {
  @override
  _KycVerificationScreenState createState() => _KycVerificationScreenState();
}

class _KycVerificationScreenState extends State<KycVerificationScreen> {
  final TextEditingController _panController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isVerifying = false;
  String? kycStatus;
  bool isPanValid = true;

  final RegExp panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');

  void _verifyPAN() {
    final pan = _panController.text.trim().toUpperCase();

    if (!panRegex.hasMatch(pan)) {
      setState(() {
        isPanValid = false;
        kycStatus = "failed";
      });
      return;
    }

    setState(() {
      isVerifying = true;
      isPanValid = true;
    });

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isVerifying = false;
        kycStatus = "verified";
      });

      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isVerified = kycStatus == "verified";

    return Scaffold(
      backgroundColor: isVerified ? Colors.green[700] : Colors.red,
      appBar: AppBar(
        backgroundColor: isVerified ? Colors.green[00] : Colors.red,
        title: Text(
          "KYC Verification",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child:
              isVerified
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        size: 100,
                        color: Colors.white,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "KYC Verified Successfully!",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                  : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Enter your PAN card number to verify your KYC status.",
                        style: GoogleFonts.poppins(
                          color: Colors.grey[300],
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _panController,
                          textCapitalization: TextCapitalization.characters,
                          onChanged: (value) {
                            if (panRegex.hasMatch(value.trim().toUpperCase())) {
                              setState(() {
                                isPanValid = true;
                              });
                            }
                          },
                          style: GoogleFonts.poppins(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'PAN Card Number',
                            labelStyle: GoogleFonts.poppins(color: Colors.grey),
                            hintText: 'ABCDE1234F',
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey[500],
                            ),
                            filled: true,
                            fillColor: Color(0xFF1E1E1E),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorText:
                                isPanValid
                                    ? null
                                    : 'Enter a valid PAN number (ABCDE1234F)',
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFB8D8C1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 14,
                          ),
                        ),
                        onPressed:
                            isVerifying
                                ? null
                                : () {
                                  _verifyPAN();
                                },
                        child:
                            isVerifying
                                ? CircularProgressIndicator(color: Colors.black)
                                : Text(
                                  "Verify Now",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                  ),
                                ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
