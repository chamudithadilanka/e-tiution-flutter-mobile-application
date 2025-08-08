// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:http/http.dart' as http;
// import 'package:frontend/models/assingment.dart';
// import 'package:frontend/api/api_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// class CreateAssignmentPage extends StatefulWidget {
//   final String classId;

//   const CreateAssignmentPage({super.key, required this.classId});

//   @override
//   State<CreateAssignmentPage> createState() => _CreateAssignmentPageState();
// }

// class _CreateAssignmentPageState extends State<CreateAssignmentPage> {
//   final _formKey = GlobalKey<FormState>();
//   final ApiService _apiService = ApiService();

//   String _assignmentTitle = '';
//   String _description = '';
//   DateTime? _dueDate;
//   List<PlatformFile> _selectedFiles = [];
//   bool _isSubmitting = false;
//   String _userId = '';

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _userId = prefs.getString('userId') ?? '';
//     });
//   }

//   Future<void> _pickFiles() async {
//     try {
//       final status = await Permission.storage.request();
//       if (!status.isGranted) {
//         openAppSettings();
//         return;
//       }

//       final result = await FilePicker.platform.pickFiles(
//         allowMultiple: true,
//         type: FileType.custom,
//         allowedExtensions: [
//           'pdf',
//           'doc',
//           'docx',
//           'ppt',
//           'pptx',
//           'jpg',
//           'jpeg',
//           'png',
//         ],
//       );

//       if (!mounted) return; // 🛡️ Safe check

//       if (result != null && result.files.isNotEmpty) {
//         setState(() {
//           _selectedFiles =
//               result.files.where((f) => f.size < 10 * 1024 * 1024).toList();
//         });
//       }
//     } catch (e) {
//       if (mounted) _showError('Failed to pick files: $e');
//     }
//   }

//   Future<List<AssignmentDocument>> _uploadFiles() async {
//     List<AssignmentDocument> uploaded = [];

//     for (final file in _selectedFiles) {
//       if (file.path == null) continue;

//       try {
//         if (file.size < 5 * 1024 * 1024) {
//           // Base64 upload
//           final bytes = await File(file.path!).readAsBytes();
//           final base64Data = base64Encode(bytes);
//           uploaded.add(
//             AssignmentDocument(
//               name: file.name,
//               data: base64Data,
//               url: '',
//               size: file.size,
//             ),
//           );
//         } else {
//           // Large file upload via multipart
//           final uri = Uri.parse(
//             '${ApiService.baseUrl}/upload',
//           ); // USE SEPARATE ENDPOINT
//           final request = http.MultipartRequest('POST', uri)
//             ..files.add(await http.MultipartFile.fromPath('file', file.path!));

//           final response = await request.send();
//           if (response.statusCode == 200) {
//             final responseBody = await response.stream.bytesToString();
//             final responseData = jsonDecode(responseBody);
//             uploaded.add(
//               AssignmentDocument(
//                 name: file.name,
//                 data: '',
//                 url: responseData['url'],
//                 size: file.size,
//               ),
//             );
//           } else {
//             _showError('Failed to upload file: ${file.name}');
//           }
//         }
//       } catch (e) {
//         _showError('Upload failed: ${file.name} - $e');
//       }
//     }

//     return uploaded;
//   }

//   Future<void> _createAssignment() async {
//     if (!_formKey.currentState!.validate() || _dueDate == null) {
//       _showError('Please fill all required fields');
//       return;
//     }

//     setState(() => _isSubmitting = true);

//     try {
//       final uploadedDocs = await _uploadFiles();

//       final assignment = Assignment(
//         id: '',
//         title: _assignmentTitle,
//         description: _description,
//         dueDate: _dueDate!,
//         classId: widget.classId,
//         teacherId: _userId,
//         materials: uploadedDocs,
//         createdAt: DateTime.now(),
//       );

//       final created = await _apiService.createAssignment(assignment);
//       if (created != null) {
//         _showSuccess('Assignment created successfully');
//         Navigator.pop(context, true);
//       }
//     } catch (e) {
//       _showError('Failed to create assignment: $e');
//     } finally {
//       setState(() => _isSubmitting = false);
//     }
//   }

//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: Colors.red),
//     );
//   }

//   void _showSuccess(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: Colors.green),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Create Assignment')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextFormField(
//                   decoration: const InputDecoration(labelText: 'Title*'),
//                   validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
//                   onChanged: (v) => _assignmentTitle = v,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   decoration: const InputDecoration(labelText: 'Description*'),
//                   maxLines: 3,
//                   validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
//                   onChanged: (v) => _description = v,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   decoration: const InputDecoration(labelText: 'Due Date*'),
//                   readOnly: true,
//                   controller: TextEditingController(
//                     text:
//                         _dueDate != null
//                             ? '${_dueDate!.year}-${_dueDate!.month.toString().padLeft(2, '0')}-${_dueDate!.day.toString().padLeft(2, '0')}'
//                             : '',
//                   ),
//                   onTap: () async {
//                     final date = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime.now(),
//                       lastDate: DateTime.now().add(const Duration(days: 365)),
//                     );
//                     if (date != null) setState(() => _dueDate = date);
//                   },
//                   validator: (v) => _dueDate == null ? 'Required' : null,
//                 ),
//                 const SizedBox(height: 24),
//                 Row(
//                   children: [
//                     ElevatedButton(
//                       onPressed: _pickFiles,
//                       child: const Text('Select Files'),
//                     ),
//                     const SizedBox(width: 16),
//                     Text('${_selectedFiles.length} files selected'),
//                   ],
//                 ),
//                 ..._selectedFiles.map(
//                   (f) => ListTile(
//                     title: Text(f.name),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.delete),
//                       onPressed: () => setState(() => _selectedFiles.remove(f)),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 32),
//                 ElevatedButton(
//                   onPressed: _isSubmitting ? null : _createAssignment,
//                   child:
//                       _isSubmitting
//                           ? const CircularProgressIndicator()
//                           : const Text('Create Assignment'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/models/assingment.dart';
import 'package:frontend/api/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:mime/mime.dart';

class CreateAssignmentPage extends StatefulWidget {
  final String classId;

  const CreateAssignmentPage({super.key, required this.classId});

  @override
  State<CreateAssignmentPage> createState() => _CreateAssignmentPageState();
}

class _CreateAssignmentPageState extends State<CreateAssignmentPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  String _assignmentTitle = '';
  String _description = '';
  DateTime? _dueDate;
  List<PlatformFile> _selectedFiles = [];
  bool _isSubmitting = false;
  String _userId = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId') ?? '';
    });
  }

  Future<void> _pickFiles() async {
    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        await openAppSettings();
        return;
      }

      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'ppt',
          'pptx',
          'jpg',
          'jpeg',
          'png',
        ],
      );

      if (!mounted) return;

      if (result != null && result.files.isNotEmpty) {
        // Filter files that are less than 10MB
        final validFiles =
            result.files.where((f) => f.size < 10 * 1024 * 1024).toList();

        if (validFiles.length != result.files.length) {
          _showError('Some files were too large (>10MB) and were excluded');
        }

        setState(() {
          _selectedFiles = validFiles;
        });
      }
    } catch (e) {
      if (mounted) _showError('Failed to pick files: $e');
    }
  }

  String _getMimeType(String fileName) {
    return lookupMimeType(fileName) ?? 'application/octet-stream';
  }

  Future<List<AssignmentDocument>> _uploadFiles() async {
    List<AssignmentDocument> uploaded = [];

    for (final file in _selectedFiles) {
      if (file.path == null) continue;

      try {
        if (file.size < 5 * 1024 * 1024) {
          // Small file: Upload as base64
          final bytes = await File(file.path!).readAsBytes();
          final mimeType = _getMimeType(file.name);
          final base64Data = base64Encode(bytes);
          final dataUri = 'data:$mimeType;base64,$base64Data';

          uploaded.add(
            AssignmentDocument(
              name: file.name,
              data: dataUri, // Proper data URI format
              url: '',
              size: file.size,
            ),
          );
        } else {
          // Large file: Upload via multipart
          final uri = Uri.parse('${ApiService.baseUrl}/upload');
          final request = http.MultipartRequest('POST', uri);

          // Add authorization header if needed
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');
          if (token != null) {
            request.headers['Authorization'] = 'Bearer $token';
          }

          request.files.add(
            await http.MultipartFile.fromPath('file', file.path!),
          );

          final response = await request.send();
          if (response.statusCode == 200) {
            final responseBody = await response.stream.bytesToString();
            final responseData = jsonDecode(responseBody);
            uploaded.add(
              AssignmentDocument(
                name: file.name,
                data: '', // Empty for URL-based files
                url: responseData['url'] ?? responseData['fileUrl'] ?? '',
                size: file.size,
              ),
            );
          } else {
            final errorBody = await response.stream.bytesToString();
            _showError(
              'Failed to upload file: ${file.name} - Status: ${response.statusCode}',
            );
            print('Upload error: $errorBody');
          }
        }
      } catch (e) {
        _showError('Upload failed: ${file.name} - $e');
        print('Upload exception: $e');
      }
    }

    return uploaded;
  }

  // Future<void> _createAssignment() async {
  //   if (!_formKey.currentState!.validate()) {
  //     _showError('Please fill all required fields');
  //     return;
  //   }

  //   if (_dueDate == null) {
  //     _showError('Please select a due date');
  //     return;
  //   }

  //   setState(() => _isSubmitting = true);

  //   try {
  //     // Upload files first
  //     final uploadedDocs = await _uploadFiles();

  //     print('Uploaded documents: ${uploadedDocs.length}');
  //     for (var doc in uploadedDocs) {
  //       print('Doc: ${doc.name}, Data length: ${doc.data.length}, URL: ${doc.url}');
  //     }

  //     final assignment = Assignment(
  //       id: '',
  //       title: _assignmentTitle,
  //       description: _description,
  //       dueDate: _dueDate!,
  //       classId: widget.classId,
  //       teacherId: _userId,
  //       materials: uploadedDocs,
  //       createdAt: DateTime.now(),
  //     );

  //     print('Assignment payload: ${jsonEncode(assignment.toJson())}');

  //     final created = await _apiService.createAssignment(assignment);
  //     if (created != null) {
  //       _showSuccess('Assignment created successfully');
  //       if (mounted) {
  //         Navigator.pop(context, true);
  //       }
  //     } else {
  //       _showError('Failed to create assignment - No response from server');
  //     }
  //   } catch (e) {
  //     _showError('Failed to create assignment: $e');
  //     print('Create assignment error: $e');
  //   } finally {
  //     if (mounted) {
  //       setState(() => _isSubmitting = false);
  //     }
  //   }
  // }

  Future<void> _createAssignment() async {
    if (!_formKey.currentState!.validate()) {
      _showError('Please fill all required fields');
      return;
    }

    if (_dueDate == null) {
      _showError('Please select a due date');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Upload files first
      final uploadedDocs = await _uploadFiles();

      print('Uploaded documents: ${uploadedDocs.length}');
      for (var doc in uploadedDocs) {
        print(
          'Doc: ${doc.name}, Data length: ${doc.data.length}, URL: ${doc.url}',
        );
      }

      final assignment = Assignment(
        id: '',
        title: _assignmentTitle,
        description: _description,
        dueDate: _dueDate!,
        classId: widget.classId,
        teacherId: _userId,
        materials: uploadedDocs,
        createdAt: DateTime.now(),
      );

      print('Assignment payload: ${jsonEncode(assignment.toJson())}');

      final created = await _apiService.createAssignment(assignment);

      // Add debug prints
      print('API Response: $created');
      print('Created is null: ${created == null}');

      if (created != null) {
        _showSuccess('Assignment created successfully');
        if (mounted) {
          Navigator.pop(context, true);
        }
      } else {
        _showError('Failed to create assignment - No response from server');
      }
    } catch (e) {
      print('Create assignment error: $e');
      print('Error type: ${e.runtimeType}');
      _showError('Failed to create assignment: $e');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _showSuccess(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _removeFile(PlatformFile file) {
    setState(() {
      _selectedFiles.remove(file);
    });
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Assignment'), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title Field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Assignment Title *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Assignment title is required';
                    }
                    return null;
                  },
                  onChanged: (value) => _assignmentTitle = value.trim(),
                ),

                const SizedBox(height: 16),

                // Description Field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Description is required';
                    }
                    return null;
                  },
                  onChanged: (value) => _description = value.trim(),
                ),

                const SizedBox(height: 16),

                // Due Date Field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Due Date *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  controller: TextEditingController(
                    text:
                        _dueDate != null
                            ? '${_dueDate!.day.toString().padLeft(2, '0')}/${_dueDate!.month.toString().padLeft(2, '0')}/${_dueDate!.year}'
                            : '',
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 1)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() => _dueDate = date);
                    }
                  },
                  validator: (value) {
                    if (_dueDate == null) {
                      return 'Due date is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // File Selection Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.attach_file),
                            const SizedBox(width: 8),
                            const Text(
                              'Assignment Materials',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _isSubmitting ? null : _pickFiles,
                              icon: const Icon(Icons.upload_file),
                              label: const Text('Select Files'),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '${_selectedFiles.length} file(s) selected',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Supported: PDF, DOC, DOCX, PPT, PPTX, JPG, PNG (Max 10MB each)',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Selected Files List
                if (_selectedFiles.isNotEmpty) ...[
                  Card(
                    child: Column(
                      children:
                          _selectedFiles.map((file) {
                            return ListTile(
                              leading: Icon(
                                _getFileIcon(file.extension ?? ''),
                                color: Theme.of(context).primaryColor,
                              ),
                              title: Text(
                                file.name,
                                style: const TextStyle(fontSize: 14),
                              ),
                              subtitle: Text(
                                _formatFileSize(file.size),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                                onPressed:
                                    _isSubmitting
                                        ? null
                                        : () => _removeFile(file),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Submit Button
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _createAssignment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child:
                        _isSubmitting
                            ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text('Creating Assignment...'),
                              ],
                            )
                            : const Text(
                              'Create Assignment',
                              style: TextStyle(fontSize: 16),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }
}
