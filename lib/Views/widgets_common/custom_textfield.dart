import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter/services.dart';


// Widget customPasswordField({
//   required TextEditingController controller,
//   String? label,
// }) {
//   return StatefulBuilder(
//     builder: (context, setState) {
//       bool _isObscured = true;

//       return TextField(
//         controller: controller,
//         obscureText: _isObscured,
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: TextStyle(
//             color: greyColor,
//             fontSize: 16,
//           ),
//           filled: true,
//           fillColor: whiteColor,
//           contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(
//               color: greyColor,
//               width: 1,
//             ),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(
//               color: greyColor,
//               width: 1,
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(
//               color: greyColor,
//               width: 1,
//             ),
//           ),
//           suffixIcon: IconButton(
//             icon: Icon(
//               _isObscured ? Icons.visibility_off : Icons.visibility,
//               color: greyColor,
//             ),
//             onPressed: () {
//               setState(() {
//                 _isObscured = !_isObscured;
//               });
//             },
//           ),
//         ),
//         style: TextStyle(
//           fontSize: 16,
//           color: blackColor,
//         ),
//       );
//     },
//   );
// }


Widget customTextField({
  String? title,
  String? label,
  TextEditingController? controller,
  bool isPass = false,
  bool readOnly = false,
  VoidCallback? onTap,
  List<TextInputFormatter>? inputFormatters,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextField(
        obscureText: isPass,
        controller: controller,
        readOnly: readOnly,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          isDense: true,
          labelText: label,
          labelStyle: const TextStyle(
              color: greyDark, fontFamily: regular, fontSize: 14),
          hintStyle: const TextStyle(
              color: greyDark, fontFamily: regular, fontSize: 12),
          filled: true,
          fillColor: whiteColor,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: greyLine),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color.fromRGBO(149, 155, 155, 1)),
          ),
        ),
        style: TextStyle(
          color: blackColor,
          fontSize: 14,
          fontFamily: regular,
        ),
      ),
    ],
  );
}


class customTextFieldPassword extends StatefulWidget {
  final String? title;
  final String? label;
  final TextEditingController? controller;
  final bool isPass;
  final bool readOnly;
  final VoidCallback? onTap;

  const customTextFieldPassword({
    Key? key,
    this.title,
    this.label,
    this.controller,
    this.isPass = false,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  @override
  _customTextFieldPasswordState createState() => _customTextFieldPasswordState();
}

class _customTextFieldPasswordState extends State<customTextFieldPassword> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          obscureText: widget.isPass ? _obscureText : false,
          controller: widget.controller,
          readOnly: widget.readOnly,
          obscuringCharacter: '●',
          decoration: InputDecoration(
            isDense: true,
            labelText: widget.label,
            labelStyle: const TextStyle(
                color: greyDark, fontFamily: regular, fontSize: 14),
            hintStyle: const TextStyle(
                color: greyDark, fontFamily: regular, fontSize: 12),
            filled: true,
            fillColor: whiteColor,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: greyLine),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide( color: Color.fromRGBO(149, 155, 155, 1)),
            ),
            suffixIcon: widget.isPass
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: greyColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
          style: TextStyle(
            color: blackColor,
            fontSize: _obscureText ? 14 : 14,
            fontFamily: regular,
            letterSpacing: _obscureText ? 2 : 1,
          ),
        ),
      ],
    );
  }
}
