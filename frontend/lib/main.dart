import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:frontend/pages/student_pages/agent/const.dart';
import 'package:frontend/service/user_services.dart';
import 'package:frontend/widget/wrapper.dart';

import 'package:shared_preferences/shared_preferences.dart';

// import 'package:flutter/material.dart';
// import 'package:frontend/service/user_services.dart';
// import 'package:frontend/widget/wrapper.dart';
// import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  Gemini.init(apiKey: GEMINI_API_KEY);
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _checkAuthStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: Text('Error loading app'))),
          );
        }

        final hasUserName = snapshot.data?['hasUserName'] ?? false;
        final userRole = snapshot.data?['userRole'] ?? 'student';

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: "Inter"),
          home: Wrapper(showDashboard: hasUserName, userRole: userRole),
        );
      },
    );
  }

  Future<Map<String, dynamic>> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'hasUserName': await UserServices.checkUserName(),
      'userRole': prefs.getString('role') ?? 'student',
    };
  }
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await SharedPreferences.getInstance();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: UserServices.checkUserName(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const CircularProgressIndicator();
//         } else {
//           bool hasUserName = snapshot.data ?? false;
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             theme: ThemeData(fontFamily: "Inter"),
//             home: Wrapper(showDashboard: hasUserName),
//           );
//         }
//       },
//     );
//   }
// }
