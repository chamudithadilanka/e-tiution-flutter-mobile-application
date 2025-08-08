import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/models/class_model.dart';
import 'package:frontend/pages/teacher_pages/createVideoTutorial/create_video_single_page.dart';
import 'package:frontend/pages/teacher_pages/timetable/timetable_mainpage.dart';
import 'package:frontend/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassTimetable extends StatefulWidget {
  const ClassTimetable({super.key});

  @override
  State<ClassTimetable> createState() => _ClassTimetableState();
}

class _ClassTimetableState extends State<ClassTimetable> {
  ApiService apiservice = ApiService();
  String userID = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTeacherData();
  }

  Future<void> _loadTeacherData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      setState(() {
        userID = prefs.getString('userId') ?? '';

        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Error loading teacher data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Time Schedule",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: FutureBuilder<List<ClassModel>>(
        future: apiservice.getClassesByTeacherUserId(userID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("error${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Empty "));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                ClassModel classModel = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.90,
                    height: MediaQuery.of(context).size.height * 0.180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [kMainColor, kMainDarkBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text(
                            "Create Time Scheduale for Class",
                            style: TextStyle(
                              color: kMainWhiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.116,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: kMainWhiteColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Teacher image
                                  Container(
                                    width: 80,
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.10,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: kMainWhiteColor,
                                        width: 3,
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          classModel.teacher?.profileImageUrl ??
                                              'https://via.placeholder.com/150',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),

                                  SizedBox(width: 10),

                                  // Class info and button in a flexible layout
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Class Info
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                classModel.className,
                                                style: TextStyle(
                                                  color: kMainWhiteColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                "Grade : ${classModel.grade}",
                                                style: TextStyle(
                                                  color: kMainWhiteColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                "Subject : ${classModel.subject}",
                                                style: TextStyle(
                                                  color: kMainWhiteColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Button aligned bottom right
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Container(
                                            width: 75,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              gradient: LinearGradient(
                                                colors: [
                                                  kMainColor,
                                                  kMainDarkBlue,
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                            ),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors
                                                        .transparent, // Button color
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            TimetableMainPage(
                                                              classId:
                                                                  classModel.id,
                                                            ),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                "Open",
                                                style: TextStyle(
                                                  color: kMainWhiteColor,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
