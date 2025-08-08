import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/models/class_model.dart';

class ClassesListSingalePage extends StatefulWidget {
  final String classId;

  const ClassesListSingalePage({super.key, required this.classId});

  @override
  State<ClassesListSingalePage> createState() => _ClassesListSingalePageState();
}

class _ClassesListSingalePageState extends State<ClassesListSingalePage> {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Class Details"),
        backgroundColor: Colors.white,
      ),

      body: FutureBuilder(
        future: apiService.getClassById(widget.classId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("No class data found."));
          } else {
            ClassModel classmdel = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Class Name: ${classmdel.className}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text("Class Code: ${classmdel.description}"),
                  SizedBox(height: 10),
                  Text("Subject: ${classmdel.subject}"),
                  SizedBox(height: 10),
                  Text("Teacher: ${classmdel.id}"),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
