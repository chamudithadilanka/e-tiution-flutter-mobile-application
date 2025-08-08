import 'package:flutter/material.dart';
import 'package:frontend/utils/colors.dart';

class ButtonLoginAndSingup extends StatelessWidget {
  final String buttonName;
  final VoidCallback? onPressed;

  const ButtonLoginAndSingup({
    super.key,
    required this.buttonName,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [kMainColor, kMainDarkBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomLeft,
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          buttonName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
