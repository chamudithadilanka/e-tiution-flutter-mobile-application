import 'package:flutter/material.dart';
import 'package:frontend/pages/student_pages/stu_favorite_page.dart';
import 'package:frontend/pages/student_pages/stu_home_page.dart';
import 'package:frontend/pages/student_pages/stu_message_page.dart';
import 'package:frontend/pages/student_pages/stu_profile_page.dart';
import 'package:frontend/pages/student_pages/stu_qr_page.dart';
import 'package:frontend/utils/colors.dart';

class StudentDashBoard extends StatefulWidget {
  const StudentDashBoard({Key? key}) : super(key: key);

  @override
  State<StudentDashBoard> createState() => _StudentDashBoardState();
}

class _StudentDashBoardState extends State<StudentDashBoard> {
  //current page index
  int _currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      StudentHomePage(),
      StudentMesssagePage(),
      StudentQrCodePage(),
      StudentFavoritePage(),
      StudentProfilePage(),
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: kMainWhiteColor,
        selectedItemColor: kMainNavSelected,
        unselectedItemColor: ksubtitleColor,
        currentIndex: _currentPageIndex,
        onTap:
            (index) => {
              setState(() {
                _currentPageIndex = index;
                print(_currentPageIndex);
              }),
            },
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.bolt_sharp, size: 30),
            label: "ChatBot",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kMainNavSelected,
                  boxShadow: [
                    BoxShadow(
                      color: kMainNavSelected.withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: Icon(Icons.qr_code, color: kMainWhiteColor, size: 30),
              ),
            ),
            label: "",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_outlined),
            label: "Favorite",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      body: pages[_currentPageIndex],
    );
  }
}
