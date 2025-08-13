import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/models/payment.dart';
import 'package:frontend/utils/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TakePaymentPage extends StatefulWidget {
  final String classId;
  const TakePaymentPage({super.key, required this.classId});

  @override
  State<TakePaymentPage> createState() => _TakePaymentPageState();
}

class _TakePaymentPageState extends State<TakePaymentPage> {
  double paymentAmount = 0;
  String month = "";
  ApiService apiservice = ApiService();
  String userId = "";
  //controller
  final TextEditingController _paymentAmountController =
      TextEditingController();
  final TextEditingController _montController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  //image picker
  File? _image;

  //Global Form Key
  final fromKey = GlobalKey<FormState>();

  Future<void> _loadStudentData() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        userId = preferences.getString("userId") ?? "";
      });
      print("Student Data Loaded: $userId ");
    } catch (e) {
      print(e);
    }
  }

  Future pickImageCamera() async {
    final PickedCamera = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (PickedCamera != null) {
      setState(() {
        _image = File(PickedCamera.path);
        _imageController.text = PickedCamera.path;
      });
    }
  }

  Future pickedImageFile() async {
    final PickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (PickedFile != null) {
      setState(() {
        _image = File(PickedFile.path);
        _imageController.text = PickedFile.path;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadStudentData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Take Payment")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            LottieBuilder.asset(
              "assets/animations/ID Scan.json",
              width: 200,
              height: 200,
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 1.0,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  gradient: RadialGradient(colors: [kMainColor, kMainDarkBlue]),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                      color: Colors.grey.withOpacity(0.2),
                      offset: Offset(0, 1),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: fromKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Fill Payment Slip Form : ",
                          style: TextStyle(
                            color: kMainWhiteColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _paymentAmountController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter Integer Amount";
                            }
                            return null;
                          },
                          onSaved: (Value) {
                            paymentAmount = double.parse(Value!);
                          },
                          decoration: InputDecoration(
                            labelText: "Enter Payment Amount",
                            labelStyle: TextStyle(color: kMainWhiteColor),
                            fillColor: kMainNavSelected.withOpacity(0.3),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: kMainWhiteColor,
                                style: BorderStyle.solid,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: kMainWhiteColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: kMainNavSelected.withOpacity(0.3),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: _montController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter Month";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            month = value!;
                          },
                          decoration: InputDecoration(
                            labelText: "Enter Month",
                            labelStyle: TextStyle(color: kMainWhiteColor),
                            fillColor: kMainNavSelected.withOpacity(0.3),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: kMainWhiteColor,
                                style: BorderStyle.none,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: kMainWhiteColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: kMainNavSelected.withOpacity(0.3),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  pickImageCamera();
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: kMainWhiteColor,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 1,
                                        color: Colors.black.withOpacity(0.3),
                                        blurStyle: BlurStyle.outer,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        Center(
                                          child: Text(
                                            "Camera",
                                            style: TextStyle(
                                              color: kMainColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Center(
                                          child: Icon(
                                            Icons.camera_alt_outlined,
                                            color: kMainColor,
                                            size: 23,
                                            weight: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  pickedImageFile();
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: kMainWhiteColor,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 1,
                                        color: Colors.black.withOpacity(0.3),
                                        blurStyle: BlurStyle.outer,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        Center(
                                          child: Text(
                                            "Gallery",
                                            style: TextStyle(
                                              color: kMainColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Center(
                                          child: Icon(
                                            Icons.file_present_outlined,
                                            color: kMainColor,
                                            size: 23,
                                            weight: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.height * 0.13,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusDirectional.circular(
                                10,
                              ),
                              color: kMainWhiteColor.withOpacity(0.2),
                              border: Border.all(color: kMainWhiteColor),
                            ),
                            child: Column(
                              children: [
                                _image != null
                                    ? Column(
                                      children: [
                                        SizedBox(height: 25),
                                        Image.file(
                                          _image!,
                                          width: 60,
                                          height: 60,
                                        ),
                                      ],
                                    )
                                    : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 25),
                                        Icon(
                                          Icons.camera_enhance_outlined,
                                          color: kMainWhiteColor,
                                          size: 30,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "No Image Preview",
                                          style: TextStyle(
                                            color: kMainWhiteColor,
                                          ),
                                        ),
                                      ],
                                    ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                width: MediaQuery.of(context).size.width * 1.0,
                height: MediaQuery.of(context).size.height * 0.06,

                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [kMainColor, kMainDarkBlue]),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                      color: kMainColor.withOpacity(0.2),
                      offset: Offset(0, 1),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () {
                    if (fromKey.currentState!.validate()) {
                      fromKey.currentState!.save();
                    }
                    PaymentSlip createPaymentSlip = PaymentSlip(
                      id: null,
                      studentId: userId,
                      classId: widget.classId,
                      amount: paymentAmount,
                      month: month,
                      slipFile: _image!.path,
                    );
                    apiservice.createPaymentSlip(createPaymentSlip);
                    print("classId: ${widget.classId}");
                    print("studentId: $userId");
                    print("$paymentAmount");
                    print("$month");
                    print("$_image");
                  },
                  child: Center(
                    child: Text(
                      "Submit Payment Slip",
                      style: TextStyle(
                        color: kMainWhiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
