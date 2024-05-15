// Future<void> _showCustomDialog(BuildContext context) async {
//   return showDialog<void>(
//     context: context,
//     barrierDismissible: true,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Image.asset(
//                 imgPopup,
//                 width: 200,
//                 height: 240,
//                 fit: BoxFit.contain,
//               ),
//               SizedBox(height: 20),  // Spacing between the image and the text
//               Text(
//                 'Check your email to reset your password!',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontFamily: 'medium',  // Ensure 'medium' is correctly defined
//                   color: greyDark2,      // Ensure greyDark2 is a defined Color variable
//                   fontSize: 20,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();  // Close the dialog
//               Get.to(LoginScreen());       // Navigate to the LoginScreen
//             },
//             child: "Continue".text.white.make().box.pink500.roundedSM.shadowLg.make().px16(),
//           ),
//         ],
//       );
//     },
//   );
// }

// void _showCustomDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return Dialog(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               45.heightBox,
//               const Text('Are you sure to logout?')
//                   .text
//                   .size(18)
//                   .fontFamily(regular)
//                   .color(greyDark2)
//                   .make(),
//               45.heightBox,
//               const Divider(
//                 height: 1,
//                 color: greyColor,
//               ),
//               IntrinsicHeight(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Expanded(
//                       child: TextButton(
//                         child: const Text('Cancel',style: TextStyle(color: redColor, fontFamily: medium, fontSize: 14)),
//                         onPressed: () => Navigator.of(context).pop(),
//                       ),
//                     ),
//                     const VerticalDivider(
//                         width: 1, thickness: 1, color: greyColor),
//                     Expanded(
//                       child: TextButton(
//                         child: const Text('Logout',style: TextStyle(color: greyDark1, fontFamily: medium, fontSize: 14),),
//                         onPressed: () async {
//                           await Get.put(AuthController())
//                               .signoutMethod(context);
//                           Navigator.of(dialogContext).pop();
//                           Get.offAll(() => const LoginScreen());
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ).box.white.roundedLg.make(),
//         );
//       },
//     );
//   }
