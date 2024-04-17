import 'package:flutter_finalproject/consts/consts.dart';

Widget normalText({text, color = whiteColor, size = 14.0}) {
  return "$text".text.color(color).size(size).make();
}

Widget boldText({text, color = whiteColor, double? size}) {
  double finalSize = size ?? 14.0;
  return "$text".text.semiBold.color(color).size(finalSize).make();
}
