import 'package:flutter_finalproject/consts/consts.dart';

Widget orderPlaceDetails({title1, title2, d1, d2}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "$title1".text.fontFamily(semiBold).make(),
            "$d1".text.color(blackColor).fontFamily(light).make()
          ],
        ),
        SizedBox(
          width: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "$title2".text.fontFamily(semiBold).make(),
              "$d2".text.fontFamily(light).color(blackColor).make(),
            ],
          ),
        )
      ],
    ),
  );
}
