import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/models/assingment.dart';
import 'package:frontend/pages/teacher_pages/assignmentResultPages/submission_list.dart';
import 'package:frontend/utils/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AssingmentSubmissionSinglePage extends StatefulWidget {
  final String ClassId;
  const AssingmentSubmissionSinglePage({super.key, required this.ClassId});

  @override
  State<AssingmentSubmissionSinglePage> createState() =>
      _AssingmentSubmissionSinglePageState();
}

class _AssingmentSubmissionSinglePageState
    extends State<AssingmentSubmissionSinglePage> {
  ApiService apiService = ApiService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Assingment Submissions")),
      body: FutureBuilder<List<Assignment>>(
        future: apiService.fetchAssignmentsByClassId(widget.ClassId),
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
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: kMainWhiteColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3,
                          color: Colors.grey.shade500,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  assignment.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  assignment.description ?? "",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              width: 75,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: [kMainColor, kMainDarkBlue],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.transparent, // Button color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => SubmissionList(
                                            assingmentID: assignment.id ?? "",
                                          ),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Open",
                                  style: TextStyle(
                                    color: kMainWhiteColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
