import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/models/class_model.dart';
import 'package:frontend/pages/teacher_pages/teacher%20home%20pages/classes_list_single_page.dart';
import 'package:frontend/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherClassesList extends StatefulWidget {
  const TeacherClassesList({super.key});

  @override
  State<TeacherClassesList> createState() => _TeacherClassesListState();
}

class _TeacherClassesListState extends State<TeacherClassesList> {
  String firstName = "";
  String lastName = "";
  String email = "";
  String role = "";
  bool isRole = true;
  bool isLoading = true;

  String userID = "";
  String profileImage = "";
  String gender = "";
  int age = 0;
  String qualifications = "";
  List<String> subjects = [];
  List<String> gradesTaught = [];
  String bio = "";
  String profileImageBase64 = ""; //change this to base64 string
  int? studentCount;
  int? studentPresentCount;
  ApiService apiservice = ApiService();

  @override
  void initState() {
    super.initState();
    // fetchClasses();
    _loadTeacherData();
  }

  Future<void> _loadTeacherData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        userID = prefs.getString('userId') ?? '';
        profileImage = prefs.getString('profileImage') ?? '';
        gender = prefs.getString('gender') ?? '';
        age = (prefs.getInt('age') ?? 0);
        qualifications = prefs.getString('qualifications') ?? '';
        subjects = prefs.getStringList('subjects') ?? [];
        gradesTaught = prefs.getStringList('gradesTaught') ?? [];
        bio = prefs.getString('bio') ?? '';
      });
      print(
        "Teacher Data Loaded: $userID $profileImage $gender $age $qualifications $subjects $gradesTaught $bio",
      );
      print(
        "Profile Image Base64: $profileImageBase64",
      ); //change this to base64 string
    } catch (e) {
      print('Error loading teacher data: $e');
    }
  }

  // void fetchClasses() async {
  //   final apiService = ApiService();
  //   final userId = userID;

  //   try {
  //     final classes = await apiService.getClassesByTeacherUserId(userId);
  //     print("Teacher's Classes: $classes");
  //   } catch (e) {
  //     print("Error: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Classes List")),
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
                    height: MediaQuery.of(context).size.height * 0.140,
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
                                                            ClassesListSingalePage(
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
