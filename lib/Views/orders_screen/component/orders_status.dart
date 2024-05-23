import 'package:flutter_finalproject/consts/consts.dart';

Widget orderStatus(
    {String? icon, Color? color, String? title, bool? showDone}) {
  final backgroundColor = showDone ?? false ? primaryApp : greyThin;
  final iconColor = showDone ?? false ? whiteColor : greyDark;

  return Column(
    children: [
      Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: icon != null
            ? Image.asset(
                icon,
                color: iconColor,
                width: 20,
                height: 20,
              )
            : SizedBox.shrink(),
      ),
      SizedBox(height: 8),
      Text(
        title ?? "",
        style: TextStyle(color: greyDark, fontFamily: regular, fontSize: 12),
      ),
    ],
  );
}

Widget horizontalLine({required bool isActive}) {
  return VxBox(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 2,
          color: isActive ? primaryApp : greyThin,
        ),
        20.heightBox,
      ],
    ),
  ).make();
}
