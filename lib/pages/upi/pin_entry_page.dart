import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'payment_success_page.dart';

class EnterPinPage extends StatefulWidget {
  final String amount;
  EnterPinPage({super.key, required this.amount});

  @override
  State<EnterPinPage> createState() => _EnterPinPageState();
}

class _EnterPinPageState extends State<EnterPinPage> {
  String _pin = '';

  void _addDigit(String digit) {
    if (_pin.length < 4) {
      setState(() {
        _pin += digit;
      });
    }
  }

  void _removeLastDigit() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _submitPin() {
    if (_pin.length == 4) {
      /*ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("PIN entered successfully")));*/
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => PaymentSuccessPage(amount: int.parse(widget.amount)),
        ),
      );
      // Handle submission
    }
  }

  Widget _buildPinBox(int index) {
    final isFilled = index < _pin.length;
    return Container(
      width: 50,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFilled ? Color(0xFFB8D8C1) : Colors.white24,
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child:
          isFilled
              ? const Icon(Icons.circle, size: 12, color: Colors.white)
              : const SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Enter UPI PIN',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              "Securely enter your 4-digit UPI PIN",
              style: GoogleFonts.poppins(
                color: Colors.grey.shade400,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, _buildPinBox),
            ),
            const Spacer(),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              padding: const EdgeInsets.all(12),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: List.generate(12, (index) {
                if (index == 9) {
                  return const SizedBox.shrink();
                } else if (index == 10) {
                  return _numpadButton('0');
                } else if (index == 11) {
                  return _numpadButton('', isBack: true);
                } else {
                  return _numpadButton('${index + 1}');
                }
              }),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _submitPin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB8D8C1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Confirm & Pay",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _numpadButton(String label, {bool isBack = false}) {
    return InkWell(
      onTap: () {
        if (isBack) {
          _removeLastDigit();
        } else if (label.isNotEmpty) {
          _addDigit(label);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[700]!),
        ),
        alignment: Alignment.center,
        child:
            isBack
                ? Icon(
                  Icons.backspace_outlined,
                  size: 28,
                  color: Colors.redAccent,
                )
                : Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
      ),
    );
  }
}
