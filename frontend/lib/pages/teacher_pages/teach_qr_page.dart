import 'package:flutter/material.dart';

class TeacherQrPage extends StatefulWidget {
  const TeacherQrPage({super.key});

  @override
  State<TeacherQrPage> createState() => _TeacherQrPageState();
}

class _TeacherQrPageState extends State<TeacherQrPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Teacher QR Code Page")));
  }
}
