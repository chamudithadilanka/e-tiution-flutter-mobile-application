// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:frontend/api/api_service.dart';
// import 'package:frontend/utils/colors.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';

// class StudentAttendanceSinglePage extends StatefulWidget {
//   final String classId;

//   const StudentAttendanceSinglePage({super.key, required this.classId});

//   @override
//   State<StudentAttendanceSinglePage> createState() =>
//       _StudentAttendanceSinglePageState();
// }

// class _StudentAttendanceSinglePageState
//     extends State<StudentAttendanceSinglePage> {
//   final ApiService apiService = ApiService();
//   final Map<String, String> attendanceStatus = {}; // studentId -> status
//   List<String> statusOptions = ['Select', 'present', 'absent', 'late'];
//   late Future<List<dynamic>> _studentsFuture;

//   @override
//   void initState() {
//     super.initState();
//     _studentsFuture = apiService.getStudentsByClassId(widget.classId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Student Attendance")),
//       body: FutureBuilder<List<dynamic>>(
//         future: _studentsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: LoadingAnimationWidget.fourRotatingDots(
//                 color: kMainNavSelected,
//                 size: 50,
//               ),
//             );
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text("No students found"));
//           }

//           final students = snapshot.data!;
//           return RefreshIndicator(
//             onRefresh: () async {
//               setState(() {
//                 _studentsFuture = apiService.getStudentsByClassId(
//                   widget.classId,
//                 );
//               });
//             },
//             child: ListView.builder(
//               itemCount: students.length,
//               itemBuilder: (context, index) {
//                 final student = students[index];
//                 final studentId = student['_id'];
//                 final fullName =
//                     '${student['firstName']} ${student['lastName']}';
//                 final profileImageUrl = student['profileImageUrl'] ?? '';

//                 // Set default status if not set
//                 attendanceStatus.putIfAbsent(studentId, () => 'Select');

//                 return Column(
//                   children: [
//                     SizedBox(height: 10),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 10,
//                         vertical: 6,
//                       ),
//                       child: Card(
//                         elevation: 3,
//                         child: ListTile(
//                           leading: CircleAvatar(
//                             radius: 25,
//                             backgroundImage:
//                                 profileImageUrl.isNotEmpty
//                                     ? NetworkImage(profileImageUrl)
//                                     : null,
//                             child:
//                                 profileImageUrl.isEmpty
//                                     ? Text(fullName[0])
//                                     : null,
//                           ),
//                           title: Text(fullName),
//                           subtitle: Text(student['email'] ?? 'N/A'),
//                           trailing: DropdownButton<String>(
//                             value: attendanceStatus[studentId],
//                             items:
//                                 statusOptions.map((status) {
//                                   return DropdownMenuItem(
//                                     value: status,
//                                     child: Text(status.toUpperCase()),
//                                   );
//                                 }).toList(),
//                             onChanged: (value) async {
//                               if (value == null || value == 'Select') {
//                                 // Just update dropdown state, don't send to backend
//                                 setState(() {
//                                   attendanceStatus[studentId] = value!;
//                                 });
//                                 return; // 🔒 DO NOT proceed if it's "Select"
//                               }

//                               setState(() {
//                                 attendanceStatus[studentId] = value!;
//                               });

//                               try {
//                                 final response = await http.post(
//                                   Uri.parse(
//                                     '${ApiService.baseUrl}/attendance/mark/each-classes',
//                                   ),
//                                   headers: {'Content-Type': 'application/json'},
//                                   body: jsonEncode({
//                                     'classId': widget.classId,
//                                     'studentId': studentId,
//                                     'status': value,
//                                     'date': DateTime.now().toIso8601String(),
//                                   }),
//                                 );

//                                 if (response.statusCode == 201) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Text(
//                                         'Attendance marked for $fullName',
//                                       ),
//                                     ),
//                                   );
//                                 } else {
//                                   final errorMsg =
//                                       jsonDecode(response.body)['message'] ??
//                                       'Failed';
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(content: Text(' $errorMsg')),
//                                   );
//                                 }
//                               } catch (e) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(content: Text('Network error: $e')),
//                                 );
//                                 print(e);
//                               }
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _submitAttendance,
//         icon: const Icon(Icons.save, color: kMainWhiteColor),
//         label: const Text(
//           'Submit',
//           style: TextStyle(color: kMainWhiteColor, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: kMainColor,
//       ),
//     );
//   }

//   Future<void> _submitAttendance() async {
//     try {
//       print("📝 Submitting attendance for class: ${widget.classId}");

//       bool anyAlreadyMarked = false;

//       for (var entry in attendanceStatus.entries) {
//         final studentId = entry.key;
//         final status = entry.value;

//         print("➡️ Student ID: $studentId | Status: $status");

//         final result = await apiService.markAttendance(
//           context: context,
//           classId: widget.classId,
//           studentId: studentId,
//           status: status,
//         );

//         if (result == "already_marked") {
//           anyAlreadyMarked = true;
//         }
//       }

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             anyAlreadyMarked
//                 ? '⚠️ Some attendance already marked!'
//                 : '✅ Attendance submitted successfully',
//           ),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('❌ Error submitting attendance: $e')),
//       );
//     }
//   }

//   // Future<void> markAttendance({
//   //   required String classId,
//   //   required String studentId,
//   //   required String status,
//   // }) async {
//   //   final url = Uri.parse('${ApiService.baseUrl}/attendance/mark/each-classes');

//   //   try {
//   //     final response = await http.post(
//   //       url,
//   //       headers: {"Content-Type": "application/json"},
//   //       body: jsonEncode({
//   //         "classId": classId,
//   //         "studentId": studentId,
//   //         "status": status,
//   //         "date": DateTime.now().toIso8601String(),
//   //       }),
//   //     );

//   //     final data = jsonDecode(response.body);

//   //     if (response.statusCode != 201 || data['success'] != true) {
//   //       throw Exception(data['message'] ?? 'Unknown error');
//   //     }
//   //   } catch (e) {
//   //     throw Exception("Failed to mark attendance: $e");
//   //   }
//   // }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/models/attendance_day_details_model.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/api/api_service.dart';
import 'package:frontend/utils/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

class StudentAttendanceSinglePage extends StatefulWidget {
  final String classId;

  const StudentAttendanceSinglePage({super.key, required this.classId});

  @override
  State<StudentAttendanceSinglePage> createState() =>
      _StudentAttendanceSinglePageState();
}

class _StudentAttendanceSinglePageState
    extends State<StudentAttendanceSinglePage> {
  final ApiService apiService = ApiService();
  final Map<String, String> attendanceStatus = {}; // studentId -> status
  List<String> statusOptions = ['Select', 'present', 'absent', 'late'];
  late Future<List<dynamic>> _studentsFuture;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _studentsFuture = apiService.getStudentsByClassId(widget.classId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Attendance")),
      body: Column(children: [_detailBox(), Expanded(child: _futureBuilder())]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submitAttendance,
        icon: const Icon(Icons.save, color: kMainWhiteColor),
        label: const Text(
          'Submit',
          style: TextStyle(color: kMainWhiteColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kMainColor,
      ),
    );
  }

  Future<void> _submitAttendance() async {
    try {
      print("📝 Submitting attendance for class: ${widget.classId}");

      bool anyAlreadyMarked = false;

      for (var entry in attendanceStatus.entries) {
        final studentId = entry.key;
        final status = entry.value;

        print("➡️ Student ID: $studentId | Status: $status");

        final result = await apiService.markAttendance(
          context: context,
          classId: widget.classId,
          studentId: studentId,
          status: status,
        );

        if (result == "already_marked") {
          anyAlreadyMarked = true;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            anyAlreadyMarked
                ? '⚠️ Some attendance already marked!'
                : '✅ Attendance submitted successfully',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error submitting attendance: $e')),
      );
    }
  }

  Widget _futureBuilder() {
    return FutureBuilder<List<dynamic>>(
      future: _studentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.fourRotatingDots(
              color: kMainNavSelected,
              size: 50,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No students found"));
        }

        final students = snapshot.data!;
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _studentsFuture = apiService.getStudentsByClassId(widget.classId);
            });
          },
          child: ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              final studentId = student['_id'];
              final fullName = '${student['firstName']} ${student['lastName']}';
              final profileImageUrl = student['profileImageUrl'] ?? '';

              // Set default status if not set
              attendanceStatus.putIfAbsent(studentId, () => 'Select');

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Card(
                      elevation: 3,
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              profileImageUrl.isNotEmpty
                                  ? NetworkImage(profileImageUrl)
                                  : null,
                          child:
                              profileImageUrl.isEmpty
                                  ? Text(fullName[0])
                                  : null,
                        ),
                        title: Text(
                          fullName,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(student['email'] ?? 'N/A'),
                        trailing: DropdownButton<String>(
                          value: attendanceStatus[studentId],
                          items:
                              statusOptions.map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: Text(status.toUpperCase()),
                                );
                              }).toList(),
                          onChanged: (value) async {
                            if (value == null || value == 'Select') {
                              // Just update dropdown state, don't send to backend
                              setState(() {
                                attendanceStatus[studentId] = value!;
                              });
                              return; // 🔒 DO NOT proceed if it's "Select"
                            }

                            setState(() {
                              attendanceStatus[studentId] = value!;
                            });

                            try {
                              final response = await http.post(
                                Uri.parse(
                                  '${ApiService.baseUrl}/attendance/mark/each-classes',
                                ),
                                headers: {'Content-Type': 'application/json'},
                                body: jsonEncode({
                                  'classId': widget.classId,
                                  'studentId': studentId,
                                  'status': value,
                                  'date': DateTime.now().toIso8601String(),
                                }),
                              );

                              if (response.statusCode == 201) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Attendance marked for $fullName',
                                    ),
                                  ),
                                );
                              } else {
                                final errorMsg =
                                    jsonDecode(response.body)['message'] ??
                                    'Failed';
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(' $errorMsg')),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Network error: $e')),
                              );
                              print(e);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _detailBox() {
    return FutureBuilder<AttendanceSummary?>(
      future: apiService.fetchTodaySummary(widget.classId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.fourRotatingDots(
              color: kMainNavSelected,
              size: 50,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("No attendance data found"));
        }

        final summary = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: double.infinity,
            height: 290,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kMainDarkBlue, kMainColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: kMainDarkBlue.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Attendance Summary for ${summary.date}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: kMainWhiteColor,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LottieBuilder.asset(
                        "assets/animations/Animation - 1747422407290.json",
                        width: 100,
                        height: 100,
                      ),
                    ],
                  ),
                  Container(
                    width: 200,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: kMainWhiteColor, width: 3),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Present Students : 0${summary.present}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: kMainWhiteColor,
                            ),
                          ),
                          Text(
                            'Absent Students  : 0${summary.absent}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: kMainWhiteColor,
                            ),
                          ),
                          Text(
                            'Late Students        : 0${summary.late}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: kMainWhiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Please select the attendance status for each student.',
                    style: TextStyle(
                      fontSize: 14,
                      color: kMainWhiteColor.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    // return Padding(
    //   padding: const EdgeInsets.all(10.0),
    //   child: Container(
    //     width: double.infinity,
    //     height: 200,
    //     decoration: BoxDecoration(
    //       gradient: LinearGradient(
    //         colors: [kMainDarkBlue, kMainColor],
    //         begin: Alignment.topLeft,
    //         end: Alignment.bottomRight,
    //       ),
    //       borderRadius: BorderRadius.circular(10.0),
    //       boxShadow: [
    //         BoxShadow(
    //           color: Colors.grey.withOpacity(0.2),
    //           spreadRadius: 2,
    //           blurRadius: 5,
    //           offset: const Offset(0, 3), // changes position of shadow
    //         ),
    //       ],
    //     ),
    //     child: Padding(
    //       padding: const EdgeInsets.all(10.0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               LottieBuilder.asset(
    //                 "assets/animations/Animation - 1747422407290.json",
    //                 width: 80,
    //                 height: 80,
    //               ),
    //             ],
    //           ),
    //           Text(
    //             'Class ID: ${widget.classId}',
    //             style: const TextStyle(
    //               fontSize: 12,
    //               fontWeight: FontWeight.w500,
    //             ),
    //           ),
    //           const SizedBox(height: 8),
    //           const Text(
    //             'Please select the attendance status for each student.',
    //             style: TextStyle(fontSize: 14, color: Colors.grey),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  // Future<void> markAttendance({
  //   required String classId,
  //   required String studentId,
  //   required String status,
  // }) async {
  //   final url = Uri.parse('${ApiService.baseUrl}/attendance/mark/each-classes');

  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({
  //         "classId": classId,
  //         "studentId": studentId,
  //         "status": status,
  //         "date": DateTime.now().toIso8601String(),
  //       }),
  //     );

  //     final data = jsonDecode(response.body);

  //     if (response.statusCode != 201 || data['success'] != true) {
  //       throw Exception(data['message'] ?? 'Unknown error');
  //     }
  //   } catch (e) {
  //     throw Exception("Failed to mark attendance: $e");
  //   }
  // }
}
