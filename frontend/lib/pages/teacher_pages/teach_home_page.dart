import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/pages/teacher_pages/assignmentResultPages/assignment_result_page.dart';
import 'package:frontend/pages/teacher_pages/teacher%20home%20pages/create_assignment.dart';
import 'package:frontend/pages/teacher_pages/teacher%20home%20pages/create_class.dart';
import 'package:frontend/pages/teacher_pages/student%20attendance/student_attendance.dart';
import 'package:frontend/pages/teacher_pages/teacher%20home%20pages/teacher_classes_list.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/widget/teacher_daashboard/teacher_card.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({super.key});

  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
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

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadTeacherData();
    fetchStudentCount();
    fetchStudentAttendancePresentCount();
  }

  Future<void> fetchStudentAttendancePresentCount() async {
    final presntCount = await apiService.getTodayPresentCount();
    print(presntCount);
    setState(() {
      studentPresentCount = presntCount;
      isLoading = false;
    });
    print(studentPresentCount);
  }

  Future<void> fetchStudentCount() async {
    final count = await apiService.getStudentCount();
    print(count);
    print(studentCount);
    setState(() {
      studentCount = count;
      isLoading = false;
    });
    // OK
    print(studentCount);
  }

  ApiService apiService = ApiService();

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

  Future<void> _loadUserData() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      setState(() {
        firstName = pref.getString('firstName') ?? "";
        lastName = pref.getString('lastName') ?? "";
        email = pref.getString('email') ?? "";
        role = pref.getString('role') ?? "";
        isLoading = false;
      });
      print("$role Data Loaded: $firstName $lastName");
    } catch (e) {
      print("Error loading teacher data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  final DateFormat dateFormatter = new DateFormat('EEEE, MMMM');
  final DateFormat dayFormatter = new DateFormat('dd');
  final DateFormat TimeFormat = new DateFormat('hh');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now(); // date time format
    String formattedDate = dateFormatter.format(now);
    String formatterDay = dayFormatter.format(now);
    String formatterHour = TimeFormat.format(now);

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: kMainWhiteColor,
        child: ListView(
          padding: EdgeInsets.zero,

          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
              width: double.infinity,
              height: 270,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kMainColor, kMainDarkBlue],
                  begin: Alignment.topRight,
                  end: Alignment.topLeft,
                ),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(60),
                ),
                boxShadow: [
                  BoxShadow(
                    color: kMainColor.withOpacity(0.5),
                    blurRadius: 5,
                    offset: Offset(0, 5),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(75),
                      border: Border.all(color: kMainWhiteColor, width: 4),
                    ),
                    child:
                    // profileImage.isNotEmpty
                    ClipRRect(
                      borderRadius: BorderRadius.circular(75),
                      child: Image.network(
                        "$profileImage", // Replace with your API

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
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "$firstName $lastName",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: kMainWhiteColor,
                    ),
                  ),

                  Text(
                    "$email",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: kMainWhiteColor.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Role: " + "$role",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: kMainWhiteColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(
                "Menu Bar",
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
              leading: Icon(Icons.home, color: kMainBlackColor, size: 25),
              title: Text("Home", style: TextStyle(color: kMainBlackColor)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: kMainBlackColor, size: 25),
              title: Text("Settings", style: TextStyle(color: kMainBlackColor)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: kMainBlackColor, size: 25),
              title: Text("About", style: TextStyle(color: kMainBlackColor)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: kMainBlackColor, size: 25),
              title: Text("Logout", style: TextStyle(color: kMainBlackColor)),

              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            LoginPage(), // Replace with your login page
                  ),
                );
              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 350,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [kMainColor, kMainDarkBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15),
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
                                    border: Border.all(
                                      color: kMainWhiteColor,
                                      width: 3,
                                    ),
                                  ),
                                  child:
                                      profileImage.isNotEmpty
                                          ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              75,
                                            ),
                                            child: Image.network(
                                              "$profileImage", // Replace with your API
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Icon(
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
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ("$formattedDate  " + "$formatterDay"),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: kMainWhiteColor,
                                    ),
                                  ),

                                  Text(
                                    "Hello, $firstName",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                      color: kMainWhiteColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 50),
                              Icon(
                                Icons.notifications,
                                color: kMainWhiteColor,
                                size: 30,
                              ),
                            ],
                          ),
                          SizedBox(height: 30),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  color: kMainWhiteColor.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: kMainWhiteColor,
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: kMainWhiteColor.withOpacity(0.10),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Image.asset(
                                        "assets/images/student_count.png",
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Total Students: ${studentCount ?? 0}",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: kMainWhiteColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Today Total Attendance: ${studentPresentCount ?? 0}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: kMainWhiteColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  color: kMainWhiteColor.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: kMainWhiteColor,
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: kMainWhiteColor.withOpacity(0.10),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Image.asset(
                                        "assets/images/student_count.png",
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Total Students: ${studentCount ?? 0}",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: kMainWhiteColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Total Students: ${studentCount ?? 0}",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: kMainWhiteColor,
                                          fontWeight: FontWeight.w600,
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
              ],
            ),

            SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Catogoreis",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  StudentAttendenceMarkPage(), // Automatically gets a back button
                        ),
                      );
                    },
                    child: TeacherHomeCards(
                      photoUrl: "assets/images/assign_13271548.png",
                      title: "Student Attendance",
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateAssignment(),
                        ),
                      );
                    },
                    child: TeacherHomeCards(
                      photoUrl: "assets/images/add-document_11222885.png",
                      title: "Create Assignments",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreateClass()),
                      );
                    },
                    child: TeacherHomeCards(
                      photoUrl: "assets/images/add-button_2572372.png",
                      title: "Create Class",
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssingmentResulPages(),
                        ),
                      );
                    },
                    child: TeacherHomeCards(
                      photoUrl: "assets/images/working.png",
                      title: "Results",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeacherClassesList(),
                        ),
                      );
                    },
                    child: TeacherHomeCards(
                      photoUrl: "assets/images/friendlist_4743122.png",
                      title: "My Classes List",
                    ),
                  ),
                  TeacherHomeCards(
                    photoUrl: "assets/images/working.png",
                    title: "Students",
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
