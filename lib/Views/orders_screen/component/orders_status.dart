import 'package:flutter_finalproject/consts/consts.dart';

Widget orderStatus({icon, color, title, showDone}) {
  return ListTile(
    leading: Icon(icon, color: color)
        .box
        .border(color: color)
        .roundedSM
        .padding(const EdgeInsets.all(4))
        .make(),
    trailing: SizedBox(
      height: 100,
      width: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          "$title".text.color(greyDarkColor).make(),
          showDone
              ? const Icon(
                  Icons.done,
                  color: primaryApp,
                )
              : Container(),
        ],
      ),
    ),
  );
}
