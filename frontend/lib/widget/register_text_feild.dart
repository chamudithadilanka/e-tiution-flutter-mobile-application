import 'package:flutter/material.dart';
import 'package:frontend/utils/colors.dart';

class TextRegisterFeildBox extends StatefulWidget {
  final String hintText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool isPassword;

  const TextRegisterFeildBox({
    super.key,
    required this.hintText,
    this.validator,
    this.controller,
    this.isPassword = false,
  });

  @override
  State<TextRegisterFeildBox> createState() => _TextRegisterFeildBoxState();
}

class _TextRegisterFeildBoxState extends State<TextRegisterFeildBox> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Center(
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.isPassword ? _obscureText : false,
            validator: widget.validator,

            decoration: InputDecoration(
              hintText: widget.hintText,
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kMainColor),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red.shade300),
                borderRadius: BorderRadius.circular(10),
              ),

              suffixIcon:
                  widget.isPassword
                      ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                      : null,
            ),
          ),
        ),
      ),
    );
  }
}
