// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_tools/qr_code_tools.dart';

class UpiScannerPage extends StatefulWidget {
  const UpiScannerPage({super.key});

  @override
  State<UpiScannerPage> createState() => _UpiScannerPageState();
}

class _UpiScannerPageState extends State<UpiScannerPage> {
  final MobileScannerController controller = MobileScannerController();
  bool flashOn = false;

  void _pickImageAndScan() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      try {
        String? qrCode = await QrCodeToolsPlugin.decodeFrom(image.path);
        if (qrCode != null) {
          _showResultDialog(qrCode);
        } else {
          _showErrorDialog("No QR code found in image.");
        }
      } catch (e) {
        _showErrorDialog("Failed to read QR code.");
      }
    }
  }

  void _showResultDialog(String result) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("QR Code Scanned"),
            content: Text(result),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Error"),
            content: Text(msg),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// Live Camera View
          MobileScanner(
            controller: controller,
            onDetect: (BarcodeCapture capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String? value = barcodes.first.rawValue;
                if (value != null) {
                  _showResultDialog(value);
                }
              }
            },
          ),

          /// UI Overlay
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      const BackButton(color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        "Scan any QR",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          flashOn ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          controller.toggleTorch();
                          setState(() => flashOn = !flashOn);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.help_outline,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                /// Purple Corner QR Frame
                Center(
                  child: Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomPaint(painter: _QRFramePainter()),
                  ),
                ),

                const Spacer(),

                /// Upload QR + Torch
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _actionButton(
                        Icons.image,
                        "Upload QR",
                        _pickImageAndScan,
                      ),
                      _actionButton(Icons.flashlight_on, "Torch", () {
                        controller.toggleTorch();
                        setState(() => flashOn = !flashOn);
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// BHIM | UPI Logos
                /*Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Image.asset(
                    "assets/images/upi_grey_logo.png",
                    height: 30,
                  ),
                ),*/
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: null,
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white10,
            child: Icon(icon, color: Colors.white),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }
}

class _QRFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Color(0xFFB8D8C1)
          ..strokeWidth = 4
          ..style = PaintingStyle.stroke;

    const double len = 25;
    //  const double cornerRadius = 20;

    final Path path = Path();

    // Top Left
    path.moveTo(0, len);
    path.lineTo(0, 0);
    path.lineTo(len, 0);

    // Top Right
    path.moveTo(size.width - len, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, len);

    // Bottom Right
    path.moveTo(size.width, size.height - len);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - len, size.height);

    // Bottom Left
    path.moveTo(len, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height - len);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
