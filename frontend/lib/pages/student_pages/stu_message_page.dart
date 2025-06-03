import 'package:flutter/material.dart';
import 'package:frontend/pages/student_pages/agent/agent_page.dart';
import 'package:frontend/utils/colors.dart';
import 'package:lottie/lottie.dart';

class StudentMesssagePage extends StatefulWidget {
  const StudentMesssagePage({super.key});

  @override
  State<StudentMesssagePage> createState() => _StudentMesssagePageState();
}

class _StudentMesssagePageState extends State<StudentMesssagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Student Message Page')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 450,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [kMainColor, kMainDarkBlue]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(400),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  spreadRadius: 5,
                  color: kMainColor,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      "Hey!s I am Your Self Learning Chat Bot",
                      style: TextStyle(
                        color: kMainWhiteColor,
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5),
                    Center(
                      child: LottieBuilder.asset(
                        "assets/animations/Animation - 1748966911579.json",
                        width: 305,
                        height: 305,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 150,
                  child: Text(
                    "A self-learning chatbot uses AI and user feedback to automatically enhance its responses over time, reducing the need for manual adjustments. It relies on machine learning or deep learning to adapt dynamically.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: kMainBlackColor.withOpacity(0.8),
                    ),
                    softWrap: true,
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [kMainColor, kMainDarkBlue]),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 2,
                    blurStyle: BlurStyle.outer,
                    color: kMainColor,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AgentPage()),
                  );
                },
                child: Text(
                  "Go and Self Learning",
                  style: TextStyle(color: kMainWhiteColor, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
