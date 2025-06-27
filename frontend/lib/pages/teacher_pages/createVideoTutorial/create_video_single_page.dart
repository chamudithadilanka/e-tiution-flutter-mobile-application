import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateVideoTutorialSinglePage extends StatefulWidget {
  final String classId;
  const CreateVideoTutorialSinglePage({super.key, required this.classId});

  @override
  State<CreateVideoTutorialSinglePage> createState() =>
      _CreateVideoTutorialSinglePageState();
}

class _CreateVideoTutorialSinglePageState
    extends State<CreateVideoTutorialSinglePage> {
  String title = "";
  String videoId = "";
  String description = "";
  String thumbnailUrl = "";

  String userID = "";
  bool isLoading = true;
  bool _isSubmitting = false;

  ApiService apiService = ApiService();

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

        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Error loading teacher data: $e');
    }
  }

  void submitted() async {
    if (title.isEmpty || videoId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all required fields."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final videos = [
        {
          "title": title,
          "videoId": videoId,
          "description": description,
          "thumbnailUrl": thumbnailUrl,
          "teacherId": userID,
          "classId": widget.classId, // Assuming a default class ID
        },
      ];

      if (userID.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Teacher ID not found. Please login again."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final response = await apiService.addMultipleVideos(videos: videos);

      if (!response['success']) {
        throw Exception(
          response['message'] ?? "Failed to create video tutorial",
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Video tutorial '$title' created successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        title = "";
        videoId = "";
        description = "";
        thumbnailUrl = "";
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error creating video tutorial: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Video Tutorial")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              _buildInputContainer(),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kMainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                onPressed: _isSubmitting ? null : submitted,
                child:
                    _isSubmitting
                        ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                        : const Text(
                          "Submit Video",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputContainer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kMainDarkBlue, kMainColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildTextField(
            label: "Video Title",
            value: title,
            onChanged: (val) => setState(() => title = val),
          ),
          const SizedBox(height: 15),
          _buildTextField(
            label: "YouTube Video ID",
            value: videoId,
            onChanged: (val) => setState(() => videoId = val),
          ),
          const SizedBox(height: 15),
          _buildTextField(
            label: "Description",
            value: description,
            onChanged: (val) => setState(() => description = val),
          ),
          const SizedBox(height: 15),
          _buildTextField(
            label: "Thumbnail URL",
            value: thumbnailUrl,
            onChanged: (val) => setState(() => thumbnailUrl = val),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(decoration: _inputDecoration(label), onChanged: onChanged);
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: kMainWhiteColor, fontSize: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: kMainWhiteColor, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: kMainWhiteColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: kMainWhiteColor),
      ),
    );
  }
}
