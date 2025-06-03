// import 'package:flutter/material.dart';
// import 'package:frontend/pages/splash_screen.dart';
// import 'package:frontend/pages/student_pages/stu_collect_detiail.dart';
// import 'package:frontend/pages/teacher_pages/teacher_dashboard.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Wrapper extends StatefulWidget {
//   final bool showDashboard;
//   final String userRole; // Add this to determine which dashboard to show

//   const Wrapper({
//     super.key,
//     required this.showDashboard,
//     this.userRole = 'student', // Default to student if not specified
//   });

//   @override
//   State<Wrapper> createState() => _WrapperState();
// }

// class _WrapperState extends State<Wrapper> {
//   String role = "";
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       setState(() {
//         role = prefs.getString('role') ?? "";
//         isLoading = false;
//       });
//       print("Role : ${role}");
//     } catch (e) {
//       print("Error loading student data: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.showDashboard) {
//       // Check the role and return the appropriate dashboard
//       return role == 'student'
//           ? const StudentCollectDetail()
//           : const TeacherDashBoard();
//     } else {
//       // If not showing dashboard, return login page
//       return const SplashScreen();
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:frontend/pages/splash_screen.dart';
import 'package:frontend/pages/student_pages/stu_collect_detiail.dart';
import 'package:frontend/pages/student_pages/student_main_dashboard.dart';

import 'package:frontend/pages/teacher_pages/teacher_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  final bool showDashboard;
  final String userRole;

  const Wrapper({
    super.key,
    required this.showDashboard,
    this.userRole = 'student',
  });

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  String role = '';
  bool isLoading = true;
  bool onboardingComplete = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        role = prefs.getString('role') ?? widget.userRole;
        onboardingComplete = prefs.getBool('onboardingComplete') ?? false;
        isLoading = false;
      });
      print("User role: $role");
      print("Onboarding complete: $onboardingComplete");
    } catch (e) {
      print("Error loading user data: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!widget.showDashboard) {
      return const SplashScreen();
    }

    // Handle student flow
    if (role == 'student') {
      return onboardingComplete
          ? const StudentDashBoard() // Show dashboard if onboarding complete
          : const StudentCollectDetail(); // Show onboarding if not complete
    }
    // Handle teacher flow
    else if (role == 'teacher') {
      return const TeacherDashBoard();
    }
    // Default fallback (shouldn't normally happen)
    else {
      return const SplashScreen();
    }
  }
}
