import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/models/student_model.dart';
import 'package:frontend/models/teacher_model.dart';
import 'package:frontend/pages/student_pages/OnBoarding/front_page.dart';
import 'package:frontend/pages/student_pages/student_main_dashboard.dart';
import 'package:frontend/pages/teacher_pages/OnBoarding/front_page.dart';
import 'package:frontend/pages/teacher_pages/teacher_dashboard.dart';
import 'package:frontend/service/student_services.dart';
import 'package:frontend/service/teacher_service.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/widget/student_other_details_text_feild.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TeacherCollectionDetail extends StatefulWidget {
  const TeacherCollectionDetail({super.key});

  @override
  State<TeacherCollectionDetail> createState() =>
      _TeacherCollectionDetailState();
}

class _TeacherCollectionDetailState extends State<TeacherCollectionDetail> {
  ApiService apiService = ApiService();
  final _formkey = GlobalKey<FormState>();

  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _imagePathController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _qualificationsController =
      TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  String? selectedGender;
  String? selectedStream;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final PageController _controller = PageController();

  String teachername = "";
  String role = "";
  String teacherId = "";
  bool isLoading = true;
  bool showDetailPage = false;
  bool studentIdLoaded = false;
  List<String> selectedSubjects = [];
  List<String> selectedGrades = [];

  final List<String> subjectOptions = [
    'Mathematics',
    'Science',
    'English',
    'Sinhala',
    'History',
    'Geography',
    'ICT',
    'Business Studies',
    'Accounting',
    'Art',
    'Music',
    'Drama',
    'Dance',
    'Health',
    'Physical Education',
  ];

  final List<String> gradeOptions = [
    'Grade 1',
    'Grade 2',
    'Grade 3',
    'Grade 4',
    'Grade 5',
    'Grade 6',
    'Grade 7',
    'Grade 8',
    'Grade 9',
    'Grade 10',
    'Grade 11',
    'Grade 12',
    'Grade 13',
    'O/L',
    'A/L',
    'A/L - Arts',
  ];
  void _toggleSubject(String subject) {
    setState(() {
      if (selectedSubjects.contains(subject)) {
        selectedSubjects.remove(subject);
      } else {
        selectedSubjects.add(subject);
      }
    });
  }

  void _toggleGrade(String grade) {
    setState(() {
      if (selectedGrades.contains(grade)) {
        selectedGrades.remove(grade);
      } else {
        selectedGrades.add(grade);
      }
    });
  }

  Future<void> _loadUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String loadedStudentId = prefs.getString('userId') ?? "";
      setState(() {
        teachername = prefs.getString('firstName') ?? '';
        role = prefs.getString('role') ?? "";
        teacherId = prefs.getString('userId') ?? ""; // Fixed this line
        isLoading = false;
      });

      _userIdController.text = loadedStudentId;

      print("Student ID loaded: $loadedStudentId");
    } catch (e) {
      print("Error loading student data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _userIdController.text = teacherId; // Set the initial value for user ID
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _imagePathController.dispose();
    _ageController.dispose();
    selectedGender = null;
    selectedStream = null;
    super.dispose();
  }

  Future<String?> _convertImageToBase64(File? imageFile) async {
    if (imageFile == null) return null;
    final bytes = await imageFile.readAsBytes();
    return base64Encode(bytes);
  }
  //=====

  // Future<void> _pickImageFromGallery() async {
  //   final XFile? pickedFile = await _picker.pickImage(
  //     source: ImageSource.gallery,
  //     imageQuality: 80,
  //   );

  //   if (pickedFile != null) {
  //     setState(() {
  //       _imageFile = File(pickedFile.path);
  //       _imagePathController.text = pickedFile.path;
  //     });
  //   }
  // }

  // // Function to take picture from camera
  // Future<void> _pickImageFromCamera() async {
  //   final XFile? pickedFile = await _picker.pickImage(
  //     source: ImageSource.camera,
  //     imageQuality: 80,
  //   );

  //   if (pickedFile != null) {
  //     setState(() {
  //       _imageFile = File(pickedFile.path);
  //       _imagePathController.text = pickedFile.path;
  //     });
  //   }
  // }

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final base64Image = await _convertImageToBase64(file);

      setState(() {
        _imageFile = file;
        _imagePathController.text = base64Image ?? '';
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final base64Image = await _convertImageToBase64(file);

      setState(() {
        _imageFile = file;
        _imagePathController.text = base64Image ?? '';
      });
    }
  }

  // Function to show image source options
  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library, color: kMainColor),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: kMainColor),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                PageView(
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() {
                      showDetailPage = index == 3;
                      print(showDetailPage);
                    });
                  },
                  children: [
                    TeacherFontOnBoard(
                      uname: "$teachername",
                      stuId: "$teacherId",
                    ),

                    SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [kMainColor, kMainDarkBlue],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(1080),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 35),
                                    Text(
                                      "Enter your Other details..",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w500,
                                        color: kMainWhiteColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Container(
                                width: double.infinity,
                                height: 600,
                                decoration: BoxDecoration(
                                  color: kMainWhiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: kMainColor.withOpacity(0.4),
                                      spreadRadius: 5,
                                      blurRadius: 5,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 15,
                                  ),
                                  child: Form(
                                    child: Column(
                                      children: [
                                        // Profile Image Section
                                        Text(
                                          "Profile Image",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 20),

                                        // Image Preview
                                        Container(
                                          width: 150,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(
                                              75,
                                            ),
                                            border: Border.all(
                                              color: kMainColor,
                                              width: 2,
                                            ),
                                          ),
                                          child:
                                              _imageFile != null
                                                  ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          75,
                                                        ),
                                                    child: Image.file(
                                                      _imageFile!,
                                                      width: 150,
                                                      height: 150,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                  : Icon(
                                                    Icons.person,
                                                    size: 80,
                                                    color: Colors.grey[400],
                                                  ),
                                        ),
                                        SizedBox(height: 20),

                                        // Image Selection Button
                                        ElevatedButton.icon(
                                          onPressed:
                                              _showImageSourceActionSheet,
                                          icon: Icon(
                                            Icons.add_a_photo,
                                            color: kMainWhiteColor,
                                          ),
                                          label: Text(
                                            "Choose Photo",
                                            style: TextStyle(
                                              color: kMainWhiteColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: kMainColor,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 10,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "User ID",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        SizedBox(height: 15),
                                        // User ID field
                                        StudentOtherDetailsTextFeild(
                                          hintText: "User ID",
                                          controller: _userIdController,
                                          readOnly: true,
                                        ),
                                        SizedBox(height: 10),

                                        // Hidden field for image path
                                        Visibility(
                                          visible: false,
                                          child: StudentOtherDetailsTextFeild(
                                            hintText: "Profile Image Path",
                                            controller: _imagePathController,
                                          ),
                                        ),
                                        SizedBox(height: 10),

                                        // Submit Button
                                        ElevatedButton(
                                          onPressed: () {
                                            // Handle form submission
                                            if (_imageFile != null) {
                                              // TODO: Implement form submission
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Profile updated successfully!',
                                                  ),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Please select a profile image',
                                                  ),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: kMainColor,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 40,
                                              vertical: 15,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Text(
                                            "Save Profile",
                                            style: TextStyle(
                                              color: kMainWhiteColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: [
                            // Header Section
                            Container(
                              width: double.infinity,
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [kMainColor, kMainDarkBlue],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(1080),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 35),
                                    Text(
                                      "Enter your Other details..",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w500,
                                        color: kMainWhiteColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Form Section
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Container(
                                width: double.infinity,
                                height: 600,
                                decoration: BoxDecoration(
                                  color: kMainWhiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: kMainColor.withOpacity(0.4),
                                      spreadRadius: 5,
                                      blurRadius: 5,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 15,
                                  ),
                                  child: Form(
                                    child: Column(
                                      children: [
                                        // Form Title
                                        Text(
                                          "Fill Educational Details",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 20),

                                        // Gender Selection
                                        DropdownButtonFormField<String>(
                                          value: selectedGender,
                                          decoration: InputDecoration(
                                            labelText: 'Gender',
                                            border: OutlineInputBorder(),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                  vertical: 10,
                                                ),
                                          ),
                                          items:
                                              ['Male', 'Female', 'Other'].map((
                                                String value,
                                              ) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedGender = newValue;
                                            });
                                            // Handle gender selection
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select gender';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 20),

                                        StudentOtherDetailsTextFeild(
                                          hintText: "Age",
                                          controller: _ageController,
                                        ),

                                        // Age Input
                                        const SizedBox(height: 20),

                                        // Educational Stream Selection
                                        StudentOtherDetailsTextFeild(
                                          hintText: "Qualifications",
                                          controller: _qualificationsController,
                                        ),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Select Subjects",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Wrap(
                                          spacing: 5,
                                          runSpacing: 5,
                                          children:
                                              subjectOptions.map((subject) {
                                                return FilterChip(
                                                  label: Text(subject),
                                                  selected: selectedSubjects
                                                      .contains(subject),
                                                  onSelected: (bool selected) {
                                                    _toggleSubject(subject);
                                                  },
                                                );
                                              }).toList(),
                                        ),

                                        // Submit Button
                                        // ElevatedButton(
                                        //   onPressed: () async {
                                        //     // Validate inputs first
                                        //     if (selectedGender == null ||
                                        //         selectedStream == null) {
                                        //       ScaffoldMessenger.of(
                                        //         context,
                                        //       ).showSnackBar(
                                        //         SnackBar(
                                        //           content: Text(
                                        //             "Please select gender and stream",
                                        //           ),
                                        //         ),
                                        //       );
                                        //       return;
                                        //     }

                                        //     try {
                                        //       // Create student model with correct field names
                                        //       StudentModel
                                        //       newStudent = StudentModel(
                                        //         userID: _userIdController.text,
                                        //         profileImage:
                                        //             _imagePathController.text,
                                        //         gender: selectedGender!,
                                        //         age: int.parse(
                                        //           _ageController.text,
                                        //         ),
                                        //         stream: selectedStream!,
                                        //       );

                                        //       // Debug print
                                        //       print("===================");
                                        //       print(
                                        //         json.encode(
                                        //           newStudent.toJson(),
                                        //         ),
                                        //       );
                                        //       print("===================");

                                        //       // Register student
                                        //       final registeredStudent =
                                        //           await apiService
                                        //               .registerStudentDetails(
                                        //                 newStudent,
                                        //               );

                                        //       // Success handling
                                        //       print(
                                        //         "Student registered successfully!",
                                        //       );
                                        //       print(
                                        //         "Student ID: ${registeredStudent.userID}",
                                        //       );
                                        //       print(
                                        //         "Profile Image: ${registeredStudent.profileImage}",
                                        //       );
                                        //       // Then, outside of setState, call the async method
                                        //       if (registeredStudent
                                        //           .userID
                                        //           .isEmpty) {
                                        //         print(
                                        //           "❌ Error: No ID returned from API",
                                        //         );
                                        //       } else {
                                        //         await StudentService.storeStudentData(
                                        //           userID:
                                        //               registeredStudent.userID,
                                        //           profileImage:
                                        //               registeredStudent
                                        //                   .profileImage,
                                        //           gender:
                                        //               registeredStudent.gender,
                                        //           age: registeredStudent.age,
                                        //           stream:
                                        //               registeredStudent.stream,
                                        //           context: context,
                                        //         );
                                        //       }
                                        //       // Show success message
                                        //       ScaffoldMessenger.of(
                                        //         context,
                                        //       ).showSnackBar(
                                        //         SnackBar(
                                        //           content: Text(
                                        //             "Registration successful!.Touch Start to continue",
                                        //           ),
                                        //           backgroundColor: Colors.green,
                                        //         ),
                                        //       );

                                        //       // Navigate or clear form
                                        //       // Navigator.pop(context);
                                        //     } on FormatException {
                                        //       ScaffoldMessenger.of(
                                        //         context,
                                        //       ).showSnackBar(
                                        //         SnackBar(
                                        //           content: Text(
                                        //             "Please enter a valid age",
                                        //           ),
                                        //         ),
                                        //       );
                                        //     } catch (e) {
                                        //       print("Registration failed: $e");
                                        //       ScaffoldMessenger.of(
                                        //         context,
                                        //       ).showSnackBar(
                                        //         SnackBar(
                                        //           content: Text(
                                        //             "Registration failed: ${e.toString()}",
                                        //           ),
                                        //         ),
                                        //       );
                                        //     }
                                        //   },
                                        //   style: ElevatedButton.styleFrom(
                                        //     backgroundColor: kMainColor,
                                        //     padding: EdgeInsets.symmetric(
                                        //       horizontal: 40,
                                        //       vertical: 15,
                                        //     ),
                                        //     shape: RoundedRectangleBorder(
                                        //       borderRadius:
                                        //           BorderRadius.circular(10),
                                        //     ),
                                        //   ),
                                        //   child: Text(
                                        //     "Submit Details",
                                        //     style: TextStyle(
                                        //       color: kMainWhiteColor,
                                        //       fontSize: 16,
                                        //       fontWeight: FontWeight.bold,
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //---------------------------------------onboarding page 3
                    SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: [
                            // Header Section
                            Container(
                              width: double.infinity,
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [kMainColor, kMainDarkBlue],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(1080),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 35),
                                    Text(
                                      "Enter your Other details..",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w500,
                                        color: kMainWhiteColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Form Section
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Container(
                                width: double.infinity,
                                height: 600,
                                decoration: BoxDecoration(
                                  color: kMainWhiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: kMainColor.withOpacity(0.4),
                                      spreadRadius: 5,
                                      blurRadius: 5,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 15,
                                  ),
                                  child: Form(
                                    child: Column(
                                      children: [
                                        // Form Title
                                        Text(
                                          "Fill Educational Details",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 20),

                                        SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Select Grade",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children:
                                              gradeOptions.map((grade) {
                                                return FilterChip(
                                                  label: Text(grade),
                                                  selected: selectedGrades
                                                      .contains(grade),
                                                  onSelected: (bool selected) {
                                                    _toggleGrade(grade);
                                                  },
                                                );
                                              }).toList(),
                                        ),
                                        const SizedBox(height: 30),
                                        StudentOtherDetailsTextFeild(
                                          hintText: "Bio",
                                          controller: _bioController,
                                        ),

                                        // Submit Button
                                        // ElevatedButton(
                                        //   onPressed: () async {
                                        //     // Validate inputs first
                                        //     if (selectedGender == null ||
                                        //         selectedStream == null) {
                                        //       ScaffoldMessenger.of(
                                        //         context,
                                        //       ).showSnackBar(
                                        //         SnackBar(
                                        //           content: Text(
                                        //             "Please select gender and stream",
                                        //           ),
                                        //         ),
                                        //       );
                                        //       return;
                                        //     }

                                        //     try {
                                        //       // Create student model with correct field names
                                        //       StudentModel
                                        //       newStudent = StudentModel(
                                        //         userID: _userIdController.text,
                                        //         profileImage:
                                        //             _imagePathController.text,
                                        //         gender: selectedGender!,
                                        //         age: int.parse(
                                        //           _ageController.text,
                                        //         ),
                                        //         stream: selectedStream!,
                                        //       );

                                        //       // Debug print
                                        //       print("===================");
                                        //       print(
                                        //         json.encode(
                                        //           newStudent.toJson(),
                                        //         ),
                                        //       );
                                        //       print("===================");

                                        //       // Register student
                                        //       final registeredStudent =
                                        //           await apiService
                                        //               .registerStudentDetails(
                                        //                 newStudent,
                                        //               );

                                        //       // Success handling
                                        //       print(
                                        //         "Student registered successfully!",
                                        //       );
                                        //       print(
                                        //         "Student ID: ${registeredStudent.userID}",
                                        //       );
                                        //       print(
                                        //         "Profile Image: ${registeredStudent.profileImage}",
                                        //       );
                                        //       // Then, outside of setState, call the async method
                                        //       if (registeredStudent
                                        //           .userID
                                        //           .isEmpty) {
                                        //         print(
                                        //           "❌ Error: No ID returned from API",
                                        //         );
                                        //       } else {
                                        //         await StudentService.storeStudentData(
                                        //           userID:
                                        //               registeredStudent.userID,
                                        //           profileImage:
                                        //               registeredStudent
                                        //                   .profileImage,
                                        //           gender:
                                        //               registeredStudent.gender,
                                        //           age: registeredStudent.age,
                                        //           stream:
                                        //               registeredStudent.stream,
                                        //           context: context,
                                        //         );
                                        //       }
                                        //       // Show success message
                                        //       ScaffoldMessenger.of(
                                        //         context,
                                        //       ).showSnackBar(
                                        //         SnackBar(
                                        //           content: Text(
                                        //             "Registration successful!.Touch Start to continue",
                                        //           ),
                                        //           backgroundColor: Colors.green,
                                        //         ),
                                        //       );

                                        //       // Navigate or clear form
                                        //       // Navigator.pop(context);
                                        //     } on FormatException {
                                        //       ScaffoldMessenger.of(
                                        //         context,
                                        //       ).showSnackBar(
                                        //         SnackBar(
                                        //           content: Text(
                                        //             "Please enter a valid age",
                                        //           ),
                                        //         ),
                                        //       );
                                        //     } catch (e) {
                                        //       print("Registration failed: $e");
                                        //       ScaffoldMessenger.of(
                                        //         context,
                                        //       ).showSnackBar(
                                        //         SnackBar(
                                        //           content: Text(
                                        //             "Registration failed: ${e.toString()}",
                                        //           ),
                                        //         ),
                                        //       );
                                        //     }
                                        //   },
                                        //   style: ElevatedButton.styleFrom(
                                        //     backgroundColor: kMainColor,
                                        //     padding: EdgeInsets.symmetric(
                                        //       horizontal: 40,
                                        //       vertical: 15,
                                        //     ),
                                        //     shape: RoundedRectangleBorder(
                                        //       borderRadius:
                                        //           BorderRadius.circular(10),
                                        //     ),
                                        //   ),
                                        //   child: Text(
                                        //     "Submit Details",
                                        //     style: TextStyle(
                                        //       color: kMainWhiteColor,
                                        //       fontSize: 16,
                                        //       fontWeight: FontWeight.bold,
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // page doted indicator
                Container(
                  alignment: Alignment(0, 0.68),
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: 4,
                    effect: const WormEffect(
                      activeDotColor: kMainNavSelected,
                      dotColor: ksubtitleColor,
                    ),
                  ),
                ),

                // Positioned(
                //   bottom: 70,
                //   left: 0,
                //   right: 0,
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 40),

                //     child: GestureDetector(
                //       onTap: () {
                //         _controller.animateToPage(
                //           _controller.page!.toInt() + 1,
                //           duration: Duration(milliseconds: 400),
                //           curve: Curves.easeInOut,
                //         );
                //       },
                //       child: Container(
                //         width: 250,
                //         height: 50,
                //         decoration: BoxDecoration(
                //           color: kMainNavSelected,
                //           borderRadius: BorderRadius.circular(50),
                //         ),
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Row(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 showDetailPage
                //                     ? GestureDetector(
                //                       onTap: () {
                //                         Navigator.pushReplacement(
                //                           context,
                //                           MaterialPageRoute(
                //                             builder:
                //                                 (context) => StudentDashBoard(),
                //                           ),
                //                         );
                //                       },
                //                       child: Text(
                //                         "Get Started",
                //                         style: TextStyle(
                //                           fontSize: 25,
                //                           fontWeight: FontWeight.w600,
                //                           color: kMainWhiteColor,
                //                         ),
                //                         textAlign: TextAlign.center,
                //                       ),
                //                     )
                //                     : Text(
                //                       "Next",
                //                       style: TextStyle(
                //                         fontSize: 25,
                //                         fontWeight: FontWeight.w600,
                //                         color: kMainWhiteColor,
                //                       ),
                //                       textAlign: TextAlign.center,
                //                     ),
                //               ],
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // In your StudentCollectDetail class...
                //================================================================== change 2 possioned
                // Positioned(
                //   bottom: 70,
                //   left: 0,
                //   right: 0,
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 40),
                //     child: GestureDetector(
                //       onTap: () async {
                //         if (showDetailPage) {
                //           // This is the "Get Started" button state

                //           // First validate all required fields are filled
                //           if (_imageFile == null) {
                //             ScaffoldMessenger.of(context).showSnackBar(
                //               SnackBar(
                //                 content: Text("Please upload a profile image"),
                //               ),
                //             );
                //             return;
                //           }

                //           if (selectedGender == null ||
                //               selectedStream == null ||
                //               _ageController.text.isEmpty) {
                //             ScaffoldMessenger.of(context).showSnackBar(
                //               SnackBar(
                //                 content: Text("Please complete all details"),
                //               ),
                //             );
                //             return;
                //           }

                //           try {
                //             // Show loading indicator
                //             showDialog(
                //               context: context,
                //               barrierDismissible: false,
                //               builder:
                //                   (context) => Center(
                //                     child: CircularProgressIndicator(),
                //                   ),
                //             );

                //             // Create and save student data
                //             StudentModel newStudent = StudentModel(
                //               userID: _userIdController.text,
                //               profileImage: _imagePathController.text,
                //               gender: selectedGender!,
                //               age: int.parse(_ageController.text),
                //               stream: selectedStream!,
                //             );

                //             // Register with API
                //             final registeredStudent = await apiService
                //                 .registerStudentDetails(newStudent);

                //             // Store locally
                //             await StudentService.storeStudentData(
                //               userID: registeredStudent.userID,
                //               profileImage: registeredStudent.profileImage,
                //               gender: registeredStudent.gender,
                //               age: registeredStudent.age,
                //               stream: registeredStudent.stream,
                //               context: context,
                //             );

                //             // Mark onboarding as complete
                //             final prefs = await SharedPreferences.getInstance();
                //             await prefs.setBool('onboardingComplete', true);

                //             // Navigate to dashboard
                //             Navigator.of(context).pushReplacement(
                //               MaterialPageRoute(
                //                 builder: (context) => StudentDashBoard(),
                //               ),
                //             );
                //           } catch (e) {
                //             Navigator.of(
                //               context,
                //             ).pop(); // Remove loading dialog
                //             ScaffoldMessenger.of(context).showSnackBar(
                //               SnackBar(
                //                 content: Text(
                //                   "Error saving data: ${e.toString()}",
                //                 ),
                //               ),
                //             );
                //           }
                //         } else {
                //           // This is the "Next" button state
                //           _controller.nextPage(
                //             duration: Duration(milliseconds: 400),
                //             curve: Curves.easeInOut,
                //           );
                //         }
                //       },
                //       child: Container(
                //         width: 250,
                //         height: 50,
                //         decoration: BoxDecoration(
                //           color: kMainNavSelected,
                //           borderRadius: BorderRadius.circular(50),
                //         ),
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Row(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 Text(
                //                   showDetailPage ? "Get Started" : "Next",
                //                   style: TextStyle(
                //                     fontSize: 25,
                //                     fontWeight: FontWeight.w600,
                //                     color: kMainWhiteColor,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                //================================================================== change 3 possioned
                Positioned(
                  bottom: 70,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: GestureDetector(
                      onTap: () async {
                        if (showDetailPage) {
                          // Validate all required fields
                          if (_imageFile == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Please upload a profile image"),
                              ),
                            );
                            return;
                          }

                          if (selectedGender == null ||
                              _ageController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Please complete all details"),
                              ),
                            );
                            return;
                          }

                          try {
                            // Show loading indicator
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder:
                                  (context) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                            );

                            // Convert image to base64
                            final bytes = await _imageFile!.readAsBytes();
                            final base64Image =
                                "data:image/${_imageFile!.path.split('.').last};base64,${base64Encode(bytes)}";

                            // Create teacher model
                            TeacherModel newTeacher = TeacherModel(
                              userID: _userIdController.text,
                              profileImageBase64: base64Image,
                              profileImage: _imagePathController.text,
                              gender: selectedGender!,
                              age: int.parse(_ageController.text),
                              qualifications: _qualificationsController.text,
                              subjects: selectedSubjects,
                              gradesTaught: selectedGrades,
                              bio: _bioController.text,
                            );

                            // Debug prints (remove in production)
                            debugPrint("Teacher data: ${newTeacher.toJson()}");

                            // Register with API
                            final response = await apiService
                                .registerTeacherDetails(newTeacher.toJson());

                            if (response == null ||
                                response['profileImageUrl'] == null) {
                              throw Exception("Invalid API response");
                            }

                            final registeredTeacher = TeacherModel(
                              userID: newTeacher.userID,
                              profileImage: response['profileImageUrl'],
                              profileImageBase64: newTeacher.profileImageBase64,
                              gender: newTeacher.gender,
                              age: newTeacher.age,
                              qualifications: newTeacher.qualifications,
                              subjects: newTeacher.subjects,
                              gradesTaught: newTeacher.gradesTaught,
                              bio: newTeacher.bio,
                            );

                            await TeacherService.storeTeacherData(
                              userID: registeredTeacher.userID,
                              profileImage: registeredTeacher.profileImage,
                              profileImageBase64:
                                  registeredTeacher.profileImageBase64,
                              gender: registeredTeacher.gender,
                              age: registeredTeacher.age,
                              qualifications: registeredTeacher.qualifications,
                              subjects: registeredTeacher.subjects,
                              gradesTaught: registeredTeacher.gradesTaught,
                              bio: registeredTeacher.bio,
                              context: context,
                            );

                            // Mark onboarding as complete
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('onboardingComplete', true);
                            await prefs.setString(
                              'profileImage',
                              registeredTeacher.profileImage ?? '',
                            );

                            // Navigate to dashboard
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => TeacherDashBoard(),
                              ),
                            );
                          } catch (e, stackTrace) {
                            // Remove loading dialog
                            Navigator.of(context).pop();

                            // Improved error handling
                            String errorMessage;
                            if (e is FormatException) {
                              errorMessage = "Please enter a valid age";
                            } else if (e is SocketException) {
                              errorMessage = "No internet connection";
                            } else if (e is HttpException) {
                              errorMessage = "Server error: ${e.message}";
                            } else {
                              errorMessage =
                                  "Error saving data: ${e.toString()}";
                              debugPrint("Full error: $e\n$stackTrace");
                              print("Error: $e\nStackTrace: $stackTrace");
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(errorMessage),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } else {
                          // "Next" button logic
                          _controller.nextPage(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Container(
                        width: 250,
                        height: 50,
                        decoration: BoxDecoration(
                          color: kMainNavSelected,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            showDetailPage ? "Get Started" : "Next",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: kMainWhiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
