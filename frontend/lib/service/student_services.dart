import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentService {
  static Future<void> storeStudentData({
    required String userID, // Must be 'userID' (capital D) to match backend
    required String? profileImage,
    required String? profileImageBase64, //change this to base64 string
    required String gender,
    required int age,
    required String stream,
    required BuildContext context,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("userId", userID);
      await preferences.setString("profileImage", profileImage ?? "");
      await preferences.setString(
        "profileImageBase64",
        profileImageBase64 ?? "", //change this to base64 string
      ); //change this to base64 string
      await preferences.setString("gender", gender);
      await preferences.setInt("age", age);
      await preferences.setString("stream", stream);

      print(userID);
      print(profileImage);
      print(profileImageBase64); //change this to base64 string
      print(gender);
      print(age);
      print(stream);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Student USer Details Stored Successful ")),
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> checkUserName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userId = pref.getString('userId');
    return userId != null;
  }
}
