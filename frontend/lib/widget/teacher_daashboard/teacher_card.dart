import 'package:flutter/material.dart';
import 'package:frontend/utils/colors.dart';

class TeacherHomeCards extends StatefulWidget {
  final String photoUrl;
  final String title;

  const TeacherHomeCards({
    super.key,
    required this.photoUrl,
    required this.title,
  });

  @override
  State<TeacherHomeCards> createState() => _TeacherHomeCardsState();
}

class _TeacherHomeCardsState extends State<TeacherHomeCards> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 195,
      decoration: BoxDecoration(
        color: kMainWhiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            widget.photoUrl,

            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
