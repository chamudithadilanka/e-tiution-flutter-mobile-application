import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/models/class_model.dart';
import 'package:frontend/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FutureClassStudents extends StatefulWidget {
  const FutureClassStudents({super.key});

  @override
  State<FutureClassStudents> createState() => _FutureClassStudentsState();
}

class _FutureClassStudentsState extends State<FutureClassStudents> {
  String userID = "";
  String profileImage = "";
  String gender = "";
  int age = 0;
  String stream = "";

  ApiService apiservice = ApiService();

  @override
  void initState() {
    super.initState();
    _loadstudentData();
  }

  Future<void> _loadstudentData() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        userID = preferences.getString("userId") ?? "";
        profileImage = preferences.getString("profileImage") ?? "";
        gender = preferences.getString("gender") ?? "";
        age = preferences.getInt("age") ?? 0;
        stream = preferences.getString("stream") ?? "";
      });
      print("Student Data Loaded: $userID $profileImage $gender $age $stream");

      print(
        "Profile Image:=========-----------------==================--------- $profileImage",
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Classes"),
        backgroundColor: kMainWhiteColor,
      ),
      body: FutureBuilder<List<ClassModel>>(
        future: apiservice.getClassesByGrade(stream),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("error${snapshot.error}"));
          } else if (!snapshot.hasData == !snapshot.data!.isEmpty) {
            return const Center(child: Text("Empty "));
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3, // Width / Height ratio (adjust as needed)
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                ClassModel classModel = snapshot.data![index];
                return SafeArea(
                  child: Container(
                    decoration: BoxDecoration(
                      color: kMainWhiteColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        classModel.className,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
