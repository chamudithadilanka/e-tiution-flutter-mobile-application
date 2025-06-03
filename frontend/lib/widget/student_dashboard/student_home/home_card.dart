import 'package:flutter/material.dart';

class StudentHomeCard extends StatefulWidget {
  final String title;
  final String image;
  const StudentHomeCard({super.key, required this.title, required this.image});

  @override
  State<StudentHomeCard> createState() => _StudentHomeCardState();
}

class _StudentHomeCardState extends State<StudentHomeCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 195,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
        child: Column(
          children: [
            Image.asset(
              widget.image,
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
      ),
    );
  }
}
