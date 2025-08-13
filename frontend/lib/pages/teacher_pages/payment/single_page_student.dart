import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/models/payment.dart';
import 'package:frontend/utils/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SinglePageStudent extends StatefulWidget {
  final String studentId;
  final String studentFullName;
  final String studentProfileImage;
  final String studentEmail;
  final String classId;

  const SinglePageStudent({
    super.key,
    required this.studentId,
    required this.studentFullName,
    required this.studentProfileImage,
    required this.studentEmail,
    required this.classId,
  });

  @override
  State<SinglePageStudent> createState() => _SinglePageStudentState();
}

class _SinglePageStudentState extends State<SinglePageStudent> {
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Single Student Payment Page")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _studentInfoSection(),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Monthly Payment Resit List",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: kMainBlackColor,
              ),
            ),
          ),

          Expanded(child: futureWidget()),
        ],
      ),
    );
  }

  Widget _studentInfoSection() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 1.0,
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [kMainColor, kMainDarkBlue],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade400,
                spreadRadius: 1,
                offset: Offset(0, 1),
                blurRadius: 1,
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 30,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.shade400,
                              spreadRadius: 1.5,
                              offset: Offset(0, 1),
                              blurRadius: 5,
                            ),
                          ],
                          border: Border.all(color: kMainWhiteColor, width: 3),
                          borderRadius: BorderRadius.circular(150),
                          color: kMainWhiteColor,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(150),
                          child: Image.network("${widget.studentProfileImage}"),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.studentFullName}",
                              style: TextStyle(
                                color: kMainWhiteColor,
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            Text(
                              "Student ID : ${widget.studentId}",
                              style: TextStyle(
                                color: kMainWhiteColor,
                                fontSize: 10,
                              ),
                            ),

                            Text(
                              "Email : ${widget.studentEmail}",
                              style: TextStyle(
                                color: kMainWhiteColor,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget futureWidget() {
    return FutureBuilder<List<PaymentSlip>>(
      future: apiService.fetchPaymentSlipsByStudentId(widget.studentId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.beat(color: kMainColor, size: 50),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No payment slips found"));
        }

        // Filter payment slips by classId first
        final filteredSlips =
            snapshot.data!
                .where((slip) => slip.classId == widget.classId)
                .toList();

        if (filteredSlips.isEmpty) {
          return const Center(
            child: Text("No payment slips found for this class"),
          );
        }

        return ListView.builder(
          itemCount: filteredSlips.length,
          itemBuilder: (context, index) {
            final paymentSlip = filteredSlips[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [kMainColor, kMainDarkBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Stack(
                    children: [
                      Text(
                        "Month ${paymentSlip.month}",
                        style: TextStyle(
                          color: kMainWhiteColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      Positioned(
                        top: 25,
                        child: Text(
                          "Receipt ID : ${paymentSlip.id}",
                          style: TextStyle(
                            color: kMainWhiteColor,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 40,
                        bottom: 5,
                        child: Icon(
                          Icons.receipt,
                          color: kMainWhiteColor,
                          size: 290,
                        ),
                      ),
                      Center(
                        child: Image.network(
                          "${ApiService.ip}${paymentSlip.slipFile}",
                          width: 400,
                          height: 200,
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(height: 340),
                          Text(
                            "Amount ${paymentSlip.amount}",
                            style: TextStyle(
                              color: kMainWhiteColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
