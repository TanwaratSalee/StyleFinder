import 'package:flutter_finalproject/consts/consts.dart';

Widget ourButton(
    {VoidCallback? onPress, Color? color, Color? textColor, String? title}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        // borderRadius: BorderRadius.circular(0),
      ),
      minimumSize: const Size(double.infinity, 45),
    ),
    onPressed: onPress,
    child: (title ?? '')
        .text
        .size(16)
        .color(textColor ?? blackColor)
        .fontFamily(bold)
        .make(),
  );
}
