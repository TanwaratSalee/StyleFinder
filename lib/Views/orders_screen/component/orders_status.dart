import 'package:flutter/material.dart';
import 'package:flutter_finalproject/consts/consts.dart';

Widget orderStatus({String? icon, Color? color, String? title, bool? showDone}) {
  final backgroundColor = showDone ?? false ? primaryApp : greyColor;
  final iconColor = showDone ?? false ? whiteColor : greyDark2;

  return ListTile(
    contentPadding: EdgeInsets.zero,
    title: Container(
      width: double.infinity, // ตั้งค่าความกว้างให้ชัดเจนหรืออาจกำหนดเป็นค่าตายตัว
      child: Column(
        mainAxisSize: MainAxisSize.min, // ให้ขนาดตามเนื้อหา
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              icon ?? "",
              color: iconColor,
              width: 18,
              height: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            title ?? "",
            style: TextStyle(color: greyDark2, fontFamily: regular, fontSize: 12),
          ),
        ],
      ),
    ),
  );
}
