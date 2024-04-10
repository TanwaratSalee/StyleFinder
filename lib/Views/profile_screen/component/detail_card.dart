import 'package:flutter_finalproject/consts/consts.dart';

Widget detailsCard({width, String? count, String? title}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      title!.text.color(blackColor).make(),
      5.widthBox,
      "($count)".text.fontFamily(bold).color(blackColor).size(14).make(),
    ],
  ).box.width(100).height(40).padding(const EdgeInsets.all(4)).make();
}
