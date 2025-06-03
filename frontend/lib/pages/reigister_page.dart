import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/pages/student_pages/stu_collect_detiail.dart';
import 'package:frontend/pages/teacher_pages/teach_collection_detail.dart';
import 'package:frontend/pages/teacher_pages/teacher_dashboard.dart';
import 'package:frontend/service/user_services.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/widget/button_login_Singup.dart';
import 'package:frontend/widget/register_text_feild.dart';

class ReigisterPage extends StatefulWidget {
  const ReigisterPage({super.key});

  @override
  State<ReigisterPage> createState() => _ReigisterPageState();
}

class _ReigisterPageState extends State<ReigisterPage> {
  String selectedRole = "student";
  bool isLoading = false;

  ApiService apiService = ApiService();
  final _formkey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 765,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kMainColor, kMainDarkBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 2),
                    color: Colors.black38,
                    blurRadius: 5,
                  ),
                ],
              ),

              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "SIGN UP",
                        style: TextStyle(
                          fontSize: 30,
                          color: kMainWhiteColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2),
                      Image.asset(
                        "assets/images/659.png",
                        width: 190,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: 400,
                        height: 480,
                        decoration: BoxDecoration(
                          color: kMainWhiteColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 2),
                              color: Colors.black38,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Form(
                            key: _formkey,
                            child: Column(
                              children: [
                                SizedBox(height: 15),
                                TextRegisterFeildBox(
                                  controller: _firstNameController,
                                  hintText: "Enter Your First Name",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please Enter Your First Name";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 15),
                                TextRegisterFeildBox(
                                  controller: _lastNameController,
                                  hintText: "Enter Your Last Name",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please Enter Your Last Name";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 15),
                                TextRegisterFeildBox(
                                  controller: _emailController,
                                  hintText: "Enter Your Email Address",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please Enter Your Email Address";
                                    } else if (!RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                    ).hasMatch(value)) {
                                      return "Please Enter a Valid Email Address";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 15),
                                TextRegisterFeildBox(
                                  controller: _passwordController,
                                  hintText: "Create Your Password",
                                  isPassword: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please Enter Your Password";
                                    } else if (value.length < 6) {
                                      return "Password must be at least 6 characters";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Role : ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    DropdownButton<String>(
                                      value: selectedRole,
                                      items: [
                                        DropdownMenuItem(
                                          value: "student",
                                          child: Text("student"),
                                        ),
                                        DropdownMenuItem(
                                          value: "teacher",
                                          child: Text("teacher"),
                                        ),
                                      ],
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedRole = newValue!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                isLoading
                                    ? CircularProgressIndicator()
                                    : ButtonLoginAndSingup(
                                      buttonName: "SIGN UP",
                                      onPressed: () async {
                                        if (_formkey.currentState!.validate()) {
                                          setState(() {
                                            isLoading = true;
                                          });

                                          // Debug print
                                          print(
                                            "First Name: ${_firstNameController.text}",
                                          );
                                          print(
                                            "Last Name: ${_lastNameController.text}",
                                          );
                                          print(
                                            "Email: ${_emailController.text}",
                                          );
                                          print(
                                            "Password: ${_passwordController.text}",
                                          );
                                          print("Role: $selectedRole");

                                          UserModel newUser = UserModel(
                                            id: "",
                                            firstName:
                                                _firstNameController.text,
                                            lastName: _lastNameController.text,
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                            role: selectedRole,
                                            joinedClasses: [],
                                            isVerified: false,
                                          );

                                          apiService
                                              .addRegister(newUser)
                                              .then((value) async {
                                                // Mark this callback as async
                                                // First update the state without any await calls
                                                setState(() {
                                                  isLoading = false;
                                                  print(
                                                    "======== value =======",
                                                  );
                                                  print("=== API Response ===");
                                                  print("ID: ${value.id}");
                                                  print(
                                                    "First Name: ${value.firstName}",
                                                  );
                                                  print(
                                                    "Last Name: ${value.lastName}",
                                                  );
                                                  print("Role: ${value.role}");

                                                  print("======== =======");
                                                  print(value.email);
                                                });

                                                // Then, outside of setState, call the async method
                                                if (value.id.isEmpty) {
                                                  print(
                                                    "❌ Error: No ID returned from API",
                                                  );
                                                } else {
                                                  await UserServices.storeUserDetails(
                                                    id:
                                                        value
                                                            .id, // Ensure this is passed
                                                    firstName: value.firstName,
                                                    lastName: value.lastName,
                                                    email: value.email,
                                                    password: "",
                                                    role: value.role,
                                                    context: context,
                                                  );
                                                }
                                                // Show success message
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Registration successful!',
                                                    ),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                );

                                                // Show success message
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Registration successful!',
                                                    ),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                );
                                                if (context.mounted) {
                                                  if (value.role == 'student') {
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                StudentCollectDetail(),
                                                      ),
                                                    );
                                                  } else {
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                TeacherCollectionDetail(),
                                                      ),
                                                    );
                                                  }
                                                }
                                              })
                                              .catchError((error) {
                                                setState(() {
                                                  isLoading = false;
                                                });

                                                // Show error message
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Registration failed: $error',
                                                    ),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                                print("Error: $error");
                                              });
                                        }
                                      },
                                    ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Already have an ",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginPage(),
                                          ), // Navigate to Login Page
                                        );
                                      },
                                      child: Text(
                                        "Account?",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: kMainColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 360,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: kMainWhiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: kCardBgColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 1,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      "assets/images/google_720255.png",
                      width: 50,
                      height: 50,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: kCardBgColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 1,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      "assets/images/facebook_5968764.png",
                      width: 50,
                      height: 50,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: kCardBgColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 1,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      "assets/images/apple_731985.png",
                      width: 50,
                      height: 50,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 75,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kMainColor, kMainDarkBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 2),
                    color: Colors.black38,
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
