import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/widgets_common/text_style.dart';
import 'package:flutter_finalproject/consts/consts.dart';

Widget customTextField({
  String? title,
  String? label,
  TextEditingController? controller,
  bool isPass = false, // Default value provided
  bool readOnly = false, // Default value provided
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (title != null)
        Text(
          title,
          style: TextStyle(
            color: fontBlack, // Use your color variable
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      const SizedBox(height: 8),
      TextField(
        obscureText: isPass,
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          isDense: true,
          labelText: label, // Changed to labelText as label is not a property
          // hintText: hint, // Uncomment if you have hint text
          hintStyle: TextStyle(
            color: fontGrey, // Use your color variable
          ),
          filled: true,
          fillColor: bgGreylight, // Use your color variable
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: bgGreylight), // Use your color variable
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: fontGrey), // Use your color variable
          ),
        ),
      ),
    ],
  );
}
