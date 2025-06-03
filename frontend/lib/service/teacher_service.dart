import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherService {
  static Future<void> storeTeacherData({
    required String userID,
    required String? profileImage,
    required String? profileImageBase64,
    required String? gender,
    required int? age,
    required String? qualifications,
    required List<String>? subjects,
    required List<String>? gradesTaught,
    required String? bio,
    required BuildContext context,
  }) async {
    try {
      final preferences = await SharedPreferences.getInstance();

      await preferences.setString("userId", userID);
      await preferences.setString("profileImage", profileImage ?? "");
      await preferences.setString(
        "profileImageBase64",
        profileImageBase64 ?? "",
      );
      await preferences.setString("gender", gender ?? "");
      await preferences.setInt("age", age ?? 0);
      await preferences.setString("qualifications", qualifications ?? "");
      await preferences.setStringList("subjects", subjects ?? []);
      await preferences.setStringList("gradesTaught", gradesTaught ?? []);
      await preferences.setString("bio", bio ?? "");

      print("Stored teacher data locally:");
      print(userID);
      print(profileImage);
      print(profileImageBase64);
      print(gender);
      print(age);
      print(qualifications);
      print(subjects);
      print(gradesTaught);
      print(bio);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Teacher data stored successfully")),
      );
    } catch (e) {
      print("Error saving teacher data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to store teacher data"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
