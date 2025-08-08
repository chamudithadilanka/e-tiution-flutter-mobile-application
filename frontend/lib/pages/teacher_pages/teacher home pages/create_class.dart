// import 'package:flutter/material.dart';
// import 'package:frontend/api/api_service.dart';
// import 'package:frontend/utils/colors.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class CreateClass extends StatefulWidget {
//   const CreateClass({super.key});

//   @override
//   State<CreateClass> createState() => _CreateClassState();
// }

// class _CreateClassState extends State<CreateClass> {
//   String firstName = "";
//   String lastName = "";
//   String email = "";
//   String role = "";
//   bool isRole = true;
//   bool isLoading = true;

//   String userID = "";
//   String profileImage = "";
//   String gender = "";
//   int age = 0;
//   String qualifications = "";
//   List<String> subjects = [];
//   List<String> gradesTaught = [];
//   String bio = "";
//   String profileImageBase64 = ""; //change this to base64 string
//   int? studentCount;
//   int? studentPresentCount;
//   ApiService apiService = ApiService();

//   @override
//   void initState() {
//     super.initState();
//     _loadTeacherData();
//     _loadUserData();
//   }

//   Future<void> _loadTeacherData() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       setState(() {
//         userID = prefs.getString('userId') ?? '';
//         profileImage = prefs.getString('profileImage') ?? '';
//         gender = prefs.getString('gender') ?? '';
//         age = (prefs.getInt('age') ?? 0);
//         qualifications = prefs.getString('qualifications') ?? '';
//         subjects = prefs.getStringList('subjects') ?? [];
//         gradesTaught = prefs.getStringList('gradesTaught') ?? [];
//         bio = prefs.getString('bio') ?? '';
//       });
//       print(
//         "Teacher Data Loaded: $userID $profileImage $gender $age $qualifications $subjects $gradesTaught $bio",
//       );
//       print(
//         "Profile Image Base64: $profileImageBase64",
//       ); //change this to base64 string
//     } catch (e) {
//       print('Error loading teacher data: $e');
//     }
//   }

//   Future<void> _loadUserData() async {
//     try {
//       SharedPreferences pref = await SharedPreferences.getInstance();
//       setState(() {
//         firstName = pref.getString('firstName') ?? "";
//         lastName = pref.getString('lastName') ?? "";
//         email = pref.getString('email') ?? "";
//         role = pref.getString('role') ?? "";
//         isLoading = false;
//       });
//       print("$role Data Loaded: $firstName $lastName");
//     } catch (e) {
//       print("Error loading teacher data: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Create Class")),

//       body: Padding(
//         padding: const EdgeInsets.all(15),
//         child: Column(
//           children: [
//             Container(
//               width: double.infinity,
//               height: 550,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [kMainColor, kMainDarkBlue],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomLeft,
//                 ),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }import 'dart:convert';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/utils/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateClass extends StatefulWidget {
  const CreateClass({super.key});

  @override
  State<CreateClass> createState() => _CreateClassState();
}

class _CreateClassState extends State<CreateClass> {
  String className = "";
  String description = "";
  String? selectedSubject;
  String? selectedGrade;

  List<String> subjects = [];
  List<String> gradesTaught = [];

  String userID = "";
  bool isLoading = true;
  bool isSubmitting = false;

  final ApiService apiService = ApiService();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? _base64Image;

  @override
  void initState() {
    super.initState();
    _loadTeacherData();
  }

  Future<void> _loadTeacherData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      setState(() {
        userID = prefs.getString('userId') ?? '';
        subjects = prefs.getStringList('subjects') ?? [];
        gradesTaught = prefs.getStringList('gradesTaught') ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Error loading teacher data: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final bytes = await file.readAsBytes();
      final ext = file.path.split('.').last;
      setState(() {
        _imageFile = file;
        _base64Image = 'data:image/$ext;base64,${base64Encode(bytes)}';
      });
    }
  }

  void _submitClass() async {
    if (className.isEmpty || selectedSubject == null || selectedGrade == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final response = await apiService.createClass(
        className: className,
        subject: selectedSubject!,
        grade: selectedGrade!,
        teacherId: userID,
        studentUserIds: [],
        description: description,
        profileImageBase64: _base64Image ?? '',
      );

      if (response['success']) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Class created successfully!")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${response['message']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Create Class")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Create Class")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // LottieBuilder.asset(
              //   "assets/animations/Animation - 1747421617176.json",
              //   width: 150,
              //   height: 150,
              // ),

              /// FORM CARD
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kMainColor, kMainDarkBlue],
                    begin: Alignment.topRight,
                    end: Alignment.topLeft,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      "Create Your Classes",
                      style: TextStyle(
                        color: kMainWhiteColor,
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 30),

                    // CLASS NAME
                    TextField(
                      decoration: _inputDecoration("Class Name"),
                      style: TextStyle(color: Colors.white),
                      onChanged: (val) => setState(() => className = val),
                    ),
                    SizedBox(height: 20),

                    // SUBJECT
                    DropdownButtonFormField<String>(
                      decoration: _inputDecoration("Select Subject"),
                      value: selectedSubject,
                      items:
                          subjects
                              .map(
                                (s) =>
                                    DropdownMenuItem(value: s, child: Text(s)),
                              )
                              .toList(),
                      onChanged: (val) => setState(() => selectedSubject = val),
                    ),
                    SizedBox(height: 20),

                    // GRADE
                    DropdownButtonFormField<String>(
                      decoration: _inputDecoration("Select Grade"),
                      value: selectedGrade,
                      items:
                          gradesTaught
                              .map(
                                (g) =>
                                    DropdownMenuItem(value: g, child: Text(g)),
                              )
                              .toList(),
                      onChanged: (val) => setState(() => selectedGrade = val),
                    ),
                    SizedBox(height: 20),

                    // DESCRIPTION
                    TextField(
                      maxLines: 3,
                      style: TextStyle(color: Colors.white),
                      decoration: _inputDecoration("Class Description"),
                      onChanged: (val) => setState(() => description = val),
                    ),
                    SizedBox(height: 20),

                    // IMAGE PICKER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          icon: Icon(Icons.photo),
                          onPressed: () => _pickImage(ImageSource.gallery),
                          label: Text("Gallery"),
                        ),
                        ElevatedButton.icon(
                          icon: Icon(Icons.camera_alt),
                          onPressed: () => _pickImage(ImageSource.camera),
                          label: Text("Camera"),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),

                    // Image Preview
                    _imageFile != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(_imageFile!, height: 120),
                        )
                        : Text(
                          "No image selected",
                          style: TextStyle(color: Colors.white),
                        ),
                    SizedBox(height: 30),
                  ],
                ),
              ),

              SizedBox(height: 40),

              // SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : _submitClass,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kMainDarkBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      isSubmitting
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                            "Create Class",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: kMainWhiteColor),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: kMainWhiteColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: kMainWhiteColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: kMainWhiteColor),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.3),
    );
  }
}
