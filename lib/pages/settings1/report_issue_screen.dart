import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportIssueScreen extends StatefulWidget {
  ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _issueController = TextEditingController();

  void _submitIssue() {
    if (_formKey.currentState!.validate()) {
      final issueText = _issueController.text;

      debugPrint("Reported Issue: $issueText");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Thank you for reporting the issue!'),
          backgroundColor: Colors.red,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _issueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Report an Issue"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "Describe the issue you're facing:",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _issueController,
                maxLines: 6,
                style: GoogleFonts.poppins(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[800],
                  hintText: "Type your issue here...",
                  hintStyle: GoogleFonts.poppins(color: Colors.white60),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Please enter a description' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitIssue,
                child: Text("Submit"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
