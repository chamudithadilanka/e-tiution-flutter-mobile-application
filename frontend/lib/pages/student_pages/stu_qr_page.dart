import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentQrCodePage extends StatefulWidget {
  const StudentQrCodePage({super.key});

  @override
  State<StudentQrCodePage> createState() => _StudentQrCodePageState();
}

class _StudentQrCodePageState extends State<StudentQrCodePage> {
  bool _hasScanned = false;
  String studentId = "";
  String? qrToken; // Added to store the scanned token
  MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  @override
  void initState() {
    super.initState();
    _loadStudentId();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _loadStudentId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      studentId = prefs.getString("userId") ?? "";
    });
  }

  // Extracted the dialog to a separate method
  void _showScanDialog(String token) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("QR Code Scanned"),
            content: Text(
              "Token: $token" + " Attendance Marked Successfully !",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  Future<void> _handleScan(String qrToken) async {
    if (_hasScanned || studentId.isEmpty) return;

    setState(() {
      _hasScanned = true;
      this.qrToken = qrToken;
    });

    try {
      final response = await http.post(
        Uri.parse("${ApiService.baseUrl}/qrattendance/mark-attendance"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"studentId": studentId, "qrToken": qrToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String message = data['message'] ?? 'Attendance marked successfully';
        _showScanDialog(qrToken); // Show dialog after successful scan
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      } else {
        throw Exception('Failed to mark attendance');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    } finally {
      // Reset scan state after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _hasScanned = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scane QR and Mark Attendance')),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (_hasScanned) return;
              final List<Barcode> barcodes = capture.barcodes;

              for (final barcode in barcodes) {
                final String? value = barcode.rawValue;
                if (value != null) {
                  _handleScan(value);
                  break;
                }
              }
            },
          ), // Add a semi-transparent overlay with a scan window
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.487,
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
            ),
          ),

          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Text(
              "Scan QR Code",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: kMainWhiteColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          Positioned(
            top: 200.5,
            left: 366,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.794,
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
            ),
          ),

          Positioned(
            top: 200.5,
            left: 0,
            right: 366,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.794,
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
            ),
          ),

          Positioned(
            top: 527,
            left: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.483,
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
            ),
          ),

          Positioned(
            top: 560,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Scan QR Code to Mark Attendance your each Class and Before Get Permission Your Class Teacher.  ",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kMainWhiteColor.withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          _buildScannerOverlay(context),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          border: Border.all(color: kMainNavSelected, width: 6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.width * 0.1),
            LottieBuilder.asset(
              "assets/animations/Animation - 1750473004398.json",
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
