import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/models/assingment.dart';
import 'package:frontend/utils/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class SubmissionList extends StatefulWidget {
  final String assingmentID;

  const SubmissionList({super.key, required this.assingmentID});

  @override
  State<SubmissionList> createState() => _SubmissionListState();
}

class _SubmissionListState extends State<SubmissionList> {
  ApiService apiService = ApiService();

  Future<void> downloadPDF(String url, String fileName) async {
    try {
      // Request storage permission
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        print("Permission denied");
        return;
      }

      // Get directory to save file
      final dir =
          await getExternalStorageDirectory(); // Use getApplicationDocumentsDirectory() for iOS
      final filePath = '${dir!.path}/$fileName';

      // Download file
      Dio dio = Dio();
      await dio.download(url, filePath);

      print("PDF downloaded to: $filePath");

      // Optional: show snackbar or toast
    } catch (e) {
      print("Error downloading PDF: $e");
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

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.greenAccent),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Submission List",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: FutureBuilder<List<dynamic>?>(
        future: apiService.getAssignmentSubmissions(widget.assingmentID),
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
            final submissions = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: submissions.length,
              itemBuilder: (context, index) {
                final submission = submissions[index];
                final student = submission['student'];

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        student['profileImage'] ?? '',
                      ),
                    ),
                    title: Text(
                      student['firstName'] ?? 'Unknown Student',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(student['email'] ?? ''),
                              Text('Stream: ${student['stream'] ?? 'N/A'}'),
                              Text(
                                'Submitted at: ${submission['submittedAt']?.substring(0, 10) ?? ''}',
                              ),
                              Text(submission['file'] ?? ''),
                            ],
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            _downloadFile(submission['fileUrl'] ?? "");
                          },
                          icon: Icon(
                            Icons.download,
                            size: 30,
                            color: kMainColor,
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
    );
  }
}
