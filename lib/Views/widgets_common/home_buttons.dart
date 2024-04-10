import 'package:flutter/material.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/consts/styles.dart';
import 'package:velocity_x/velocity_x.dart';

Widget homeButtons(
    {width,
    height,
    required IconData icon,
    /* other parameters */ String? title,
    onPress}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(icon, size: 26),
      10.heightBox,
      title!.text.fontFamily(regular).color(fontGreyDark2).make(),
    ],
  ).box.rounded.white.size(width, height).shadowSm.make();
}
