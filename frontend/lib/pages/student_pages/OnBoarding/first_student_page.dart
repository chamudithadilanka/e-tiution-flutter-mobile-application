import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/widget/student_other_details_text_feild.dart';
import 'package:image_picker/image_picker.dart';

class OnBoardStudentFirstPage extends StatefulWidget {
  final String uname;
  final String stuId;

  const OnBoardStudentFirstPage({
    super.key,
    required this.uname,
    required this.stuId,
  });

  @override
  State<OnBoardStudentFirstPage> createState() =>
      _OnBoardStudentFirstPageState();
}

class _OnBoardStudentFirstPageState extends State<OnBoardStudentFirstPage> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _imagePathController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Pre-fill the student ID
    _userIdController.text = widget.stuId;
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _imagePathController.dispose();
    super.dispose();
  }

  // Function to pick image from gallery
  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imagePathController.text = pickedFile.path;
      });
    }
  }

  // Function to take picture from camera
  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imagePathController.text = pickedFile.path;
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [kMainColor, kMainDarkBlue],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(380),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome, ${widget.uname}",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: kMainWhiteColor,
                          ),
                        ),
                        Text(
                          "Your ID : ${widget.stuId}",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: kMainWhiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Fill Your Other Details..",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
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
                                    borderRadius: BorderRadius.circular(75),
                                    border: Border.all(
                                      color: kMainColor,
                                      width: 2,
                                    ),
                                  ),
                                  child:
                                      _imageFile != null
                                          ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
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
                                  onPressed: _showImageSourceActionSheet,
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
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),

                                // User ID field
                                StudentOtherDetailsTextFeild(
                                  hintText: "User ID",
                                  controller: _userIdController,
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
                                      borderRadius: BorderRadius.circular(10),
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
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
