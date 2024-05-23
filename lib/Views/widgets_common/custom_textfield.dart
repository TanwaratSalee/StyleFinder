import 'package:flutter_finalproject/consts/consts.dart';

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
//             color: Colors.grey,
//             fontSize: 16,
//           ),
//           filled: true,
//           fillColor: whiteColor,
//           contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(
//               color: Colors.grey,
//               width: 1,
//             ),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(
//               color: Colors.grey,
//               width: 1,
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(
//               color: Colors.grey,
//               width: 1,
//             ),
//           ),
//           suffixIcon: IconButton(
//             icon: Icon(
//               _isObscured ? Icons.visibility_off : Icons.visibility,
//               color: Colors.grey,
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
//           color: Colors.black,
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
              color: greyDark, fontFamily: regular, fontSize: 14),
          hintStyle: const TextStyle(
              color: greyDark, fontFamily: regular, fontSize: 12),
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
        style: TextStyle(
          color: blackColor, 
          fontSize: 14, 
          fontFamily: regular, 
        ),
      ),
    ],
  );
}

