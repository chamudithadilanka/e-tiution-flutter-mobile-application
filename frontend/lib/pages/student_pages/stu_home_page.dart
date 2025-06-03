// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:frontend/api/api_service.dart';
// import 'package:frontend/pages/login_page.dart';
// import 'package:frontend/pages/student_pages/widget/future_class_card.dart';
// import 'package:frontend/utils/colors.dart';
// import 'package:frontend/widget/student_dashboard/student_home/home_card.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class StudentHomePage extends StatefulWidget {
//   const StudentHomePage({super.key});

//   @override
//   State<StudentHomePage> createState() => _StudentHomePageState();
// }

// class _StudentHomePageState extends State<StudentHomePage> {
//   String firstName = "";
//   String lastName = "";
//   String email = "";
//   String role = "";
//   String studentId = "";
//   bool isLoading = true;

//   String userID = "";
//   String profileImage = "";
//   String gender = "";
//   int age = 0;
//   String stream = "";

//   ApiService apiservice = ApiService();

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//     _loadstudentData();
//   }

//   Future<void> _loadstudentData() async {
//     try {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       setState(() {
//         userID = preferences.getString("userId") ?? "";
//         profileImage = preferences.getString("profileImage") ?? "";
//         gender = preferences.getString("gender") ?? "";
//         age = preferences.getInt("age") ?? 0;
//         stream = preferences.getString("stream") ?? "";
//       });
//       print("Student Data Loaded: $userID $profileImage $gender $age $stream");

//       print(
//         "Profile Image:=========-----------------==================--------- $profileImage",
//       );
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> _loadUserData() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       setState(() {
//         firstName = prefs.getString('firstName') ?? "";
//         lastName = prefs.getString('lastName') ?? "";
//         email = prefs.getString('email') ?? "";
//         role = prefs.getString('role') ?? "";
//         studentId = prefs.getString('userId') ?? ""; // Fixed this line
//         isLoading = false;
//       });
//       print("Student Data Loaded: $firstName $lastName");
//       print("Student ID: $studentId"); // Add this to verify ID is loaded
//     } catch (e) {
//       print("Error loading student data: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   final DateFormat dateFormatter = new DateFormat('EEEE, MMMM');
//   final DateFormat dayFormatter = new DateFormat('dd');
//   final DateFormat TimeFormat = new DateFormat('hh');
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     DateTime now = DateTime.now(); // date time format
//     String formattedDate = dateFormatter.format(now);
//     String formatterDay = dayFormatter.format(now);
//     String formatterHour = TimeFormat.format(now);
//     return Scaffold(
//       key: _scaffoldKey,
//       drawer: Drawer(
//         backgroundColor: kMainWhiteColor,
//         child: ListView(
//           padding: EdgeInsets.zero,

//           children: [
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
//               width: double.infinity,
//               height: 220,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [kMainColor, kMainDarkBlue],
//                   begin: Alignment.topRight,
//                   end: Alignment.topLeft,
//                 ),
//                 borderRadius: BorderRadius.only(
//                   bottomRight: Radius.circular(60),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: kMainColor.withOpacity(0.5),
//                     blurRadius: 5,
//                     offset: Offset(0, 5),
//                   ),
//                 ],
//               ),

//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 15),
//                   Container(
//                     width: 80,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(75),
//                       border: Border.all(color: kMainWhiteColor, width: 4),
//                     ),
//                     child:
//                         profileImage.isNotEmpty
//                             ? ClipRRect(
//                               borderRadius: BorderRadius.circular(75),
//                               child: Image.network(
//                                 ApiService.ip +
//                                     "uploads/$profileImage", // Replace with your API
//                                 width: 50,
//                                 height: 50,
//                                 fit: BoxFit.cover,
//                                 errorBuilder:
//                                     (context, error, stackTrace) => Icon(
//                                       Icons.person,
//                                       size: 30,
//                                       color: Colors.grey[400],
//                                     ),
//                               ),
//                             )
//                             : Icon(
//                               Icons.person,
//                               size: 30,
//                               color: Colors.grey[400],
//                             ),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     "$firstName $lastName",
//                     style: TextStyle(
//                       fontSize: 25,
//                       fontWeight: FontWeight.w700,
//                       color: kMainWhiteColor,
//                     ),
//                   ),

//                   Text(
//                     "Role : $role",
//                     style: TextStyle(
//                       fontSize: 10,
//                       fontWeight: FontWeight.w500,
//                       color: kMainWhiteColor.withOpacity(0.7),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             ListTile(
//               title: Text(
//                 "Menu",
//                 style: TextStyle(
//                   color: kMainBlackColor,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.home, color: kMainBlackColor, size: 25),
//               title: Text("Home", style: TextStyle(color: kMainBlackColor)),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.settings, color: kMainBlackColor, size: 25),
//               title: Text("Settings", style: TextStyle(color: kMainBlackColor)),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.info, color: kMainBlackColor, size: 25),
//               title: Text("About", style: TextStyle(color: kMainBlackColor)),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.logout, color: kMainBlackColor, size: 25),
//               title: Text("Logout", style: TextStyle(color: kMainBlackColor)),

//               onTap: () async {
//                 SharedPreferences prefs = await SharedPreferences.getInstance();
//                 await prefs.clear();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder:
//                         (context) =>
//                             LoginPage(), // Replace with your login page
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Stack(
//         children: [
//           isLoading
//               ? Center(child: CircularProgressIndicator())
//               : SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Container(
//                       width: double.infinity,
//                       height: 350,
//                       decoration:
//                           (int.tryParse(formatterHour) ?? 0) < 18
//                               ? BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: [kMainColor, kMainDarkBlue],
//                                   begin: Alignment.topLeft,
//                                   end: Alignment.topRight,
//                                 ),
//                                 borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(20),
//                                   bottomRight: Radius.circular(20),
//                                 ),
//                               )
//                               : BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     const Color(0xFF001F3F), // Midnight Blue
//                                     const Color(0xFF003366), // Dark Royal Blue
//                                     const Color(
//                                       0xFF004080,
//                                     ), // Deep Ocean Blue// Teal-Blue
//                                   ],
//                                   begin: Alignment.topLeft,
//                                   end: Alignment.topRight,
//                                 ),

//                                 borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(20),
//                                   bottomRight: Radius.circular(20),
//                                 ),
//                               ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 10,
//                         ),
//                         child: SafeArea(
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 8),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     GestureDetector(
//                                       onTap: () {
//                                         _scaffoldKey.currentState?.openDrawer();
//                                       },
//                                       child: Container(
//                                         width: 50,
//                                         height: 50,
//                                         decoration: BoxDecoration(
//                                           color: Colors.grey[200],
//                                           borderRadius: BorderRadius.circular(
//                                             75,
//                                           ),
//                                           border: Border.all(
//                                             color: kMainWhiteColor,
//                                             width: 3,
//                                           ),
//                                         ),
//                                         child:
//                                             profileImage != null &&
//                                                     profileImage.isNotEmpty
//                                                 ? ClipRRect(
//                                                   borderRadius:
//                                                       BorderRadius.circular(75),
//                                                   child: Image.network(
//                                                     ApiService.ip +
//                                                         "uploads/$profileImage",
//                                                     width: 50,
//                                                     height: 50,
//                                                     fit: BoxFit.cover,
//                                                     errorBuilder:
//                                                         (
//                                                           context,
//                                                           error,
//                                                           stackTrace,
//                                                         ) => Icon(
//                                                           Icons.person,
//                                                           size: 30,
//                                                           color:
//                                                               Colors.grey[400],
//                                                         ),
//                                                   ),
//                                                 )
//                                                 : Icon(
//                                                   Icons.person,
//                                                   size: 30,
//                                                   color: Colors.grey[400],
//                                                 ),
//                                       ),
//                                     ),
//                                     SizedBox(width: 15),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           ("$formattedDate  " +
//                                               "$formatterDay"),
//                                           style: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w500,
//                                             color: kMainWhiteColor,
//                                           ),
//                                         ),

//                                         Text(
//                                           "Hello, $firstName",
//                                           style: TextStyle(
//                                             fontSize: 25,
//                                             fontWeight: FontWeight.w700,
//                                             color: kMainWhiteColor,
//                                           ),
//                                         ),
//                                         GestureDetector(
//                                           onTap: () async {
//                                             await Clipboard.setData(
//                                               ClipboardData(text: studentId),
//                                             );
//                                             ScaffoldMessenger.of(
//                                               context,
//                                             ).showSnackBar(
//                                               SnackBar(
//                                                 content: Text(
//                                                   "Student ID copied to clipboard!",
//                                                 ),
//                                                 duration: Duration(seconds: 5),
//                                                 backgroundColor:
//                                                     kMainNavSelected,
//                                               ),
//                                             );
//                                           },
//                                           child: Text(
//                                             "Student ID : $studentId",
//                                             style: TextStyle(
//                                               fontSize: 8,
//                                               fontWeight: FontWeight.w700,
//                                               color: kMainWhiteColor,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(width: 65),
//                                     Icon(
//                                       Icons.notifications,
//                                       color: kMainWhiteColor,
//                                       size: 35,
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 15),
//                                 TextField(
//                                   decoration: InputDecoration(
//                                     hintText: "Search",
//                                     hintStyle: TextStyle(
//                                       color: kMainWhiteColor,
//                                     ),
//                                     prefixIcon: Icon(
//                                       Icons.search,
//                                       color: kMainWhiteColor,
//                                     ),
//                                     filled: true,
//                                     fillColor: kMainWhiteColor.withOpacity(0.3),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                       borderSide: BorderSide(
//                                         color: kMainWhiteColor.withOpacity(0.3),
//                                       ),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                       borderSide: BorderSide(
//                                         color: kMainDarkBlue.withOpacity(0.3),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: 25),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceAround,
//                                   children: [
//                                     Container(
//                                       width: 170,
//                                       height: 120,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10),
//                                         color: kMainWhiteColor.withOpacity(0.3),
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(10.0),
//                                         child: Column(
//                                           children: [
//                                             SizedBox(height: 10),
//                                             Image.asset(
//                                               "assets/images/working.png",
//                                               width: 50,
//                                               height: 50,
//                                               fit: BoxFit.cover,
//                                             ),
//                                             SizedBox(height: 10),
//                                             Text(
//                                               "Attendance : 80%",
//                                               style: TextStyle(
//                                                 fontSize: 15,
//                                                 color: kMainWhiteColor,
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                       width: 170,
//                                       height: 120,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10),
//                                         color: kMainWhiteColor.withOpacity(0.3),
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(10.0),
//                                         child: Column(
//                                           children: [
//                                             SizedBox(height: 10),
//                                             Image.asset(
//                                               "assets/images/study-time.png",
//                                               width: 50,
//                                               height: 50,
//                                               fit: BoxFit.cover,
//                                             ),
//                                             SizedBox(height: 10),
//                                             Text(
//                                               "Results Rate: 80%",
//                                               style: TextStyle(
//                                                 fontSize: 15,
//                                                 color: kMainWhiteColor,
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),

//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 10,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Categories",
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.w700,
//                                   color: kMainBlackColor,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 10),

//                           SizedBox(height: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               StudentHomeCard(
//                                 title: "My QR",
//                                 image: "assets/images/key_13945248.png",
//                               ),
//                               StudentHomeCard(
//                                 title: "Tutorial Video",
//                                 image: "assets/images/video-tutorials.png",
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               StudentHomeCard(
//                                 title: "Home Work",
//                                 image: "assets/images/working.png",
//                               ),
//                               StudentHomeCard(
//                                 title: "Time Table",
//                                 image: "assets/images/study-time.png",
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               StudentHomeCard(
//                                 title: "Exam Resut",
//                                 image: "assets/images/exam.png",
//                               ),
//                               StudentHomeCard(
//                                 title: "Quizes",
//                                 image: "assets/images/quiz_5732173.png",
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/models/class_model.dart';
import 'package:frontend/models/joined_class_model.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/pages/student_pages/teachers_classes/future_class_card.dart';
import 'package:frontend/pages/student_pages/teachers_classes/joined_classes_single.dart';
import 'package:frontend/pages/student_pages/teachers_classes/single_class.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/widget/student_dashboard/student_home/home_card.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
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

  final DateFormat dateFormatter = DateFormat('EEEE, MMMM');
  final DateFormat dayFormatter = DateFormat('dd');
  final DateFormat timeFormat = DateFormat('hh');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = dateFormatter.format(now);
    String formatterDay = dayFormatter.format(now);
    String formatterHour = timeFormat.format(now);

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          if (isLoading)
            Center(
              child: LoadingAnimationWidget.bouncingBall(
                color: kMainNavSelected,
                size: 50,
              ),
            )
          else
            RefreshIndicator(
              color: kMainDarkBlue,
              onRefresh: () async {
                await _loadUserData();
                await _loadStudentData();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeaderSection(
                      formattedDate,
                      formatterDay,
                      formatterHour,
                    ),
                    _buildUpcomingClassesSection(),
                    _buildJoinedClassesSection(),
                    _buildCategoriesSection(),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: kMainWhiteColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
            width: double.infinity,
            height: 220,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kMainColor, kMainDarkBlue],
                begin: Alignment.topRight,
                end: Alignment.topLeft,
              ),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(60),
              ),
              boxShadow: [
                BoxShadow(
                  color: kMainColor.withOpacity(0.5),
                  blurRadius: 5,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(75),
                    border: Border.all(color: kMainWhiteColor, width: 4),
                  ),
                  child:
                      profileImage.isNotEmpty
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(75),
                            child: Image.network(
                              ApiService.ip + "uploads/$profileImage",
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.grey[400],
                                  ),
                            ),
                          )
                          : Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.grey[400],
                          ),
                ),
                const SizedBox(height: 10),
                Text(
                  "$firstName $lastName",
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: kMainWhiteColor,
                  ),
                ),
                Text(
                  "Role : $role",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: kMainWhiteColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text(
              "Menu",
              style: TextStyle(
                color: kMainBlackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.home, color: kMainBlackColor, size: 25),
            title: const Text("Home", style: TextStyle(color: kMainBlackColor)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: kMainBlackColor,
              size: 25,
            ),
            title: const Text(
              "Settings",
              style: TextStyle(color: kMainBlackColor),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info, color: kMainBlackColor, size: 25),
            title: const Text(
              "About",
              style: TextStyle(color: kMainBlackColor),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: kMainBlackColor, size: 25),
            title: const Text(
              "Logout",
              style: TextStyle(color: kMainBlackColor),
            ),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(
    String formattedDate,
    String formatterDay,
    String formatterHour,
  ) {
    return Container(
      width: double.infinity,
      height: 350,
      decoration:
          (int.tryParse(formatterHour) ?? 0) < 18
              ? BoxDecoration(
                gradient: LinearGradient(
                  colors: [kMainColor, kMainDarkBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              )
              : BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF001F3F),
                    const Color(0xFF003366),
                    const Color(0xFF004080),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(75),
                          border: Border.all(color: kMainWhiteColor, width: 3),
                        ),
                        child:
                            profileImage.isNotEmpty
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(75),
                                  child: Image.network(
                                    ApiService.ip + "uploads/$profileImage",
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                          Icons.person,
                                          size: 30,
                                          color: Colors.grey[400],
                                        ),
                                  ),
                                )
                                : Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Colors.grey[400],
                                ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$formattedDate  $formatterDay",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: kMainWhiteColor,
                          ),
                        ),
                        Text(
                          "Hello, $firstName",
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: kMainWhiteColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await Clipboard.setData(
                              ClipboardData(text: studentId),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  "Student ID copied to clipboard!",
                                ),
                                duration: const Duration(seconds: 5),
                                backgroundColor: kMainNavSelected,
                              ),
                            );
                          },
                          child: Text(
                            "Student ID : $studentId",
                            style: const TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: kMainWhiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    MediaQuery.of(context).size.width > 600
                        ? SizedBox(width: 100)
                        : SizedBox(width: 50),
                    const Icon(
                      Icons.notifications,
                      color: kMainWhiteColor,
                      size: 35,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: const TextStyle(color: kMainWhiteColor),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: kMainWhiteColor,
                    ),
                    filled: true,
                    fillColor: kMainWhiteColor.withOpacity(0.3),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: kMainWhiteColor.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: kMainDarkBlue.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 170,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kMainWhiteColor.withOpacity(0.3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Image.asset(
                              "assets/images/working.png",
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Attendance : 80%",
                              style: TextStyle(
                                fontSize: 15,
                                color: kMainWhiteColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 170,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kMainWhiteColor.withOpacity(0.3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Image.asset(
                              "assets/images/study-time.png",
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Results Rate: 80%",
                              style: TextStyle(
                                fontSize: 15,
                                color: kMainWhiteColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Categories",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: kMainBlackColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StudentHomeCard(
                title: "My QR",
                image: "assets/images/key_13945248.png",
              ),
              StudentHomeCard(
                title: "Tutorial Video",
                image: "assets/images/video-tutorials.png",
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StudentHomeCard(
                title: "Home Work",
                image: "assets/images/working.png",
              ),
              StudentHomeCard(
                title: "Time Table",
                image: "assets/images/study-time.png",
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StudentHomeCard(
                title: "Exam Result",
                image: "assets/images/exam.png",
              ),
              StudentHomeCard(
                title: "Quizzes",
                image: "assets/images/quiz_5732173.png",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingClassesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Upcoming Classes",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: kMainBlackColor,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FutureClassStudents(),
                    ),
                  );
                },
                child: const Text(
                  "See All",
                  style: TextStyle(
                    color: kMainColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: FutureBuilder<List<ClassModel>>(
              future: apiService.getClassesByGrade(stream),
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
                  return const Center(child: Text("No classes available"));
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      ClassModel classModel = snapshot.data![index];
                      return Container(
                        width: 150,
                        margin: const EdgeInsets.only(right: 10, bottom: 10),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: kMainWhiteColor.withOpacity(0.5),
                                      border: Border.all(
                                        color: kMainWhiteColor,
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        "${classModel.teacher.profileImageUrl}",
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                classModel.className ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 130,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [kMainColor, kMainDarkBlue],
                                        begin: Alignment.topLeft,
                                        end: Alignment.topRight,
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,

                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        // Handle button press
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => SingleClass(
                                                  classId: classModel.id,
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
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJoinedClassesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Joined Classes",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: kMainBlackColor,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FutureClassStudents(),
                    ),
                  );
                },
                child: const Text(
                  "See All",
                  style: TextStyle(
                    color: kMainColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          SizedBox(
            height: 200,
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
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      ClassModels classModel = snapshot.data![index];
                      return Container(
                        width: 150,
                        margin: const EdgeInsets.only(right: 10, bottom: 10),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: kMainWhiteColor.withOpacity(0.5),
                                      border: Border.all(
                                        color: kMainWhiteColor,
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        "${classModel.teacher.profileImageUrl}",
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                classModel.className ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 130,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [kMainColor, kMainDarkBlue],
                                        begin: Alignment.topLeft,
                                        end: Alignment.topRight,
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,

                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        // Handle button press
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    JoinedClassesStudent(
                                                      classId: classModel.id,
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
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
