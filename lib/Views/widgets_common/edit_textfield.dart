import 'package:flutter_finalproject/consts/consts.dart';

Widget editTextField({
  String? title,
  String? label,
  TextEditingController? controller,
  bool isPass = false,
  bool readOnly = false,
  VoidCallback? onTap,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (title != null)
        Text(
          title,
          style: const TextStyle(
            color: blackColor,
            fontFamily: medium,
            fontSize: 16,
          ),
        ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (label != null)
            Text(
              label,
              style: const TextStyle(
                color: blackColor,
                fontSize: 14,
                fontFamily: regular,
              ),
            ),
          const SizedBox(width: 20),
          Expanded(
            child: TextField(
              obscureText: isPass,
              controller: controller,
              readOnly: readOnly,
              decoration: const InputDecoration(
                isDense: true,
                hintStyle: TextStyle(color: greyDark),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: whiteColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: greyColor),
                ),
              ),
              onTap: onTap,
            ),
          ),
        ],
      ),
    ],
  );
}
