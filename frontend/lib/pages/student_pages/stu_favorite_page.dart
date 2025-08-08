import 'package:flutter/material.dart';

class StudentFavoritePage extends StatefulWidget {
  const StudentFavoritePage({super.key});

  @override
  State<StudentFavoritePage> createState() => _StudentFavoritePageState();
}

class _StudentFavoritePageState extends State<StudentFavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student Favorite Page')),
      body: Center(child: Text('Student Favorite Page')),
    );
  }
}
