import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/models/joined_class_model.dart';
import 'package:frontend/pages/student_pages/assingment/single_assignment_page.dart';
import 'package:frontend/pages/student_pages/teachers_classes/future_class_card.dart';
import 'package:frontend/pages/student_pages/teachers_classes/joined_classes_single.dart';
import 'package:frontend/utils/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetStudentAssignment extends StatefulWidget {
  const GetStudentAssignment({super.key});

  @override
  State<GetStudentAssignment> createState() => _GetStudentAssignmentState();
}

class _GetStudentAssignmentState extends State<GetStudentAssignment> {
  String firstName = "";
  String lastName = "";
  String email = "";
  String role = "";
  String studentId = "";
  bool isLoading = true;

  String userID = "";
  String profileImage = "";
  String gender = "";
  int age = 0;
  String stream = "";

  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
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
    } catch (e) {
      print(e);
    }
  }

  Future<void> _loadUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        firstName = prefs.getString('firstName') ?? "";
        lastName = prefs.getString('lastName') ?? "";
        email = prefs.getString('email') ?? "";
        role = prefs.getString('role') ?? "";
        studentId = prefs.getString('userId') ?? "";
        isLoading = false;
      });
    } catch (e) {
      print("Error loading student data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Assignment")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: 700,
              child: FutureBuilder<List<ClassModels>>(
                future: apiService.getJoinedClasses(userID),
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
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          Icon(
                            Icons.class_outlined,
                            color: Colors.black38,
                            size: 80,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "No Joined classes available, You Can Join Classes",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFB0B0B0),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        ClassModels classModel = snapshot.data![index];
                        return Container(
                          width: 150,
                          height: 160,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: kMainWhiteColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                border: Border.all(color: kMainColor, width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Check Your Assignments",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 65,
                                          height: 65,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: kMainColor,
                                              width: 3,
                                            ),
                                            // image: DecorationImage(
                                            //   image: NetworkImage(
                                            //     "${classModel.teacher.profileImageUrl}" ??
                                            //         'https://via.placeholder.com/150',
                                            //   ),
                                            // ),
                                            color: kMainWhiteColor,
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(
                                                  0.3,
                                                ),
                                                spreadRadius: 1,
                                                blurRadius: 5,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                            child: Image.network(
                                              "${classModel.teacher.profileImageUrl}",
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${classModel.className}",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                softWrap: true,
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                "${classModel.teacher.firstName}",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        SizedBox(width: 5),
                                        Container(
                                          width: 80,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                kMainColor,
                                                kMainDarkBlue,
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.topRight,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(
                                                  0.5,
                                                ),
                                                spreadRadius: 1,
                                                blurRadius: 5,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent,
                                              shadowColor: Colors.transparent,

                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () {
                                              // Handle button press
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          SingleAssignmentPage(
                                                            classID:
                                                                classModel.id,
                                                          ),
                                                ),
                                              );
                                            },
                                            child: Center(
                                              child: Text(
                                                "Open",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12,
                                                  color: kMainWhiteColor,
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

                          // child: Padding(
                          //   padding: const EdgeInsets.all(10.0),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           Container(
                          //             width: 80,
                          //             height: 80,
                          //             decoration: BoxDecoration(
                          //               borderRadius: BorderRadius.circular(50),
                          //               color: kMainWhiteColor.withOpacity(0.5),
                          //               border: Border.all(
                          //                 color: kMainWhiteColor,
                          //                 width: 3,
                          //               ),
                          //               boxShadow: [
                          //                 BoxShadow(
                          //                   color: Colors.grey.withOpacity(0.5),
                          //                   spreadRadius: 1,
                          //                   blurRadius: 5,
                          //                   offset: const Offset(0, 2),
                          //                 ),
                          //               ],
                          //             ),
                          //             child: ClipRRect(
                          //               borderRadius: BorderRadius.circular(50),
                          //               child: Image.network(
                          //                 "${classModel.teacher.profileImageUrl}",
                          //                 width: 80,
                          //                 height: 80,
                          //                 fit: BoxFit.cover,
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //       const SizedBox(height: 5),
                          //       Text(
                          //         classModel.className ?? 'N/A',
                          //         style: const TextStyle(
                          //           fontSize: 15,
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //       ),

                          //       SizedBox(height: 8),
                          //       Row(
                          //         mainAxisAlignment:
                          //             MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           Container(
                          //             width: 130,
                          //             height: 30,
                          //             decoration: BoxDecoration(
                          //               gradient: LinearGradient(
                          //                 colors: [kMainColor, kMainDarkBlue],
                          //                 begin: Alignment.topLeft,
                          //                 end: Alignment.topRight,
                          //               ),
                          //               borderRadius: BorderRadius.circular(50),
                          //               boxShadow: [
                          //                 BoxShadow(
                          //                   color: Colors.grey.withOpacity(0.5),
                          //                   spreadRadius: 1,
                          //                   blurRadius: 5,
                          //                   offset: const Offset(0, 2),
                          //                 ),
                          //               ],
                          //             ),
                          //             child: ElevatedButton(
                          //               style: ElevatedButton.styleFrom(
                          //                 backgroundColor: Colors.transparent,
                          //                 shadowColor: Colors.transparent,

                          //                 shape: RoundedRectangleBorder(
                          //                   borderRadius: BorderRadius.circular(
                          //                     10,
                          //                   ),
                          //                 ),
                          //               ),
                          //               onPressed: () {
                          //                 // Handle button press
                          //                 Navigator.push(
                          //                   context,
                          //                   MaterialPageRoute(
                          //                     builder:
                          //                         (context) =>
                          //                             JoinedClassesStudent(
                          //                               classId: classModel.id,
                          //                             ),
                          //                   ),
                          //                 );
                          //               },
                          //               child: Center(
                          //                 child: Text(
                          //                   "Open",
                          //                   style: TextStyle(
                          //                     fontWeight: FontWeight.w700,
                          //                     fontSize: 12,
                          //                     color: kMainWhiteColor,
                          //                   ),
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
