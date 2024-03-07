import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

Widget ourButton({VoidCallback? onPress, Color? color, Color? textColor, String? title}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), 
      ),
      minimumSize: const Size(double.infinity, 45),
    ),
    onPressed: onPress,
    child: (title ?? '').text.bold.color(textColor ?? Colors.black).make(),
  );
}
