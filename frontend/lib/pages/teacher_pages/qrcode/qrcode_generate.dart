import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart'; // Add this import
import 'package:shared_preferences/shared_preferences.dart';

class TeacherQrCodeGenerate extends StatefulWidget {
  final String classId;
  const TeacherQrCodeGenerate({super.key, required this.classId});

  @override
  State<TeacherQrCodeGenerate> createState() => _TeacherQrCodeGenerateState();
}

class _TeacherQrCodeGenerateState extends State<TeacherQrCodeGenerate> {
  MobileScannerController?
  cameraController; // Made nullable for proper disposal

  ApiService apiService = ApiService();
  String userID = "";
  String? qrToken;
  final TextEditingController _textController =
      TextEditingController(); // Controller for TextField

  @override
  void initState() {
    super.initState();
    _loadTeacherData();
  }

  @override
  void dispose() {
    cameraController?.dispose(); // Safe disposal
    _textController.dispose(); // Dispose text controller
    super.dispose();
  }

  Future<void> _loadTeacherData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        userID = prefs.getString('userId') ?? '';
      });
      await generateQrToken(); // Generate token after loading user data
    } catch (e) {
      print('Error loading teacher data: $e');
    }
  }

  Future<void> generateQrToken() async {
    try {
      print("Sending classId: ${widget.classId}, teacherId: $userID");

      final response = await http.post(
        Uri.parse("${ApiService.baseUrl}/session/create-session"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"classId": widget.classId, "teacherId": userID}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Response from backend: $data");
        setState(() {
          qrToken = data['qrData'];
        });
      } else {
        print("Failed with status: ${response.statusCode}");
        print("Response: ${response.body}");
        throw Exception('Failed to generate QR token');
      }
    } catch (e) {
      print('Error generating QR token: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error generating QR code: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "QR Code Generate",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Enter QR Code Data',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: kMainDarkBlue),
                ),
              ),
              onSubmitted: (value) {
                setState(() {
                  qrToken = value;
                });
              },
            ),
            const SizedBox(height: 20),
            if (qrToken != null)
              PrettyQr(
                data: qrToken!,
                size: 200,
                errorCorrectLevel: QrErrorCorrectLevel.M,
                roundEdges: true,
              ),
            ElevatedButton(
              onPressed: generateQrToken,
              child: const Text('Generate New QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}
