// ignore_for_file: file_names

import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/consts/consts.dart';

List<Widget> iconsActionButtons() {
  return [
    IconButton(
      icon: const Icon(Icons.close, color: Colors.blue),
      onPressed: () {
        // Code to execute when this button is pressed
      },
    )
        .box
        .color(greyThin.withOpacity(0.4))
        .padding(const EdgeInsets.all(10.0))
        .roundedFull
        .make(),
    25.widthBox, // สมมติว่าคุณมี widthBox เป็นส่วนหนึ่งของการตั้งค่า UI ของคุณ
    IconButton(
      icon: const Icon(Icons.arrow_upward, color: Colors.lightGreen),
      onPressed: () {
        // Code to execute when this button is pressed
      },
    )
        .box
        .color(greyThin.withOpacity(0.4))
        .padding(const EdgeInsets.all(10.0))
        .roundedFull
        .make(),
    25.widthBox,
    IconButton(
      icon: const Icon(Icons.favorite, color: Colors.red),
      onPressed: () {
        // Code to execute when this button is pressed
      },
    )
        .box
        .color(greyThin.withOpacity(0.4))
        .padding(const EdgeInsets.all(10.0))
        .roundedFull
        .make(),
  ];
}
