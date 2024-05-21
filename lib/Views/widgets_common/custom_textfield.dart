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
      TextField(
        obscureText: isPass,
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          isDense: true,
          labelText: label,
          labelStyle: const TextStyle(
              color: greyDark, fontFamily: regular, fontSize: 18),
          hintStyle: const TextStyle(
              color: greyDark, fontFamily: regular, fontSize: 14),
          filled: true,
          fillColor: whiteColor,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: greyLine),
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


Widget customPasswordField({
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
      StatefulBuilder(
        builder: (context, setState) {
          bool _isObscured = isPass;

          return TextField(
            obscureText: _isObscured,
            controller: controller,
            readOnly: readOnly,
            decoration: InputDecoration(
              isDense: true,
              labelText: label,
              labelStyle: const TextStyle(
                  color: greyDark, fontFamily: regular, fontSize: 16),
              hintStyle: const TextStyle(
                  color: greyDark, fontFamily: regular, fontSize: 16),
              filled: true,
              fillColor: whiteColor,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 20), // Adjust padding
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: greyLine),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: greyColor),
              ),
              suffixIcon: isPass
                  ? IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility : Icons.visibility_off,
                        color: greyDark,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    )
                  : null,
            ),
            style: const TextStyle(
              fontSize: 16, // Adjust font size
              color: blackColor,
            ),
          );
        },
      ),
    ],
  );
}
