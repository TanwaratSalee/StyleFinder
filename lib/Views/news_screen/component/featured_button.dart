import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/collection_screen/collection_details.dart';
import 'package:flutter_finalproject/Views/collection_screen/testcollection.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/consts/styles.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

Widget featuredButton({String? title, icon}) {
  return Row(
    children: [
      Image.asset(icon, width: 60, fit: BoxFit.fill),

      10.widthBox,
      
      title!.text.fontFamily(semibold).color(fontBlack).make(),
    ],
  )
      .box
      .width(200)
      .margin(const EdgeInsets.symmetric(horizontal: 4))
      .white
      .padding(const EdgeInsets.all(4))
      .roundedSM
      .outerShadowSm
      .make()
      .onTap(() {
        Get.to(() => CollectionDetails(title: title));
      });
}
