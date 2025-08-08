import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/models/timeschedule.dart';
import 'package:frontend/utils/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TimeScheduleListPage extends StatefulWidget {
  final String classId;
  const TimeScheduleListPage({super.key, required this.classId});

  @override
  State<TimeScheduleListPage> createState() => _TimeScheduleListPageState();
}

class _TimeScheduleListPageState extends State<TimeScheduleListPage> {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Time Schedule List Page")),
      body: FutureBuilder<List<Timeschedule>>(
        future: apiService.fetchTimeSchedulesByClassId(widget.classId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.beat(color: kMainColor, size: 50),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error.toString()}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                children: [
                  SizedBox(height: 250),
                  const SizedBox(height: 30),
                  const Icon(
                    Icons.schedule_outlined,
                    color: Colors.black38,
                    size: 80,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "No schedule available for this class",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Timeschedule timeschedule = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.23,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [kMainColor, kMainDarkBlue],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topLeft,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${timeschedule.subject}",
                            style: TextStyle(
                              color: kMainWhiteColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Class Date : ${timeschedule.endDate}",
                            style: TextStyle(
                              color: kMainWhiteColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Divider(
                            height: 10,
                            color: kMainWhiteColor,
                            thickness: 1.5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Class Start Time",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: kMainWhiteColor,
                                  ),
                                ),

                                Text(
                                  "Class End Time",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: kMainWhiteColor,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 60),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: kMainWhiteColor,
                                  size: 35,
                                ),
                                //Spacer(),
                                Icon(
                                  Icons.av_timer_outlined,
                                  color: kMainWhiteColor,
                                  size: 35,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 55),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${timeschedule.startTime}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: kMainWhiteColor,
                                  ),
                                ),

                                Text(
                                  "${timeschedule.endTime}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: kMainWhiteColor,
                                  ),
                                ),
                                //Spacer(),
                              ],
                            ),
                          ),
                          Divider(
                            height: 10,
                            color: kMainWhiteColor,
                            thickness: 1.5,
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
