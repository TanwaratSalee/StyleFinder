import 'package:flutter/material.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:velocity_x/velocity_x.dart';

Widget detailsCard({width, String? count, String? title}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      title!.text.color(fontBlack).make(),
      5.widthBox,
      "($count)".text.fontFamily('bold').color(fontBlack).size(14).make(),
    ],
  ).box.width(100).height(40).padding(const EdgeInsets.all(4)).make();
}
