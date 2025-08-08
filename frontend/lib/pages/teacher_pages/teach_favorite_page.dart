import 'package:flutter/material.dart';

class TeacherFavoritePage extends StatefulWidget {
  const TeacherFavoritePage({super.key});

  @override
  State<TeacherFavoritePage> createState() => _TeacherFavoritePageState();
}

class _TeacherFavoritePageState extends State<TeacherFavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teacher Favorite')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Teacher Favorite Page"),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}
