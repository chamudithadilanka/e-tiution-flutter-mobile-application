import 'package:flutter/material.dart';
import 'package:frontend/pages/student_pages/stu_collect_detiail.dart';
import 'package:frontend/pages/student_pages/student_main_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentRegiterOtherDetailsWrapper extends StatefulWidget {
  final bool showOnboarding;

  const StudentRegiterOtherDetailsWrapper({
    super.key,
    required this.showOnboarding,
  });

  @override
  State<StudentRegiterOtherDetailsWrapper> createState() =>
      _StudentRegiterOtherDetailsWrapperState();
}

class _StudentRegiterOtherDetailsWrapperState
    extends State<StudentRegiterOtherDetailsWrapper> {
  bool isLoading = true;
  bool? onboardingStatus; // Will be set from SharedPreferences

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      onboardingStatus = prefs.getBool('onboardingComplete');
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Priority order:
    // 1. If onboardingStatus exists in SharedPreferences, use that
    // 2. Otherwise, use the widget.showOnboarding value
    final shouldShowOnboarding =
        onboardingStatus != null ? !onboardingStatus! : widget.showOnboarding;

    return shouldShowOnboarding
        ? const StudentCollectDetail()
        : const StudentDashBoard();
  }
}
