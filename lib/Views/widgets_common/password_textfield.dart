import 'package:flutter_finalproject/consts/consts.dart';

bool showPassword = false;

Widget passwordTextField({
  String? title,
  String? label,
  TextEditingController? controller,
  bool isPass = false,
  bool readOnly = false,
  required Function(bool) setState,
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
      const  SizedBox(height: 8),
      TextField(
        obscureText: isPass && !showPassword,
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          isDense: true,
          labelText: label,
          labelStyle: const TextStyle(
              color: blackColor, fontFamily: regular, fontSize: 16),
          hintStyle: const TextStyle(
              color: greyDark, fontFamily: regular, fontSize: 16),
          filled: true,
          fillColor: greyThin,
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
          suffixIcon: isPass
              ? IconButton(
                  onPressed: () {
                    setState(!showPassword);
                  },
                  icon: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off,
                    color: blackColor,
                  ),
                )
              : null,
        ),
      ),
    ],
  );
}