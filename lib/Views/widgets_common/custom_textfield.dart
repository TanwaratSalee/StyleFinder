import 'package:flutter_finalproject/consts/consts.dart';

Widget customTextField({
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
            fontFamily: bold,
            fontSize: 16,
          ),
        ),
      const SizedBox(height: 8),
      TextField(
        obscureText: isPass,
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          isDense: true,
          labelText: label,
          labelStyle: const TextStyle(
              color: greyDark2, fontFamily: regular, fontSize: 16),
          hintStyle: const TextStyle(
              color: greyDark1, fontFamily: regular, fontSize: 16),
          filled: true,
          fillColor: thinGrey0,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: whiteColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: greyColor),
          ),
        ),
      ),
    ],
  );
}
