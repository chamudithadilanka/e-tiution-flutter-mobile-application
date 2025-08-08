import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/models/student_model.dart';
import 'package:frontend/pages/student_pages/OnBoarding/front_page.dart';
import 'package:frontend/pages/student_pages/student_main_dashboard.dart';
import 'package:frontend/service/student_services.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/widget/student_other_details_text_feild.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class StudentCollectDetail extends StatefulWidget {
  const StudentCollectDetail({super.key});

  @override
  State<StudentCollectDetail> createState() => _StudentCollectDetailState();
}

class _StudentCollectDetailState extends State<StudentCollectDetail> {
  ApiService apiService = ApiService();
  final _formkey = GlobalKey<FormState>();

  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _imagePathController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? selectedGender;
  String? selectedStream;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final PageController _controller = PageController();

  String studentname = "";
  String role = "";
  String studentId = "";
  bool isLoading = true;
  bool showDetailPage = false;
  bool studentIdLoaded = false;

  Future<void> _loadUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String loadedStudentId = prefs.getString('userId') ?? "";
      setState(() {
        studentname = prefs.getString('firstName') ?? '';
        role = prefs.getString('role') ?? "";
        studentId = prefs.getString('userId') ?? ""; // Fixed this line
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
    _userIdController.text = studentId; // Set the initial value for user ID
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
                      showDetailPage = index == 2;
                      print(showDetailPage);
                    });
                  },
                  children: [
                    StudentFontOnBoard(stuId: studentId, uname: studentname),

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
                            SizedBox(height: 50),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Container(
                                width: double.infinity,
                                height: 490,
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
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 15),

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
                                        SizedBox(height: 30),

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
                            const SizedBox(height: 50),

                            // Form Section
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Container(
                                width: double.infinity,
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
                                        DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                            labelText: 'Educational Stream',
                                            border: OutlineInputBorder(),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                  vertical: 10,
                                                ),
                                          ),
                                          items:
                                              [
                                                // Primary Levels
                                                'Grade 1',
                                                'Grade 2',
                                                'Grade 3',
                                                'Grade 4',
                                                'Grade 5',
                                                // Upper Primary/Lower Secondary
                                                'Grade 6',
                                                'Grade 7',
                                                'Grade 8',
                                                'Grade 9',
                                                // Ordinary Level
                                                'O/L',
                                                // Advanced Level Streams
                                                'A/L - Physical Science',
                                                'A/L - Biological Science',
                                                'A/L - Commerce',
                                                'A/L - Arts',
                                                'A/L - Technology',
                                                'A/L - Other',
                                              ].map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                          onChanged: (String? newValue) {
                                            // Handle stream selection

                                            setState(() {
                                              selectedStream = newValue;
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select your stream';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 30),

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
                    count: 3,
                    effect: const WormEffect(
                      activeDotColor: kMainColor,
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
                              selectedStream == null ||
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

                            // Create student model with base64 image
                            StudentModel newStudent = StudentModel(
                              userID: _userIdController.text,
                              profileImageBase64: base64Image,
                              profileImage: _imagePathController.text,
                              gender: selectedGender!,
                              age: int.parse(_ageController.text),
                              stream: selectedStream!,
                            );

                            // Register with API
                            final registeredStudent = await apiService
                                .registerStudentDetails(newStudent);

                            // Store locally (using the filename returned from backend)
                            await StudentService.storeStudentData(
                              userID: registeredStudent.userID,
                              profileImage: registeredStudent.profileImage,
                              profileImageBase64: base64Image,
                              gender: registeredStudent.gender,
                              age: registeredStudent.age,
                              stream: registeredStudent.stream,
                              context: context,
                            );

                            // Mark onboarding as complete
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('onboardingComplete', true);
                            await prefs.setString(
                              'profileImage',
                              registeredStudent.profileImage ?? '',
                            );

                            // Navigate to dashboard
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => StudentDashBoard(),
                              ),
                            );
                          } catch (e) {
                            // Handle errors
                            Navigator.of(
                              context,
                            ).pop(); // Remove loading dialog

                            String errorMessage = "Error saving data";
                            if (e is FormatException) {
                              errorMessage = "Please enter a valid age";
                            } else if (e is SocketException) {
                              errorMessage = "No internet connection";
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
