import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/models/class_model.dart';
import 'package:frontend/pages/teacher_pages/CreateAssingment/create_asssingment_page.dart';
import 'package:frontend/pages/teacher_pages/student%20attendance/student_attendance_single_page.dart';
import 'package:frontend/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateAssignment extends StatefulWidget {
  const CreateAssignment({super.key});

  @override
  State<CreateAssignment> createState() => _CreateAssignmentState();
}

class _CreateAssignmentState extends State<CreateAssignment> {
  ApiService apiService = ApiService();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Assignment",
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
                            "Create Attendance for Class",
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
                                                            CreateAssignmentPage(
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

// import 'package:flutter/material.dart';
// import 'package:frontend/api/api_service.dart';
// import 'package:frontend/models/student_attendance_model.dart';
// import 'package:frontend/utils/colors.dart';

// class StudentAttendenceMarkPage extends StatefulWidget {
//   const StudentAttendenceMarkPage({super.key});

//   @override
//   State<StudentAttendenceMarkPage> createState() =>
//       _StudentAttendenceMarkPageState();
// }

// class _StudentAttendenceMarkPageState extends State<StudentAttendenceMarkPage> {
//   final ApiService apiService = ApiService();
//   final Map<String, String> attendanceStatus = {}; // studentId -> status
//   final List<String> statusOptions = ['present', 'absent', 'late'];

//   bool isLoading = false;
//   int? studentPresentCount;
//   int? studentCount;

//   @override
//   void initState() {
//     super.initState();
//     fetchStudentCount();
//     fetchStudentAttendancePresentCount();
//   }

//   Future<void> fetchStudentAttendancePresentCount() async {
//     final presntCount = await apiService.getTodayPresentCount();
//     print(presntCount);
//     setState(() {
//       studentPresentCount = presntCount;
//       isLoading = false;
//     });
//     print(studentPresentCount);
//   }

//   Future<void> fetchStudentCount() async {
//     final count = await apiService.getStudentCount();
//     print(count);
//     print(studentCount);
//     setState(() {
//       studentCount = count;
//       isLoading = false;
//     });
//     // OK
//     print("${studentCount} ====");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Student Attendance",
//           style: TextStyle(fontWeight: FontWeight.w500),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: FutureBuilder<List<Student>>(
//           future: apiService.fetchAllStudents(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text("Error: ${snapshot.error}"));
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return const Center(child: Text("No student found!"));
//             } else {
//               final students = snapshot.data!;
//               return Column(
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     height: 250,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [kMainColor, kMainDarkBlue],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomLeft,
//                       ),
//                       borderRadius: BorderRadius.circular(20),
//                     ),

//                     child: Padding(
//                       padding: const EdgeInsets.all(10),
//                       child: Column(
//                         children: [
//                           Text(
//                             "Student Attendance Details",
//                             style: TextStyle(
//                               fontSize: 20,
//                               color: kMainWhiteColor,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           SizedBox(height: 10),
//                           Image.asset(
//                             "assets/images/list_15648065.png",
//                             width: 80,
//                             height: 80,
//                             fit: BoxFit.cover,
//                           ),
//                           SizedBox(height: 15),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 10),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "Total Student Count :              ${studentCount ?? 0}",
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                     color: kMainWhiteColor,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 5),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 10),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "Today Present Students :       ${studentPresentCount ?? 0}",
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                     color: kMainWhiteColor,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 10),
//                           //  DropdownButton<String>(
//                           //       value:
//                           //           attendanceStatus[] ??
//                           //           'present',
//                           //       items:
//                           //           statusOptions.map((status) {
//                           //             return DropdownMenuItem(
//                           //               value: status,
//                           //               child: Text(status),
//                           //             );
//                           //           }).toList(),
//                           //       onChanged: (value) {
//                           //         setState(() {
//                           //           attendanceStatus[student.userID.id] =
//                           //               value!;
//                           //         });
//                           //       },
//                           //     ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 15),

//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: students.length,
//                       itemBuilder: (context, index) {
//                         final student = students[index];
//                         return Container(
//                           margin: const EdgeInsets.symmetric(vertical: 6),
//                           padding: const EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.3),
//                                 blurRadius: 4,
//                                 offset: const Offset(2, 3),
//                               ),
//                             ],
//                           ),

//                           child: Row(
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(25),
//                                 child: Image.network(
//                                   ApiService.ip +
//                                       "uploads/${student.profileImage}",
//                                   width: 50,
//                                   height: 50,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: Text(
//                                   "${student.userID.firstName} ${student.userID.lastName}",
//                                   style: const TextStyle(fontSize: 16),
//                                 ),
//                               ),

//                               DropdownButton<String>(
//                                 value:
//                                     attendanceStatus[student.userID.id] ??
//                                     'present',
//                                 items:
//                                     statusOptions.map((status) {
//                                       return DropdownMenuItem(
//                                         value: status,
//                                         child: Text(status),
//                                       );
//                                     }).toList(),
//                                 onChanged: (value) {
//                                   setState(() {
//                                     attendanceStatus[student.userID.id] =
//                                         value!;
//                                   });
//                                 },
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Container(
//                     width: double.infinity,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       gradient: LinearGradient(
//                         colors: [kMainColor, kMainDarkBlue],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomLeft,
//                       ),
//                     ),
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         try {
//                           List<Map<String, dynamic>> attendanceList =
//                               attendanceStatus.entries.map((entry) {
//                                 return {
//                                   "studentId": entry.key,
//                                   "status":
//                                       entry.value, // "present" or "absent"
//                                   "date": DateTime.now().toIso8601String(),
//                                 };
//                               }).toList();

//                           await apiService.markAttendanceList(attendanceList);

//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(
//                                 "Attendance submitted successfully",
//                                 style: TextStyle(
//                                   color: kMainBlackColor,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               backgroundColor: const Color.fromARGB(
//                                 255,
//                                 118,
//                                 255,
//                                 91,
//                               ),
//                             ),
//                           );
//                         } catch (e) {
//                           ScaffoldMessenger.of(
//                             context,
//                           ).showSnackBar(SnackBar(content: Text("Error: $e")));
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.transparent,
//                         shadowColor: Colors.transparent,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: Text(
//                         "Submit Attendance",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:frontend/api/api_service.dart';
// // import 'package:frontend/models/student_attendance_model.dart';
// // import 'package:frontend/utils/colors.dart';

// // class StudentAttendenceMarkPage extends StatefulWidget {
// //   const StudentAttendenceMarkPage({super.key});

// //   @override
// //   State<StudentAttendenceMarkPage> createState() =>
// //       _StudentAttendenceMarkPageState();
// // }

// // class _StudentAttendenceMarkPageState extends State<StudentAttendenceMarkPage> {
// //   final ApiService apiService = ApiService();
// //   final Map<String, String> attendanceStatus = {};
// //   final List<String> statusOptions = ['present', 'absent', 'late'];
// //   List<Student> students = [];
// //   List<String> streamList = ['All', 'Grade 6', 'Grade 7', 'Grade 8', 'Grade 9'];
// //   String selectedStream = 'All';
// //   int? studentPresentCount;
// //   int? studentCount;
// //   bool isLoading = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchStudentCount();
// //     fetchStudentAttendancePresentCount();
// //     fetchStudentsByStream(selectedStream);
// //   }

// //   Future<void> fetchStudentsByStream(String stream) async {
// //     setState(() => isLoading = true);

// //     List<Student> fetchedStudents = [];

// //     if (stream == 'All') {
// //       fetchedStudents = await apiService.fetchAllStudents();
// //     } else {
// //       fetchedStudents = await apiService.fetchStudentsByStream(stream);
// //     }

// //     setState(() {
// //       students = fetchedStudents;
// //       isLoading = false;
// //     });
// //   }

// //   Future<void> fetchStudentAttendancePresentCount() async {
// //     final presentCount = await apiService.getTodayPresentCount();
// //     setState(() {
// //       studentPresentCount = presentCount;
// //     });
// //   }

// //   Future<void> fetchStudentCount() async {
// //     final count = await apiService.getStudentCount();
// //     setState(() {
// //       studentCount = count;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Student Attendance")),
// //       body: Padding(
// //         padding: const EdgeInsets.all(10),
// //         child: Column(
// //           children: [
// //             Container(
// //               width: double.infinity,
// //               height: 280,
// //               decoration: BoxDecoration(
// //                 gradient: LinearGradient(
// //                   colors: [kMainColor, kMainDarkBlue],
// //                   begin: Alignment.topLeft,
// //                   end: Alignment.bottomLeft,
// //                 ),
// //                 borderRadius: BorderRadius.circular(20),
// //               ),
// //               child: Padding(
// //                 padding: const EdgeInsets.all(10),
// //                 child: Column(
// //                   children: [
// //                     const SizedBox(height: 10),
// //                     Text(
// //                       "Student Attendance Details",
// //                       style: TextStyle(
// //                         fontSize: 20,
// //                         color: kMainWhiteColor,
// //                         fontWeight: FontWeight.w600,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 10),
// //                     Image.asset(
// //                       "assets/images/list_15648065.png",
// //                       width: 80,
// //                       height: 80,
// //                     ),
// //                     const SizedBox(height: 15),
// //                     Text(
// //                       "Total Student Count: ${studentCount ?? 0}",
// //                       style: TextStyle(color: kMainWhiteColor),
// //                     ),
// //                     const SizedBox(height: 5),
// //                     Text(
// //                       "Today Present Students: ${studentPresentCount ?? 0}",
// //                       style: TextStyle(color: kMainWhiteColor),
// //                     ),
// //                     const SizedBox(height: 15),
// //                     DropdownButton<String>(
// //                       value: selectedStream,
// //                       dropdownColor: Colors.white,
// //                       items:
// //                           streamList.map((stream) {
// //                             return DropdownMenuItem(
// //                               value: stream,
// //                               child: Text(stream),
// //                             );
// //                           }).toList(),
// //                       onChanged: (value) {
// //                         setState(() {
// //                           selectedStream = value!;
// //                           fetchStudentsByStream(value);
// //                         });
// //                       },
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 15),
// //             isLoading
// //                 ? const CircularProgressIndicator()
// //                 : Expanded(
// //                   child: ListView.builder(
// //                     itemCount: students.length,
// //                     itemBuilder: (context, index) {
// //                       final student = students[index];
// //                       return Container(
// //                         margin: const EdgeInsets.symmetric(vertical: 6),
// //                         padding: const EdgeInsets.all(10),
// //                         decoration: BoxDecoration(
// //                           color: Colors.white,
// //                           borderRadius: BorderRadius.circular(10),
// //                           boxShadow: [
// //                             BoxShadow(
// //                               color: Colors.grey.withOpacity(0.3),
// //                               blurRadius: 4,
// //                               offset: const Offset(2, 3),
// //                             ),
// //                           ],
// //                         ),
// //                         child: Row(
// //                           children: [
// //                             ClipRRect(
// //                               borderRadius: BorderRadius.circular(25),
// //                               child: Image.network(
// //                                 ApiService.ip +
// //                                     "uploads/${student.profileImage}",
// //                                 width: 50,
// //                                 height: 50,
// //                                 fit: BoxFit.cover,
// //                               ),
// //                             ),
// //                             const SizedBox(width: 12),
// //                             Expanded(
// //                               child: Text(
// //                                 "${student.userID.firstName} ${student.userID.lastName}",
// //                                 style: const TextStyle(fontSize: 16),
// //                               ),
// //                             ),
// //                             DropdownButton<String>(
// //                               value:
// //                                   attendanceStatus[student.userID.id] ??
// //                                   'present',
// //                               items:
// //                                   statusOptions.map((status) {
// //                                     return DropdownMenuItem(
// //                                       value: status,
// //                                       child: Text(status),
// //                                     );
// //                                   }).toList(),
// //                               onChanged: (value) {
// //                                 setState(() {
// //                                   attendanceStatus[student.userID.id] = value!;
// //                                 });
// //                               },
// //                             ),
// //                           ],
// //                         ),
// //                       );
// //                     },
// //                   ),
// //                 ),
// //             const SizedBox(height: 10),
// //             Container(
// //               width: double.infinity,
// //               height: 50,
// //               decoration: BoxDecoration(
// //                 borderRadius: BorderRadius.circular(12),
// //                 gradient: LinearGradient(
// //                   colors: [kMainColor, kMainDarkBlue],
// //                   begin: Alignment.topLeft,
// //                   end: Alignment.bottomLeft,
// //                 ),
// //               ),
// //               child: ElevatedButton(
// //                 onPressed: () async {
// //                   try {
// //                     List<Map<String, dynamic>> attendanceList =
// //                         attendanceStatus.entries
// //                             .map(
// //                               (entry) => {
// //                                 "studentId": entry.key,
// //                                 "status": entry.value,
// //                                 "date": DateTime.now().toIso8601String(),
// //                               },
// //                             )
// //                             .toList();

// //                     await apiService.markAttendance(attendanceList);

// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       const SnackBar(
// //                         content: Text("Attendance submitted successfully"),
// //                         backgroundColor: Colors.green,
// //                       ),
// //                     );
// //                   } catch (e) {
// //                     ScaffoldMessenger.of(
// //                       context,
// //                     ).showSnackBar(SnackBar(content: Text("Error: $e")));
// //                   }
// //                 },
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Colors.transparent,
// //                   shadowColor: Colors.transparent,
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                 ),
// //                 child: const Text(
// //                   "Submit Attendance",
// //                   style: TextStyle(
// //                     color: Colors.white,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
