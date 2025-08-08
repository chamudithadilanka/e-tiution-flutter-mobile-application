import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/models/class_model.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/widget/animations/imagebackground_color.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JoinedClassesStudent extends StatefulWidget {
  final String classId;
  const JoinedClassesStudent({super.key, required this.classId});

  @override
  State<JoinedClassesStudent> createState() => _JoinedClassesStudentState();
}

class _JoinedClassesStudentState extends State<JoinedClassesStudent> {
  final ApiService apiservice = ApiService();

  String stuserID = "";
  String profileImage = "";
  String gender = "";
  int age = 0;
  String stream = "";

  late AnimationController _controller;
  late Animation<Color> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        stuserID = preferences.getString("userId") ?? "";
        profileImage = preferences.getString("profileImage") ?? "";
        gender = preferences.getString("gender") ?? "";
        age = preferences.getInt("age") ?? 0;
        stream = preferences.getString("stream") ?? "";
      });
      print(
        "Student Data Loaded: $stuserID $profileImage $gender $age $stream",
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Joined Class"),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: apiservice.getClassById(widget.classId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.beat(
                color: kMainNavSelected,
                size: 50,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No data found"));
          } else {
            ClassModel classmdel = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [kMainColor, kMainDarkBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.fromBorderSide(
                          BorderSide(color: kMainWhiteColor, width: 3),
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Hi I' am your teacher",
                              style: TextStyle(
                                color: kMainWhiteColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 10),
                            // Container(
                            //   width: 100,
                            //   height: 100,
                            //   decoration: BoxDecoration(
                            //     border: Border.all(
                            //       color: kMainWhiteColor,
                            //       width: 2,
                            //     ),
                            //     shape: BoxShape.circle,
                            //     image: DecorationImage(
                            //       image: NetworkImage(
                            //         classmdel.teacher.profileImageUrl ??
                            //             'https://via.placeholder.com/150',
                            //       ),
                            //       fit: BoxFit.cover,
                            //     ),
                            //   ),
                            // ),
                            ImageAnimationGradien(
                              imageUrl:
                                  classmdel.teacher.profileImageUrl ??
                                  'https://via.placeholder.com/150',
                              size: 100,
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  classmdel.teacher.firstName ?? 'Unknown',
                                  style: TextStyle(
                                    color: kMainWhiteColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  classmdel.teacher.lastName ?? 'Unknown',
                                  style: TextStyle(
                                    color: kMainWhiteColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              classmdel.className,
                              style: TextStyle(
                                color: kMainWhiteColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
