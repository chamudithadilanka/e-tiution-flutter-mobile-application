import 'package:flutter/material.dart';

class StudentQrCodePage extends StatefulWidget {
  const StudentQrCodePage({super.key});

  @override
  State<StudentQrCodePage> createState() => _StudentQrCodePageState();
}

class _StudentQrCodePageState extends State<StudentQrCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student QR Code Page')),
      body: Center(child: Text('Student QR Code Page')),
    );
  }
}
