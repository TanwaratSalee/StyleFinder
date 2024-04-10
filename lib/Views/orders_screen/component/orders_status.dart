import 'package:flutter/material.dart';
import 'package:flutter_finalproject/consts/consts.dart';

Widget orderStatus({String? icon, Color? color, String? title, bool? showDone}) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          icon ?? "", // Ensure icon is not null
          color: color,
          width: 25, // Adjust width as needed
          height: 25, // Adjust height as needed
        ),
        SizedBox(height: 8), // Adjust as needed for spacing between icon and title
        Text(
          title ?? "", // Ensure title is not null
          style: TextStyle(color: fontGreyDark2),
        ),
        if (showDone ?? false)
          Icon(
            Icons.done,
            color: primaryApp,
          )
      ],
    ),
  );
}
