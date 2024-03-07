import 'package:flutter/material.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/consts/styles.dart';
import 'package:velocity_x/velocity_x.dart';

Widget detailsCard({width,String? count, String? title}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
      children: [
        count!.text.fontFamily(bold).color(fontBlack).size(16).make(),
        5.heightBox,
        title!.text.color(fontBlack).make()
      ],
    ).box.color(primaryApp).rounded.width(width).height(80).padding(const EdgeInsets.all(4)).make();
}