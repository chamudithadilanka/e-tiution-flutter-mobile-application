// import 'dart:convert';
// import 'package:frontend/models/user_model.dart';

// import 'package:http/http.dart' as http;

// class ApiService {
//   // Base URL
//   static const String baseUrl = "http://192.168.198.176:4000/api/v1";

//   // Register user
//   Future<UserModel> addRegister(UserModel register) async {
//     const String url = "$baseUrl/register";
//     print("===================");
//     print(json.encode(register.toJson()));
//     print("===================");

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {"Content-Type": "application/json"},
//         body: json.encode(register.toJson()),
//       );

//       print("Response status code: ${response.statusCode}");

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         print("Response: ${response.body}");
//         UserModel newUser = UserModel.fromJson(json.decode(response.body));
//         return newUser; // ✅ Return UserModel
//       } else {
//         throw Exception(
//           "Failed to register user: ${response.body}",
//         ); // ✅ Handle non-200 responses
//       }
//     } catch (error) {
//       print("Error: $error");
//       throw Exception("Failed to register user"); // ✅ Always throw an exception
//     }
//   }

//   // // Register user
//   // Future<String> userID(UserModel register) async {
//   //   const String url = "$baseUrl/register";
//   //   print("===================");
//   //   print(json.encode(register.toJson())); // Debug print
//   //   print("===================");

//   //   try {
//   //     final response = await http.post(
//   //       Uri.parse(url),
//   //       headers: {"Content-Type": "application/json"},
//   //       body: json.encode(register.toJson()),
//   //     );

//   //     print("Response status code: ${response.statusCode}");

//   //     if (response.statusCode == 200 || response.statusCode == 201) {
//   //       print("Response: ${response.body}");

//   //       // Parse the JSON response
//   //       Map<String, dynamic> responseData = json.decode(response.body);

//   //       // Extract the user ID
//   //       String userId = responseData['user']['id']; // ✅ Fetch user ID

//   //       print("User ID: $userId"); // Debug print

//   //       return userId; // ✅ Return the user ID
//   //     } else {
//   //       throw Exception("Failed to register user: ${response.body}");
//   //     }
//   //   } catch (error) {
//   //     print("Error: $error");
//   //     throw Exception("Failed to register user");
//   //   }
//   // }

//   // Login user
//   Future<Map<String, dynamic>> login(String email, String password) async {
//     const String url = "$baseUrl/login";

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {"Content-Type": "application/json"},
//         body: json.encode({"email": email, "password": password}),
//       );

//       print("Login response status code: ${response.statusCode}");

//       if (response.statusCode == 200) {
//         print("Login response: ${response.body}");
//         Map<String, dynamic> responseData = json.decode(response.body);

//         // Assuming your backend returns user data in the format
//         // {"message": "✅ Login successful", "user": {...}}
//         if (responseData.containsKey("user")) {
//           UserModel loggedInUser = UserModel.fromJson(responseData["user"]);
//           return {
//             "success": true,
//             "message": responseData["message"] ?? "Login successful",
//             "user": loggedInUser,
//           };
//         } else {
//           return {
//             "success": true,
//             "message": responseData["message"] ?? "Login successful",
//           };
//         }
//       } else {
//         Map<String, dynamic> errorData = json.decode(response.body);
//         return {
//           "success": false,
//           "message": errorData["message"] ?? "Login failed",
//         };
//       }
//     } catch (error) {
//       print("Login error: $error");
//       return {"success": false, "message": "Failed to connect to server"};
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/models/assignment_responce.dart';
import 'package:frontend/models/assingment.dart';
import 'package:frontend/models/attendance_day_details_model.dart';
import 'package:frontend/models/class_model.dart';
import 'package:frontend/models/joined_class_model.dart';
import 'package:frontend/models/student_attendance_model.dart';
import 'package:frontend/models/student_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

class ApiService {
  // Base URL
  static const String baseUrl = "http://192.168.13.176:4000/api";
  static const String ip = "http://192.168.13.176:4000/";

  // Register user - Fixed version
  Future<UserModel> addRegister(UserModel register) async {
    const String url = "$baseUrl/v1/register";
    print("===================");
    print(json.encode(register.toJson()));
    print("===================");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(register.toJson()),
      );

      print("Response status code: ${response.statusCode}");
      print("Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);

        // Check if the response has the expected structure
        if (responseData['success'] == true && responseData['data'] != null) {
          // Combine the data from response with the original password
          final userData = responseData['data'] as Map<String, dynamic>;
          final userJson = {
            ...userData,
            'password': register.password, // Preserve the password
          };

          UserModel newUser = UserModel.fromJson(userJson);
          print("Successfully registered user: ${newUser.id}");
          return newUser;
        } else {
          throw Exception("Invalid response format: ${response.body}");
        }
      } else {
        throw Exception("Failed to register user: ${response.body}");
      }
    } catch (error) {
      print("Error: $error");
      throw Exception("Failed to register user: $error");
    }
  }

  // Login user - Improved version
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/v1/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Login failed with status ${response.statusCode}');
    }
  }

  // Future<StudentModel> registerStudentDetails(StudentModel student) async {
  //   const String url = "$baseUrl/students/details";

  //   final headers = {
  //     "Content-Type": "application/json",
  //     // Add if needed: "Authorization": "Bearer $token",
  //   };

  //   // Use the model's toJson() method
  //   final body = student.toJson();

  //   print("Sending to backend: ${json.encode(body)}");

  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: headers,
  //       body: json.encode(body),
  //     );

  //     print("Response status: ${response.statusCode}");
  //     print("Response body: ${response.body}");

  //     if (response.statusCode == 201) {
  //       return StudentModel.fromJson(json.decode(response.body));
  //     } else {
  //       throw Exception("Failed to register student: ${response.body}");
  //     }
  //   } catch (e) {
  //     print("Registration error: $e");
  //     throw Exception("Failed to register student: $e");
  //   }
  // }

  // Future<StudentModel> registerStudentDetails(StudentModel student) async {
  //   const String url =
  //       "$baseUrl/students/details"; // Adjust the endpoint as needed

  //   print("===================");
  //   print(json.encode(student.toJson()));
  //   print("===================");
  //   // Convert to backend-expected format
  //   final requestBody = {
  //     "userID": student.userID, // Note: capital 'D' to match backend
  //     "profileImage": student.profileImage,
  //     "gender": student.gender,
  //     "age": student.age,
  //     "stream": student.stream,
  //   };

  //   print("Sending to backend: ${json.encode(requestBody)}");

  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       body: json.encode(requestBody),
  //     );

  //     if (response.statusCode == 201) {
  //       return StudentModel.fromJson(json.decode(response.body));
  //     } else {
  //       throw Exception("Registration failed: ${response.body}");
  //     }
  //   } catch (e) {
  //     print("Registration error: $e");
  //     throw Exception("Failed to register student details");
  //   }
  // }

  Future<StudentModel> registerStudentDetails(StudentModel student) async {
    const String url = "$baseUrl/students/details";

    final headers = {
      "Content-Type": "application/json",
      // Add if needed: "Authorization": "Bearer $token",
    };

    try {
      // Convert the student model to JSON
      final body = student.toJson();
      print("Sending to backend: ${json.encode(body)}");

      final response = await http
          .post(Uri.parse(url), headers: headers, body: json.encode(body))
          .timeout(const Duration(seconds: 30)); // Add timeout

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        // Handle successful response
        if (responseData['data'] != null) {
          return StudentModel.fromJson(responseData['data']);
        } else if (responseData['success'] == true) {
          // Some APIs return data directly without 'data' field
          return StudentModel.fromJson(responseData);
        } else {
          throw Exception("Success status but no student data received");
        }
      } else {
        // Handle error response
        final errorMessage =
            responseData['message'] ??
            "Failed to register student (Status: ${response.statusCode})";
        throw Exception(errorMessage);
      }
    } on FormatException catch (e) {
      print("JSON parsing error: $e");
      throw Exception("Invalid server response format");
    } catch (e) {
      print("Registration error: $e");
      throw Exception("Failed to register student: ${e.toString()}");
    }
  }

  // get single user student data

  // Future<StudentModel> getStudentDetails(String userId) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/students/details/$userId'),
  //       headers: {'Content-Type': 'application/json'},
  //     );

  //     debugPrint(
  //       "Student details response: ${response.statusCode} - ${response.body}",
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       return StudentModel.fromJson(data);
  //     } else {
  //       throw Exception(
  //         'Failed to load student details: ${response.statusCode}',
  //       );
  //     }
  //   } catch (e) {
  //     debugPrint("Error in getStudentDetails: $e");
  //     throw Exception('Network error: ${e.toString()}');
  //   }
  // }

  // API Service Method
  Future<List<ClassModels>> getJoinedClasses(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/students/$userId/joined-classes'),
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint(
        "Joined classes response: ${response.statusCode} - ${response.body}",
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final List<dynamic> classesJson = data['joinedClasses'];
          return classesJson
              .map((json) => ClassModels.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception("Failed to load joined classes");
        }
      } else {
        throw Exception(
          "Failed to load joined classes: ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("Error in getJoinedClasses: $e");
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<StudentModel> getStudentDetails(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/students/details/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint(
        "Student details response: ${response.statusCode} - ${response.body}",
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Important: Access the 'data' field
        final studentData = data['data'];

        return StudentModel.fromJson(studentData);
      } else {
        throw Exception(
          'Failed to load student details: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint("Error in getStudentDetails: $e");
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Future<Map<String, dynamic>> registerTeacherDetails(
  //   Map<String, dynamic> teacherData,
  // ) async {
  //   try {
  //     final url = Uri.parse('$baseUrl/teachers/details');

  //     final response = await http.post(
  //       url,
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(teacherData),
  //     );

  //     if (response.statusCode == 201) {
  //       final responseData = jsonDecode(response.body);
  //       return {
  //         'success': true,
  //         'message': responseData['message'],
  //         'profileImageUrl': responseData['data']['profileImageUrl'],
  //       };
  //     } else {
  //       final errorData = jsonDecode(response.body);
  //       throw Exception(
  //         errorData['error'] ?? 'Failed to create teacher profile',
  //       );
  //     }
  //   } on http.ClientException catch (e) {
  //     throw Exception('Network error: ${e.message}');
  //   } on FormatException {
  //     throw Exception('Invalid server response format');
  //   } catch (e) {
  //     throw Exception('An unexpected error occurred: $e');
  //   }
  // }

  Future<Map<String, dynamic>> registerTeacherDetails(
    Map<String, dynamic> teacherData,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/teachers/details');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(teacherData),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'message': responseData['message'],
          'profileImageUrl': responseData['data']['profileImageUrl'],
        };
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['error'] ?? 'Failed to create teacher profile',
        );
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on FormatException {
      throw Exception('Invalid server response format');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Helper method to add authorization header
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      if (authToken != null) 'Authorization': 'Bearer $authToken',
    };
  }

  final String? authToken;

  ApiService({this.authToken});

  // You might want to add this method to check if the teacher profile already exists
  Future<bool> checkTeacherProfileExists(String userId) async {
    try {
      final url = Uri.parse('$baseUrl/teachers/check/$userId');
      final response = await http.get(url, headers: _getHeaders());

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['exists'];
      } else {
        throw Exception('Failed to check teacher profile');
      }
    } catch (e) {
      throw Exception('Error checking teacher profile: $e');
    }
  }

  // Future<bool> markAttendance(List<Map<String, dynamic>> attendanceList) async {
  //   final url = Uri.parse('$baseUrl/attendance/mark');

  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({'attendance': attendanceList}),
  //     );

  //     if (response.statusCode == 200) {
  //       print('Attendance marked successfully');
  //       return true;
  //     } else {
  //       print('Failed to mark attendance: ${response.body}');
  //       return false;
  //     }
  //   } catch (e) {
  //     print('Error marking attendance: $e');
  //     return false;
  //   }
  // }

  Future<void> markAttendanceList(
    List<Map<String, dynamic>> attendanceList,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/attendance/mark'), // match your backend route
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'attendance': attendanceList}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark attendance');
    }
  }

  Future<List<Student>> fetchAllStudents() async {
    final response = await http.get(Uri.parse('$baseUrl/students/all'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> studentsJson = jsonData['data'];

      return studentsJson.map((json) => Student.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }

  Future<int?> getStudentCount() async {
    final url = Uri.parse("$baseUrl/students/student-count");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['studentCount'];
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }

  Future<int?> getTodayPresentCount() async {
    final url = Uri.parse("$baseUrl/attendance/today-count");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['todayPresentCount'];
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception while fetching today's count: $e");
      return null;
    }
  }

  // //

  // Future<List<Student>> fetchStudentsByStream(String stream) async {
  //   final response = await http.get(
  //     Uri.parse('$baseUrl/students/stream/$stream'),
  //   );

  //   print("Stream: $stream");
  //   print("Status Code: ${response.statusCode}");
  //   print("Response Body: ${response.body}");

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);

  //     // Handle both possible response formats
  //     if (data['students'] is List) {
  //       // If response has 'students' key
  //       return (data['students'] as List)
  //           .map((json) => Student.fromJson(json))
  //           .toList();
  //     } else if (data['data'] != null && data['data'][stream] is List) {
  //       // If response has nested structure with grade as key
  //       return (data['data'][stream] as List)
  //           .map((json) => Student.fromJson(json))
  //           .toList();
  //     } else {
  //       throw Exception(
  //         "Invalid response format: Expected 'students' or 'data.$stream' key",
  //       );
  //     }
  //   } else {
  //     throw Exception(
  //       'Failed to load students by stream: ${response.statusCode}',
  //     );
  //   }
  // }

  // secon ============================

  // Future<Map<String, dynamic>> createClass({
  //   required String className,
  //   required String subject,
  //   required String grade,
  //   required String description,
  //   required String teacherId,
  //   required List<String> studentUserIds,
  //   String? profileImageBase64, // Optional image
  // }) async {
  //   final url = Uri.parse('$baseUrl/class/classes');

  //   try {
  //     // Build request payload
  //     final Map<String, dynamic> requestBody = {
  //       'className': className,
  //       'subject': subject,
  //       'grade': grade,
  //       'description': description,
  //       'teacherId': teacherId,
  //       'studentUserIds': studentUserIds,
  //     };

  //     if (profileImageBase64 != null) {
  //       requestBody['profileImageBase64'] = profileImageBase64;
  //     }

  //     final response = await http.post(
  //       url,
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(requestBody),
  //     );

  //     print('Raw response: ${response.body}'); // Debug output

  //     // Try to decode JSON safely
  //     Map<String, dynamic> jsonData;
  //     try {
  //       jsonData = jsonDecode(response.body);
  //     } catch (e) {
  //       return {
  //         'success': false,
  //         'message': 'Invalid JSON response from server',
  //       };
  //     }

  //     if (response.statusCode == 201) {
  //       return {'success': true, 'data': jsonData['data']};
  //     } else {
  //       return {
  //         'success': false,
  //         'message': jsonData['message'] ?? 'Unknown error',
  //       };
  //     }
  //   } catch (e) {
  //     return {'success': false, 'message': e.toString()};
  //   }
  // }

  Future<Map<String, dynamic>> createClass({
    required String className,
    required String subject,
    required String grade,
    required String teacherId,
    required List<String> studentUserIds,
    required String description,
    String? profileImageBase64, // renamed to be clearer
  }) async {
    try {
      final url = Uri.parse('$baseUrl/class/classes');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'className': className,
          'subject': subject,
          'grade': grade,
          'teacherId': teacherId,
          'studentUserIds': studentUserIds,
          'description': description,
          'profileImageBase64':
              profileImageBase64, // use the correct key your backend expects
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': responseData['message'],
          'data': responseData['data'], // includes class info & profileImageUrl
        };
      } else {
        throw Exception(responseData['error'] ?? 'Failed to create class');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on FormatException {
      throw Exception('Invalid server response format');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
  //==================================getteacher each classes

  // Future<List<dynamic>> getTeacherClasses(String userId) async {
  //   final url = Uri.parse('$baseUrl/classes/user/$userId');

  //   try {
  //     final response = await http.get(url);

  //     if (response.statusCode == 200) {
  //       final body = json.decode(response.body);
  //       return body['data']; // List of classes
  //     } else {
  //       throw Exception(
  //         'Failed to load teacher classes: ${response.statusCode}',
  //       );
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching classes: $e');
  //   }
  // }

  Future<List<ClassModel>> getClassesByTeacherUserId(String userId) async {
    final url = Uri.parse(
      'http://192.168.13.176:4000/api/class/classes/user/$userId',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded['success'] == true) {
          final List<dynamic> data = decoded['data'];
          return data
              .map((classJson) => ClassModel.fromJson(classJson))
              .toList();
        } else {
          throw Exception(decoded['message']);
        }
      } else {
        throw Exception(
          'Failed to load classes. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching classes: $e');
      rethrow;
    }
  }

  Future<List<ClassModel>> getClassesByGrade(String grade) async {
    try {
      // Encode the grade parameter to handle special characters (like "/")
      final encodedGrade = Uri.encodeComponent(grade);
      final url = Uri.parse('$baseUrl/class/classes/grade/$encodedGrade');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return List<ClassModel>.from(
            data['data'].map((x) => ClassModel.fromJson(x)),
          );
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch classes');
        }
      } else {
        throw Exception('Failed to load classes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching classes: $e');
    }
  }

  //========================single class id fecth

  // Future<ClassModel> getClassById(String classId) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/api/class/$classId'),
  //       headers: {'Content-Type': 'application/json'},
  //     );

  //     final jsonResponse = json.decode(response.body);

  //     if (response.statusCode == 200) {
  //       ClassModel classModel = ClassModel.fromJson(json.decode(response.body));
  //       ClassModel.fromJson(jsonResponse['data']);
  //       // Assuming the API returns a single class, not a list
  //       return classModel;
  //     } else if (response.statusCode == 404) {
  //       throw Exception('Class not found');
  //     } else {
  //       throw Exception(jsonResponse['message'] ?? 'Failed to fetch class');
  //     }
  //   } catch (e) {
  //     throw Exception('An error occurred: ${e.toString()}');
  //   }
  // }

  Future<ClassModel> getClassById(String classId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/class/$classId'),
        headers: {'Content-Type': 'application/json'},
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Check if the response has the expected structure
        if (jsonResponse is! Map<String, dynamic>) {
          throw FormatException('Invalid response format - expected Map');
        }

        if (jsonResponse['data'] == null) {
          throw Exception('No data field in response');
        }

        return ClassModel.fromJson(jsonResponse['data']);
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ?? 'Failed to fetch class');
      }
    } on FormatException catch (e) {
      print('JSON Format Error: $e');
      throw Exception('Invalid data format: ${e.message}');
    } catch (e) {
      print('Network Error: $e');
      throw Exception('Failed to load class: ${e.toString()}');
    }
  }

  Future<void> joinClass(String classId, String studentId) async {
    if (studentId.isEmpty) {
      print("Error: studentId is empty");
      return;
    }

    final url = Uri.parse("http://192.168.13.176:4000/api/class/$classId/join");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"studentId": studentId}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success']) {
        print("Joined class successfully");
      } else {
        print("Failed to join: ${data['message']}");
      }
    } catch (e) {
      print("Error joining class: $e");
    }
  }

  // Future<String> markAttendance({
  //   required BuildContext context,
  //   required String classId,
  //   required String studentId,
  //   String status = 'present',
  // }) async {
  //   final url = Uri.parse('$baseUrl/attendance/mark/each-classes');

  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({
  //         "classId": classId,
  //         "studentId": studentId,
  //         "status": status,
  //       }),
  //     );

  //     final data = jsonDecode(response.body);

  //     if (response.statusCode == 201 && data['success'] == true) {
  //       return "success";
  //     } else if (response.statusCode == 409) {
  //       return "already_marked";
  //     } else {
  //       return "error";
  //     }
  //   } catch (e) {
  //     print("🔥 Error marking attendance: $e");
  //     return "error";
  //   }
  // }

  Future<String> markAttendance({
    required BuildContext context,
    required String classId,
    required String studentId,
    String status = 'present',
  }) async {
    final url = Uri.parse(
      'http://192.168.13.176:4000/api/attendance/mark/each-classes',
    );

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "classId": classId,
          "studentId": studentId,
          "status": status,
        }),
      );

      // 🔐 Safely check for JSON before parsing
      if (!response.headers['content-type']!.contains('application/json')) {
        print('❌ Expected JSON, got HTML or other content:');
        print(response.body);
        return "error";
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        return "success";
      } else if (response.statusCode == 409) {
        return "already_marked";
      } else {
        print('⚠️ Unexpected response: ${response.body}');
        return "error";
      }
    } catch (e) {
      print("🔥 Network or decode error: $e");
      return "error";
    }
  }

  Future<ClassModel?> fetchClassByName(String className) async {
    final url = Uri.parse('$baseUrl/by-name/$className');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success']) {
          return ClassModel.fromJson(jsonData['data']);
        } else {
          print('API responded with success: false');
          return null;
        }
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception while fetching class: $e');
      return null;
    }
  }

  Future<List<dynamic>> getStudentsByClassId(String classId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/class/classes/$classId'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['students']; // This must be a List
    } else {
      throw Exception(
        'Failed to load students. Status code: ${response.statusCode}',
      );
    }
  }

  Future<AttendanceSummary?> fetchTodaySummary(String classId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/attendance/details/$classId'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return AttendanceSummary.fromJson(jsonData);
      } else {
        print('Failed to load attendance summary: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching attendance summary: $e');
      return null;
    }
  }

  Future<Assignment?> createAssignment(Assignment assignment) async {
    const String url = "$baseUrl/assignment/create";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(assignment.toJson()),
      );

      print("Response status code: ${response.statusCode}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Response body: ${response.body}");

        final Map<String, dynamic> jsonData = json.decode(response.body);

        return Assignment.fromJson(jsonData['assignment'] ?? jsonData);
      } else {
        print("Error response: ${response.body}");
        throw Exception("Failed to create assignment");
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }

  Future<List<Assignment>> fetchAssignmentsByClassId(String classId) async {
    final url = Uri.parse('$baseUrl/assignment/class/$classId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success']) {
          final List assignmentsJson = data['assignments'];
          return assignmentsJson
              .map((json) => Assignment.fromJson(json))
              .toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch assignments');
        }
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching assignments: $e');
    }
  }

  Future<bool> submitAssignment({
    required String assignmentId,
    required String studentId,
    required String classId,
    String? comments,
    required File file,
  }) async {
    final uri = Uri.parse('$baseUrl/submission/upload');

    var request = http.MultipartRequest('POST', uri);

    // Add file
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: p.basename(file.path),
      ),
    );

    // Add form fields
    request.fields['assignmentId'] = assignmentId;
    request.fields['studentId'] = studentId;
    request.fields['classId'] = classId;
    if (comments != null) {
      request.fields['comments'] = comments;
    }

    try {
      final response = await request.send();

      if (response.statusCode == 201) {
        print('✅ Submission successful');
        return true;
      } else {
        print('❌ Submission failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('🔥 Error submitting assignment: $e');
      return false;
    }
  }
}
