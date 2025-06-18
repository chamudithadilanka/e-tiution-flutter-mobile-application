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
      appBar: AppBar(title: const Text('Student QR Code Scanner')),
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
          border: Border.all(color: kMainNavSelected, width: 3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(children: [LottieBuilder.asset("")]),
      ),
    );
  }
}
