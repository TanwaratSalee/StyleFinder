import 'package:flutter_finalproject/consts/consts.dart';

Widget tapButton(
    {
      VoidCallback? onPress, Color? color, Color? textColor, String? title}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
       shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
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

// Widget bottomButton(
//     {VoidCallback? onPress, Color? color, Color? textColor, String? title}) {
//   return ElevatedButton(
//     style: ElevatedButton.styleFrom(
//       backgroundColor: color,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(8),
//           topRight: Radius.circular(8),
//           bottomLeft: Radius.circular(0),
//           bottomRight: Radius.circular(0),
//         ),
//       ),
//       minimumSize: const Size(double.infinity, 45),
//     ),
//     onPressed: onPress,
//     child: (title ?? '')
//         .text
//         .size(16)
//         .color(textColor ?? blackColor)
//         .fontFamily(bold)
//         .make(),
//   );
// }
