import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/models/student_model.dart';
import 'package:frontend/models/teacher_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/pages/reigister_page.dart';
import 'package:frontend/pages/student_pages/OnBoarding/second_student_page.dart';
import 'package:frontend/pages/student_pages/stu_collect_detiail.dart';
import 'package:frontend/pages/student_pages/student_main_dashboard.dart';
import 'package:frontend/pages/teacher_pages/teacher_dashboard.dart';
import 'package:frontend/service/student_services.dart';
import 'package:frontend/service/teacher_service.dart';
import 'package:frontend/service/user_services.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/widget/button_login_Singup.dart';
import 'package:frontend/widget/login_text_feild.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Future<void> _login() async {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() => _isLoading = true);

  //     try {
  //       final result = await _apiService.login(
  //         _emailController.text.trim(),
  //         _passwordController.text,
  //       );

  //       setState(() => _isLoading = false);

  //       // Debug print the raw response
  //       debugPrint('Raw login response: $result');

  //       if (result["success"] == true) {
  //         // 1. Safely access the nested data
  //         final data = result["data"] as Map<String, dynamic>? ?? {};

  //         // 2. Safely extract user data
  //         final userMap = data["user"] as Map<String, dynamic>?;
  //         if (userMap == null) {
  //           throw Exception("User data missing in response");
  //         }

  //         // 3. Convert to UserModel
  //         final user = UserModel.fromJson(userMap);
  //         final token = data["token"] as String? ?? '';

  //         // 4. Store user and token
  //         await UserServices.storeUserDetails(
  //           id: user.id,
  //           firstName: user.firstName,
  //           lastName: user.lastName,
  //           email: user.email,
  //           password: "",
  //           role: user.role,
  //           context: context,
  //         );
  //         //await SecureStorage.saveToken(token);

  //         debugPrint('Login successful for ${user.email}');

  //         // 5. Navigate based on role
  //         switch (user.role.toLowerCase()) {
  //           case 'teacher':
  //             Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(builder: (context) => TeacherDashBoard()),
  //             );
  //             break;
  //           case 'student':
  //             Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(builder: (context) => StudentDashBoard()),
  //             );
  //             break;
  //           default:
  //             Navigator.pushReplacementNamed(context, '/home');
  //         }
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text(result["message"] ?? "Login failed"),
  //             backgroundColor: Colors.red,
  //           ),
  //         );
  //       }
  //     } catch (e) {
  //       setState(() => _isLoading = false);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text("Login error: ${e.toString()}"),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //       debugPrint("Full error details: $e");
  //     }
  //   }
  // }

  // Future<void> _login() async {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() => _isLoading = true);

  //     try {
  //       // 1. Perform login
  //       final result = await _apiService.login(
  //         _emailController.text.trim(),
  //         _passwordController.text,
  //       );

  //       debugPrint('Raw login response: $result');

  //       if (result["success"] != true) {
  //         throw Exception(result["message"] ?? "Login failed");
  //       }

  //       // 2. Parse user data
  //       final data = result["data"] as Map<String, dynamic>? ?? {};
  //       final userMap = data["user"] as Map<String, dynamic>? ?? {};
  //       final user = UserModel.fromJson(userMap);
  //       final studentDetail = StudentModel(
  //         userID: userMap["id"],
  //         profileImage: userMap["profileImage"],
  //         gender: userMap["gender"],
  //         age: userMap["age"],
  //         stream: userMap["stream"],
  //       );
  //       final token = data["token"] as String? ?? '';

  //       // 3. Store basic user details
  //       await UserServices.storeUserDetails(
  //         id: user.id,
  //         firstName: user.firstName,
  //         lastName: user.lastName,
  //         email: user.email,
  //         password: "",
  //         role: user.role,
  //         context: context,
  //       );

  //       // Store locally
  //       await StudentService.storeStudentData(
  //         userID: studentDetail.userID,
  //         profileImage: studentDetail.profileImage,
  //         profileImageBase64: studentDetail.profileImageBase64,
  //         gender: studentDetail.gender,
  //         age: studentDetail.age,
  //         stream: studentDetail.stream,
  //         context: context,
  //       );

  //       debugPrint('Login successful for ${user.email}');

  //       // 4. Handle student-specific flow
  //       if (user.role.toLowerCase() == 'student') {
  //         await _handleStudentFlow(user.id);
  //       }

  //       // 5. Navigate based on role
  //       _navigateBasedOnRole(user.role.toLowerCase());
  //     } catch (e) {
  //       setState(() => _isLoading = false);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text("Login error: ${e.toString()}"),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //       debugPrint("Login error details: $e");
  //     } finally {
  //       if (mounted) {
  //         setState(() => _isLoading = false);
  //       }
  //     }
  //   }
  // }

  // Future<void> _handleStudentFlow(String userId) async {
  //   try {
  //     setState(() => _isLoading = true);

  //     // 1. Fetch student details
  //     final student = await _apiService.getStudentDetails(userId);

  //     // 2. Store student data locally
  //     await StudentService.storeStudentData(
  //       userID: student.userID,
  //       profileImage: student.profileImage,
  //       profileImageBase64: student.profileImageBase64,
  //       gender: student.gender,
  //       age: student.age,
  //       stream: student.stream,
  //       context: context,
  //     );

  //     // 3. Check onboarding status
  //     final prefs = await SharedPreferences.getInstance();
  //     final onboardingComplete = prefs.getBool('onboardingComplete') ?? false;

  //     if (!onboardingComplete || student.profileImage == null) {
  //       if (mounted) {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => StudentCollectDetail()),
  //         );
  //       }
  //       return;
  //     }

  //     // Continue to dashboard or home screen if needed
  //     // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentDashboard()));
  //   } catch (e) {
  //     debugPrint("Student flow error: $e");

  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text("Couldn't load full profile details"),
  //           action: SnackBarAction(
  //             label: "Complete Profile",
  //             onPressed: () {
  //               Navigator.pushReplacement(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => StudentCollectDetail(),
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //       );
  //     }
  //   } finally {
  //     if (mounted) {
  //       setState(() => _isLoading = false);
  //     }
  //   }
  // }

  // void _navigateBasedOnRole(String role) {
  //   switch (role) {
  //     case 'teacher':
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => TeacherDashBoard()),
  //       );
  //       break;
  //     case 'student':
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => StudentDashBoard()),
  //       );
  //       break;
  //     default:
  //       Navigator.pushReplacementNamed(context, '/home');
  //   }
  // }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 1. Perform login
      final result = await _apiService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      debugPrint('Raw login response: $result');

      if (result["success"] != true) {
        throw Exception(result["message"] ?? "Login failed");
      }

      // 2. Parse and validate response data
      final data = result["data"] as Map<String, dynamic>? ?? {};
      final token = data["token"] as String? ?? '';
      if (token.isEmpty) throw Exception("No authentication token received");

      final userMap = data["user"] as Map<String, dynamic>?;
      if (userMap == null) throw Exception("No user data in response");

      // 3. Create models
      final user = UserModel.fromJson(userMap);
      debugPrint('Login successful for ${user.email}');

      // 4. Store basic user details
      await UserServices.storeUserDetails(
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        password: "", // Don't store password
        role: user.role,
        context: context,
      );

      // 5. Store student data if role is student
      if (user.role.toLowerCase() == 'student') {
        final studentDetail = StudentModel(
          userID: userMap["id"],
          profileImage: userMap["profileImage"],
          gender: userMap["gender"],
          age: userMap["age"],
          stream: userMap["stream"],
        );

        await StudentService.storeStudentData(
          userID: studentDetail.userID,
          profileImage: studentDetail.profileImage,
          profileImageBase64: studentDetail.profileImageBase64,
          gender: studentDetail.gender,
          age: studentDetail.age,
          stream: studentDetail.stream,
          context: context,
        );
      } else if (user.role.toLowerCase() == 'teacher') {
        final teacherDetail = TeacherModel(
          userID: userMap["id"],
          profileImage: userMap["profileImage"],
          gender: userMap["gender"],
          age: userMap["age"],
          qualifications: userMap["qualifications"],
          subjects: List<String>.from(userMap["subjects"] ?? []),
          gradesTaught: List<String>.from(userMap["gradesTaught"] ?? []),
          bio: userMap["bio"],
        );
        await TeacherService.storeTeacherData(
          userID: teacherDetail.userID,
          profileImage: teacherDetail.profileImage,
          profileImageBase64: teacherDetail.profileImageBase64,
          gender: teacherDetail.gender,
          age: teacherDetail.age,
          qualifications: teacherDetail.qualifications,
          subjects: teacherDetail.subjects,
          gradesTaught: teacherDetail.gradesTaught,
          bio: teacherDetail.bio,
          context: context,
        );
      }

      // 6. Mark onboarding as complete (since we're skipping it)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboardingComplete', true);

      // 7. Navigate directly to appropriate dashboard
      _navigateBasedOnRole(user.role.toLowerCase());
    } catch (e) {
      debugPrint("Login error details: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Login error: ${e.toString().replaceAll('Exception: ', '')}",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Simplified role-based navigation
  void _navigateBasedOnRole(String role) {
    if (!mounted) return;

    switch (role.toLowerCase()) {
      case 'teacher':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TeacherDashBoard()),
        );
        break;
      case 'student':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StudentDashBoard()),
        );
        break;
      default:
        Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 765,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kMainColor, kMainDarkBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 2),
                    color: Colors.black38,
                    blurRadius: 5,
                  ),
                ],
              ),

              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      SizedBox(height: 25),
                      Text(
                        "SIGN IN",
                        style: TextStyle(
                          fontSize: 30,
                          color: kMainWhiteColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Image.asset(
                        "assets/images/10323952.png",
                        width: 260,
                        height: 260,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 45),
                      Container(
                        width: 400,
                        height: 330,
                        decoration: BoxDecoration(
                          color: kMainWhiteColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 2),
                              color: Colors.black38,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                SizedBox(height: 30),
                                TextLoginFeildBox(
                                  hintText: "Enter Your Email Address",
                                  controller: _emailController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                    ).hasMatch(value)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 25),
                                TextLoginFeildBox(
                                  hintText: "Enter Your Password",
                                  controller: _passwordController,
                                  isPassword: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 25),
                                ButtonLoginAndSingup(
                                  buttonName:
                                      _isLoading ? "LOGGING IN..." : "SIGN IN",
                                  onPressed: _isLoading ? null : _login,
                                ),
                                SizedBox(height: 25),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Are you not already ",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => ReigisterPage(),
                                          ), // Navigate to Login Page
                                        );
                                      },
                                      child: Text(
                                        "Register ? ",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: kMainColor,
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
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              width: 360,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: kMainWhiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: kCardBgColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 1,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      "assets/images/google_720255.png",
                      width: 50,
                      height: 50,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: kCardBgColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 1,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      "assets/images/facebook_5968764.png",
                      width: 50,
                      height: 50,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: kCardBgColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 1,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      "assets/images/apple_731985.png",
                      width: 50,
                      height: 50,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kMainColor, kMainDarkBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 2),
                    color: Colors.black38,
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
