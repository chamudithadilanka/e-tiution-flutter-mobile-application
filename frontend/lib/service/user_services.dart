import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices {
  //method to store the user name and user emal in shared pref

  static Future<void> storeUserDetails({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String role,
    required BuildContext context,
  }) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('userId', id);
      await pref.setString('firstName', firstName);
      await pref.setString('lastName', lastName);
      await pref.setString('email', email);
      await pref.setString('password', password);
      await pref.setString('role', role);

      print('📌 Stored User Details:');
      print('ID: $id');
      print('Name: $firstName $lastName');
      print('Email: $email');
      print('Role: $role');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("USer Details Stored Successful ")),
      );
    } catch (error) {
      error.toString();
    }
  }

  static Future<bool> checkUserName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userName = pref.getString('firstName');
    return userName != null;
  }
}
