import 'package:flutter/material.dart';
import 'package:frontend/utils/colors.dart';
import 'package:frontend/widget/student_other_details_text_feild.dart';

class StudentDetailsForm extends StatefulWidget {
  const StudentDetailsForm({super.key});

  @override
  State<StudentDetailsForm> createState() => _StudentDetailsFormState();
}

class _StudentDetailsFormState extends State<StudentDetailsForm> {
  // Controllers
  final TextEditingController _ageController = TextEditingController(
    text: "18",
  );

  // Form state variables
  String _selectedGender = 'Male';
  String _selectedStream = 'O/L';

  // Gender options
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  // Stream options
  final List<String> _streamOptions = [
    'O/L',
    'A/L Science',
    'A/L Commerce',
    'A/L Arts',
    'University',
    'Other',
  ];

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  // Function to handle form submission
  void _submitForm() {
    // Validate age input
    if (_ageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your age'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate age is a number
    int? age = int.tryParse(_ageController.text);
    if (age == null || age <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid age'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Create form data object with only the three required fields
    final Map<String, dynamic> formData = {
      "gender": _selectedGender,
      "age": age,
      "stream": _selectedStream,
    };

    // Show the data
    print("Form data: $formData");

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data saved: ${formData.toString()}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
        backgroundColor: kMainColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gender selection
            const Text(
              "Gender",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedGender,
                  items:
                      _genderOptions.map((String gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Age input
            const Text(
              "Age",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            StudentOtherDetailsTextFeild(
              hintText: "Enter your age",
              controller: _ageController,
            ),

            const SizedBox(height: 20),

            // Stream selection
            const Text(
              "Academic Stream",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedStream,
                  items:
                      _streamOptions.map((String stream) {
                        return DropdownMenuItem<String>(
                          value: stream,
                          child: Text(stream),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedStream = newValue;
                      });
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Submit button
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kMainColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Save Details",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
