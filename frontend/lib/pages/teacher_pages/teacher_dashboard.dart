import 'package:flutter/material.dart';
import 'package:frontend/pages/student_pages/stu_message_page.dart';
import 'package:frontend/pages/teacher_pages/teach_favorite_page.dart';
import 'package:frontend/pages/teacher_pages/teach_home_page.dart';
import 'package:frontend/pages/teacher_pages/teach_profile_page.dart';
import 'package:frontend/pages/teacher_pages/teach_qr_page.dart';
import 'package:frontend/pages/teacher_pages/teach_stu_detail_page.dart';
import 'package:frontend/pages/teacher_pages/teacher%20home%20pages/teacher_classes_list.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherDashBoard extends StatefulWidget {
  const TeacherDashBoard({Key? key}) : super(key: key);

  @override
  State<TeacherDashBoard> createState() => _TeacherDashBoardState();
}

class _TeacherDashBoardState extends State<TeacherDashBoard> {
  @override
  void initState() {
    super.initState();
  }

  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      TeacherHomePage(),
      TeacherClassesList(),
      TeacherQrPage(),
      TeacherFavoritePage(),
      TeacherProfilePage(),
    ];
    return Scaffold(
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: Colors.white,
      //   selectedItemColor: Colors.blue,
      //   unselectedItemColor: Colors.grey,
      //   currentIndex: currentPageIndex,
      //   onTap: (index) {
      //     setState(() {
      //       currentPageIndex = index;
      //     });
      //   },
      //   selectedLabelStyle: TextStyle(
      //     fontWeight: FontWeight.w600,
      //     fontSize: 12,
      //   ),
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //     BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorite"),
      //     BottomNavigationBarItem(icon: Icon(Icons.message), label: "Messages"),
      //     BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: "QR Code"),
      //   ],

      // ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: currentPageIndex,
        onTap: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: "ClassList",
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Icon(Icons.qr_code, color: Colors.white, size: 30),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_outlined),
            label: "favorites",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: "Profile",
          ),
        ],
      ),
      body: pages[currentPageIndex],
    );
  }
}
