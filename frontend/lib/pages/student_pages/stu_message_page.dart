import 'package:flutter/material.dart';
import 'package:frontend/pages/student_pages/agent/agent_page.dart';
import 'package:frontend/utils/colors.dart';

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
            height: 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [kMainColor, kMainDarkBlue]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hey, I am Your AI Assistence",
                      style: TextStyle(
                        color: kMainWhiteColor,
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text("Description"),
          SizedBox(height: 50),
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
