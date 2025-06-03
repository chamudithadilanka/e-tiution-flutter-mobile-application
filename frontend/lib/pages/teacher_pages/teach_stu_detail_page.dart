import 'package:flutter/material.dart';

class TeacherStudentDetailsPage extends StatefulWidget {
  const TeacherStudentDetailsPage({super.key});

  @override
  State<TeacherStudentDetailsPage> createState() =>
      _TeacherStudentDetailsPageState();
}

class _TeacherStudentDetailsPageState extends State<TeacherStudentDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Student Details Page"),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}
