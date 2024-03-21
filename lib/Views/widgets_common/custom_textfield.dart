import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/widgets_common/text_style.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:velocity_x/velocity_x.dart';

Widget customTextField(
    {String? title, String? label, controller, isPass,  readOnly}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (title != null) title.text.color(fontBlack).fontFamily(bold).size(16).make(),
      const SizedBox(height: 8),
      TextField(
        obscureText: isPass,
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          isDense: true,
          label: boldText(text: label, color: fontGrey, size: 16),
          // hintText: hint,
          hintStyle: const TextStyle(
            color: fontGrey, 
          ),
          filled: true,
          fillColor: bgGreylight,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: bgGreylight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: fontGrey),
          ),
        ),
      ),
    ],
  );
}
