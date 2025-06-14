// import 'package:flutter/material.dart';
// import 'package:frontend/api/api_service.dart';
// import 'package:frontend/models/assingment.dart';
// import 'package:frontend/utils/colors.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:url_launcher/url_launcher.dart';

// class SingleAssignmentPage extends StatefulWidget {
//   final String classID;

//   const SingleAssignmentPage({super.key, required this.classID});

//   @override
//   State<SingleAssignmentPage> createState() => _SingleAssignmentPageState();
// }

// class _SingleAssignmentPageState extends State<SingleAssignmentPage> {
//   final ApiService apiService = ApiService();

//   void _downloadFile(String url) async {
//     final uri = Uri.parse(url);

//     if (await canLaunchUrl(uri)) {
//       await launchUrl(
//         uri,
//         mode: LaunchMode.platformDefault, // 👈 This is important
//       );
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Assignment"),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//       ),
//       body: FutureBuilder<List<Assignment>>(
//         future: apiService.fetchAssignmentsByClassId(widget.classID),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: LoadingAnimationWidget.beat(
//                 color: kMainNavSelected,
//                 size: 50,
//               ),
//             );
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text("No assignments found."));
//           } else {
//             final assignments = snapshot.data!;
//             return ListView.builder(
//               padding: const EdgeInsets.all(10),
//               itemCount: assignments.length,
//               itemBuilder: (context, index) {
//                 final assignment = assignments[index];
//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 20),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [kMainDarkBlue, kMainColor],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomLeft,
//                     ),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           assignment.title,
//                           style: const TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           "Description:",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: kMainWhiteColor,
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Text(
//                             assignment.description ?? "No description",
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: kMainWhiteColor,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           "Created At: ${assignment.createdAt ?? 'N/A'}",
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Colors.white,
//                           ),
//                         ),
//                         Text(
//                           "Due Date: ${assignment.dueDate ?? 'N/A'}",
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         if (assignment.materialUrls.isNotEmpty)
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children:
//                                 assignment.materialUrls.map((url) {
//                                   return Row(
//                                     children: [
//                                       Expanded(
//                                         child: Text(
//                                           url,
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 14,
//                                           ),
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                       IconButton(
//                                         icon: Icon(
//                                           Icons.download,
//                                           color: Colors.white,
//                                         ),
//                                         onPressed: () => _downloadFile(url),
//                                       ),
//                                     ],
//                                   );
//                                 }).toList(),
//                           ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/models/assingment.dart';
import 'package:frontend/utils/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleAssignmentPage extends StatefulWidget {
  final String classID;

  const SingleAssignmentPage({super.key, required this.classID});

  @override
  State<SingleAssignmentPage> createState() => _SingleAssignmentPageState();
}

class _SingleAssignmentPageState extends State<SingleAssignmentPage> {
  final ApiService apiService = ApiService();
  List<PlatformFile> _selectedFiles = [];
  bool _isSubmitting = false;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey();
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

  void _openFile(String url) async {
    try {
      final uri = Uri.parse(url);

      // First, try to launch with external application
      bool launched = false;

      if (await canLaunchUrl(uri)) {
        try {
          // Try external application first (opens with default PDF viewer)
          launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
        } catch (e) {
          print('External app launch failed: $e');
        }

        // If external app fails, try external non-browser application
        if (!launched) {
          try {
            launched = await launchUrl(
              uri,
              mode: LaunchMode.externalNonBrowserApplication,
            );
          } catch (e) {
            print('External non-browser launch failed: $e');
          }
        }

        // If still not launched, try in-app web view
        if (!launched) {
          try {
            launched = await launchUrl(uri, mode: LaunchMode.inAppWebView);
          } catch (e) {
            print('In-app web view launch failed: $e');
          }
        }

        // Show error if nothing worked
        if (!launched) {
          _showErrorSnackBar(
            'Unable to open file. Please install a PDF viewer app.',
          );
        }
      } else {
        _showErrorSnackBar('Cannot open this file type.');
      }
    } catch (e) {
      print('Error opening file: $e');
      _showErrorSnackBar('Error opening file: ${e.toString()}');
    }
  }

  void _downloadFile(String url) async {
    try {
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        // For downloading, we'll use external application mode
        // This will typically open the browser's download manager
        bool launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        if (launched) {
          _showSuccessSnackBar(
            'Download started. Check your downloads folder.',
          );
        } else {
          _showErrorSnackBar('Unable to start download.');
        }
      } else {
        _showErrorSnackBar('Cannot download this file.');
      }
    } catch (e) {
      print('Download error: $e');
      _showErrorSnackBar('Download failed: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  String _getFileName(String url) {
    try {
      String fileName = url.split('/').last;
      // Decode URL encoded characters
      fileName = Uri.decodeComponent(fileName);
      // Remove any query parameters
      if (fileName.contains('?')) {
        fileName = fileName.split('?').first;
      }
      return fileName;
    } catch (e) {
      return 'Document';
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Assignment"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: FutureBuilder<List<Assignment>>(
          future: apiService.fetchAssignmentsByClassId(widget.classID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.beat(
                  color: kMainNavSelected,
                  size: 50,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No assignments found."));
            } else {
              final assignments = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: assignments.length,
                itemBuilder: (context, index) {
                  final assignment = assignments[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    height: 700,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [kMainDarkBlue, kMainColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            assignment.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Description:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: kMainWhiteColor,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              assignment.description ?? "No description",
                              style: TextStyle(
                                fontSize: 14,
                                color: kMainWhiteColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Created At: ${assignment.createdAt ?? 'N/A'}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Due Date: ${assignment.id ?? 'N/A'}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (assignment.materialUrls.isNotEmpty) ...[
                            Text(
                              "Materials:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: kMainWhiteColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...assignment.materialUrls.map((url) {
                              String fileName = _getFileName(url);
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.picture_as_pdf,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            fileName,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: () => _openFile(url),
                                            icon: const Icon(
                                              Icons.visibility,
                                              size: 16,
                                            ),
                                            label: const Text("Open"),
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: kMainDarkBlue,
                                              backgroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: () => _downloadFile(url),
                                            icon: const Icon(
                                              Icons.download,
                                              size: 16,
                                            ),
                                            label: const Text("Download"),
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: Colors.white
                                                  .withOpacity(0.2),
                                              side: const BorderSide(
                                                color: Colors.white,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],

                          Text(
                            "Submission:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: kMainWhiteColor,
                            ),
                          ),
                          const SizedBox(height: 10),
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
                                        'Select Your Assignment',
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
                                        onPressed:
                                            _isSubmitting ? null : _pickFiles,
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
                                  if (_selectedFiles.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Selected Files:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ..._selectedFiles
                                        .map(
                                          (file) => Padding(
                                            padding: const EdgeInsets.only(
                                              top: 4,
                                            ),
                                            child: Text(
                                              file.name,
                                              style: TextStyle(
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: 370,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  kMainColor,
                                  kMainDarkBlue,
                                ], // Google-like gradient
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              onPressed:
                                  _isSubmitting || _selectedFiles.isEmpty
                                      ? null
                                      : () async {
                                        setState(() => _isSubmitting = true);

                                        try {
                                          final prefs =
                                              await SharedPreferences.getInstance();
                                          final studentId =
                                              prefs.getString('userId') ?? '';

                                          if (studentId.isEmpty) {
                                            _scaffoldMessengerKey.currentState
                                                ?.showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'User ID not found. Please login again.',
                                                    ),
                                                    backgroundColor: Colors.red,
                                                    duration: Duration(
                                                      seconds: 3,
                                                    ),
                                                    behavior:
                                                        SnackBarBehavior
                                                            .floating,
                                                  ),
                                                );
                                            return;
                                          }

                                          bool allSuccess = true;
                                          for (final file in _selectedFiles) {
                                            if (file.path == null) continue;

                                            final success = await apiService
                                                .submitAssignment(
                                                  assignmentId:
                                                      assignment.id ?? "",
                                                  studentId: studentId,
                                                  classId: widget.classID,
                                                  file: File(file.path!),
                                                );

                                            if (!success) allSuccess = false;
                                          }

                                          _scaffoldMessengerKey.currentState
                                              ?.showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    allSuccess
                                                        ? '🎉 Assignment submitted successfully!'
                                                        : '⚠️ Failed to submit some files',
                                                  ),
                                                  backgroundColor:
                                                      allSuccess
                                                          ? Colors.green
                                                          : Colors.orange,
                                                  duration: const Duration(
                                                    seconds: 3,
                                                  ),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  action: SnackBarAction(
                                                    label: 'OK',
                                                    textColor: Colors.white,
                                                    onPressed: () {
                                                      _scaffoldMessengerKey
                                                          .currentState
                                                          ?.hideCurrentSnackBar();
                                                    },
                                                  ),
                                                ),
                                              );

                                          if (allSuccess) {
                                            setState(
                                              () => _selectedFiles.clear(),
                                            );
                                          }
                                        } catch (e) {
                                          _scaffoldMessengerKey.currentState
                                              ?.showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    '❌ Error: ${e.toString().split('\n')[0]}',
                                                  ),
                                                  backgroundColor: Colors.red,
                                                  duration: const Duration(
                                                    seconds: 4,
                                                  ),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                ),
                                              );
                                        } finally {
                                          if (mounted) {
                                            setState(
                                              () => _isSubmitting = false,
                                            );
                                          }
                                        }
                                      },
                              child:
                                  _isSubmitting
                                      ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          color: Colors.white,
                                        ),
                                      )
                                      : const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.send,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            "Submit Assignment",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
