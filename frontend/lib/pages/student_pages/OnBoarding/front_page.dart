import 'package:flutter/material.dart';
import 'package:frontend/utils/colors.dart';
import 'package:lottie/lottie.dart';

class StudentFontOnBoard extends StatefulWidget {
  final String uname;
  final String stuId;
  const StudentFontOnBoard({
    super.key,
    required this.uname,
    required this.stuId,
  });

  @override
  State<StudentFontOnBoard> createState() => _StudentFontOnBoardState();
}

class _StudentFontOnBoardState extends State<StudentFontOnBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 470,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [kMainColor, kMainDarkBlue],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(380),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome, ${widget.uname}",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: kMainWhiteColor,
                          ),
                        ),
                        Text(
                          "Your ID : ${widget.stuId}",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: kMainWhiteColor,
                          ),
                        ),
                        SizedBox(height: 50),
                        Lottie.asset(
                          "assets/animations/Animation - 1742788156165.json",
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  "Learning is Everything",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Center(
                    child: Text(
                      "Education is the key to knowledge, growth, and success. It helps individuals develop skills, think critically, and achieve their goals. Through learning, people gain new experiences, improve their understanding, and build a better future.",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign:
                          TextAlign
                              .center, // Ensures text is centered within the widget
                    ),
                  ),
                ),
                SizedBox(height: 110),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
