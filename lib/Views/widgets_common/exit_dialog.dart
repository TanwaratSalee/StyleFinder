import 'package:flutter/services.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:flutter_finalproject/consts/consts.dart';

Widget exitDialog(context) {
  return Dialog(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        "Confirm".text.fontFamily(bold).size(18).color(blackColor).make(),
        const Divider(),
        10.heightBox,
        "Are your sure you want to exit?".text.size(16).color(blackColor).make(),
        10.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ourButton(
                color: primaryApp,
                onPress: () {
                  SystemNavigator.pop();
                },
                textColor: whiteColor,
                title: "Yes"),
            ourButton(
                color: primaryApp,
                onPress: () {
                  Navigator.pop(context);
                },
                textColor: whiteColor,
                title: "No"),
          ],
        )
      ],
    ).box.color(greyDark1).padding(const EdgeInsets.all(12)).roundedSM.make(),
  );
}
