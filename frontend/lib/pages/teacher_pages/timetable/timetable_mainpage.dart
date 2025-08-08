import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/models/timeschedule.dart';
import 'package:frontend/utils/colors.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimetableMainPage extends StatefulWidget {
  final String classId;
  const TimetableMainPage({super.key, required this.classId});

  @override
  State<TimetableMainPage> createState() => _TimetableMainPageState();
}

class _TimetableMainPageState extends State<TimetableMainPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedstartTime;
  TimeOfDay? _selectedendTime;

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  // final TextEditingController _dateController = TextEditingController();
  // final TextEditingController _startTimeController = TextEditingController();
  // final TextEditingController _endTimeController = TextEditingController();

  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  String endDate = "";
  String day = "";
  String subject = "";
  String startTime = "";
  String endTime = "";
  String userID = "";
  bool isTeacherLoading = true;

  Future<void> _loadTeacherData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        userID = prefs.getString('userId') ?? '';
        isTeacherLoading = false; // ← FIXED: Removed `bool` keyword
      });
      print("Teacher Data Loaded: $userID ");
    } catch (e) {
      print('Error loading teacher data: $e');
      setState(() {
        isTeacherLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadTeacherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Time Schedualing",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              LottieBuilder.asset(
                "assets/animations/Time.json",
                //  fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * 1.0,
                height: 170,
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 1.0,
                  height: MediaQuery.of(context).size.height * 0.58,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [kMainColor, kMainDarkBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          "Select Date and Time",
                          style: TextStyle(
                            color: kMainWhiteColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Select endDate";
                            }
                            return null;
                          },

                          onSaved: (value) {
                            endDate = value!;
                          },

                          controller: TextEditingController(
                            text:
                                _selectedDate != null
                                    ? "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}"
                                    : "",
                          ),
                          decoration: InputDecoration(
                            fillColor: kMainColor,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: kMainWhiteColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: "Select endDate",
                            labelStyle: TextStyle(color: kMainWhiteColor),
                            icon: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              color: kMainWhiteColor,
                              onPressed: () {
                                // Implement date picker functionality here
                                _datePicker();
                              },
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kMainWhiteColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kMainColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Select Time";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            startTime = value!;
                          },

                          controller: TextEditingController(
                            text:
                                _selectedstartTime != null
                                    ? "${_selectedstartTime!.hour.toString().padLeft(2, '0')}:${_selectedstartTime!.minute.toString().padLeft(2, '0')} "
                                    : "",
                          ),
                          decoration: InputDecoration(
                            fillColor: kMainColor,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: kMainWhiteColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: "Select Start Time",
                            labelStyle: TextStyle(color: kMainWhiteColor),
                            icon: IconButton(
                              icon: const Icon(Icons.access_time),
                              color: kMainWhiteColor,
                              onPressed: () {
                                _startTimePicker();
                              },
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kMainWhiteColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kMainColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Select Value";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            endTime = value!;
                          },
                          controller: TextEditingController(
                            text:
                                _selectedendTime != null
                                    ? "${_selectedendTime!.hour.toString().padLeft(2, '0')}:${_selectedendTime!.minute.toString().padLeft(2, '0')}"
                                    : "",
                          ),
                          decoration: InputDecoration(
                            fillColor: kMainColor,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: kMainWhiteColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: "Select End Time",
                            labelStyle: TextStyle(color: kMainWhiteColor),
                            icon: IconButton(
                              icon: const Icon(Icons.av_timer_sharp),
                              color: kMainWhiteColor,
                              onPressed: () {
                                _endTimePicker();
                              },
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kMainWhiteColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kMainColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please  Enter Subject";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            subject = value!;
                          },
                          controller: _subjectController,
                          decoration: InputDecoration(
                            fillColor: kMainColor,
                            filled: true,
                            labelText: "Enter Subject",
                            labelStyle: TextStyle(color: kMainWhiteColor),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: kMainWhiteColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kMainWhiteColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kMainNavSelected),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),

                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please  Enter Day";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            day = value!;
                          },
                          controller: _dayController,
                          decoration: InputDecoration(
                            fillColor: kMainColor,
                            filled: true,
                            labelText: "Enter Day",
                            labelStyle: TextStyle(color: kMainWhiteColor),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: kMainWhiteColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kMainWhiteColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kMainNavSelected),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.06,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [kMainColor, kMainDarkBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // child: Center(
                  //   child: Text(
                  //     "Submit Schedule",
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.w600,
                  //       color: kMainWhiteColor,
                  //       fontSize: 18,
                  //     ),
                  //   ),
                  // ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                      }

                      Timeschedule newTimeSchedule = Timeschedule(
                        classId: widget.classId.trim(),
                        day: day.trim(),
                        subject: subject.trim(),
                        startTime: startTime.trim(),
                        endTime: endTime.trim(),
                        teacherId: userID.trim(),
                        endDate: DateTime.parse(endDate),
                      );

                      apiService.addTimeSchrduale(newTimeSchedule);
                      if (widget.classId != null &&
                          userID != null &&
                          day != null &&
                          subject != null &&
                          startTime != null &&
                          endTime != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: kMainColor,
                            content: Text(
                              "Time Scheduale Created Successfully !",
                              style: TextStyle(
                                color: kMainWhiteColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(" Time Scheduale cannot Created !"),
                          ),
                        );
                      }

                      print("classId: ${widget.classId}");
                      print("teacherId: $userID");
                      print("day: $day");
                      print("subject: $subject");
                      print("startTime: $startTime");
                      print("endTime: $endTime");
                    },
                    child: Text(
                      "Submit Schedule",
                      style: TextStyle(
                        color: kMainWhiteColor,
                        fontSize: 20,
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
  }

  Future<void> _datePicker() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _startTimePicker() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      if (_selectedstartTime == null) {
        setState(() {
          _selectedstartTime = picked;
        });
      }
    }
  }

  Future<void> _endTimePicker() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      if (_selectedendTime == null) {
        setState(() {
          _selectedendTime = picked;
        });
      }
    }
  }
}
