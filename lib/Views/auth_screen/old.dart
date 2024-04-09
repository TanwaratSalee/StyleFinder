// // ignore_for_file: sort_child_properties_last, sized_box_for_whitespace

// import 'package:flutter/cupertino.dart';
// import 'package:flutter_finalproject/Views/home_screen/mainHome.dart';
// import 'package:flutter_finalproject/Views/widgets_common/custom_textfield.dart';
// import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
// import 'package:flutter_finalproject/consts/consts.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import '../../controllers/auth_controller.dart';

// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});
//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   bool? isCheck = false;
//   bool isSelectable = true;
//   var controller = Get.put(AuthController());

//   var nameController = TextEditingController();
//   var emailController = TextEditingController();
//   var passwordController = TextEditingController();
//   var passwordRetypeController = TextEditingController();
//   var heightController = TextEditingController();
//   var weightController = TextEditingController();
//   DateTime selectedDate = DateTime.now();
//   String? selectedSex;

//   void _showDatePicker(BuildContext ctx) {
//     showCupertinoModalPopup(
//       context: ctx,
//       builder: (_) => Container(
//         height: 300,
//         color: Colors.white,
//         child: Column(
//           children: [
//             Container(
//               height: 200,
//               child: CupertinoDatePicker(
//                 initialDateTime: selectedDate,
//                 mode: CupertinoDatePickerMode.date,
//                 onDateTimeChanged: (val) {
//                   setState(() {
//                     selectedDate = val;
//                   });
//                 },
//               ),
//             ),
//             CupertinoButton(
//               child: const Text('OK'),
//               onPressed: () => Navigator.of(ctx).pop(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String formatDateForStorage(DateTime date) {
//     final DateFormat formatter = DateFormat('EEEE, dd MMMM yyyy');
//     return formatter.format(date);
//   }

//   final List<Color> skinTones = [
//     const Color.fromARGB(255, 239, 225, 209),
//     const Color.fromRGBO(251, 211, 159, 1),
//     const Color.fromRGBO(185, 135, 98, 1),
//     const Color.fromRGBO(116, 78, 60, 1),
//   ];
//   bool canSelectSkin = true;
//   Color? selectedSkinTone;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: const BackButton(),
//         title: const Text('Create Account'),
//       ),
//       backgroundColor: whiteColor,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(15),
//             child: Obx(
//               () => Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   customTextField(
//                     label: fullname,
//                     controller: nameController,
//                     isPass: false,
//                     readOnly: false,
//                   ),
//                   const SizedBox(height: 3),
//                   customTextField(
//                     label: email,
//                     controller: emailController,
//                     isPass: false,
//                     readOnly: false,
//                   ),
//                   const SizedBox(height: 3),
//                   customTextField(
//                     label: password,
//                     controller: passwordController,
//                     isPass: true,
//                     readOnly: false,
//                   ),
//                   const SizedBox(height: 3),
//                   customTextField(
//                     label: confirmPassword,
//                     controller: passwordRetypeController,
//                     isPass: true,
//                     readOnly: false,
//                   ),
//                   const SizedBox(height: 10),

//                   //-------------------------------------- Birthday --------------------------------------
//                   Container(
//                     decoration: BoxDecoration(
//                       color:
//                           whiteColor, // Use the actual color code or variable here for light grey
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: CupertinoButton(
//                       onPressed: () => _showDatePicker(context),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16.0, vertical: 3.0),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: <Widget>[
//                             Text(
//                               formatDateForStorage(selectedDate),
//                               style: const TextStyle(
//                                   fontSize: 16, color: Colors.black),
//                             ),
//                             const SizedBox(
//                                 width: 70), // Space between the text and icon
//                             const Icon(
//                               Icons.calendar_today,
//                               size: 24.0,
//                               color: greyDarkColor,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   //-------------------------------------- Sex Selection --------------------------------------
//                   const Text(
//                     'Sex',
//                     style: TextStyle(
//                         fontSize: 16, color: Colors.black, fontFamily: regular),
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     mainAxisSize: MainAxisSize
//                         .max, // Row takes up all the horizontal space
//                     children: <String>['Man', 'Woman', 'Other']
//                         .asMap()
//                         .entries
//                         .map((entry) {
//                       int idx = entry.key;
//                       String sex = entry.value;

//                       return Flexible(
//                         fit: FlexFit
//                             .tight, // Each child fills the available space
//                         child: Padding(
//                           padding: EdgeInsets.only(
//                               left: idx != 0 ? 6.0 : 0,
//                               right: idx != 2
//                                   ? 6.0
//                                   : 0), // Add spacing on the left and right except for the first and last item
//                           child: ElevatedButton(
//                             onPressed: isSelectable
//                                 ? () {
//                                     setState(() {
//                                       selectedSex = sex;
//                                       canSelectSkin =
//                                           true; // เปิดใช้งานการเลือกสีผิว
//                                     });
//                                   }
//                                 : null,
//                             child: Text(
//                               sex,
//                               style: TextStyle(
//                                 fontFamily: regular,
//                                 fontSize: 16,
//                                 color: isSelectable && selectedSex == sex
//                                     ? primaryApp
//                                     : Colors.grey,
//                               ),
//                             ),
//                             style: ButtonStyle(
//                               backgroundColor: MaterialStateProperty.all<Color>(
//                                   selectedSex == sex
//                                       ? thinPrimaryApp
//                                       : whiteColor),
//                               foregroundColor: MaterialStateProperty.all<Color>(
//                                   selectedSex == sex ? primaryApp : whiteColor),
//                               shape: MaterialStateProperty.all<
//                                   RoundedRectangleBorder>(
//                                 RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8.0),
//                                   side: BorderSide(
//                                       color: selectedSex == sex
//                                           ? Colors.teal
//                                           : Colors.grey),
//                                 ),
//                               ),
//                               elevation: MaterialStateProperty.all<double>(0),
//                               padding: MaterialStateProperty.all<EdgeInsets>(
//                                 const EdgeInsets.symmetric(
//                                     vertical: 15.0, horizontal: 25.0),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                   const SizedBox(height: 20),

//                   //-------------------------------------- Shape Selection --------------------------------------

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.only(right: 4.0),
//                           child: customTextField(
//                             label: 'Height',
//                             controller: heightController,
//                             isPass: false,
//                             readOnly: false,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 4.0),
//                           child: customTextField(
//                             label: 'Weight',
//                             controller: weightController,
//                             isPass: false,
//                             readOnly: false,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 20),

//                   //-------------------------------------- Skin Selection --------------------------------------

//                   const Text(
//                     'Skin',
//                     style: TextStyle(
//                         fontSize: 16, color: Colors.black, fontFamily: regular),
//                   ),
//                   Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: skinTones.map((tone) {
//                           return GestureDetector(
//                             onTap: () {
//                               if (canSelectSkin) {
//                                 setState(() {
//                                   selectedSkinTone = tone;
//                                 });
//                               }
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: tone,
//                                 border: Border.all(
//                                   color: selectedSkinTone == tone
//                                       ? primaryApp
//                                       : Colors.transparent,
//                                   width: 3,
//                                 ),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               width: 50,
//                               height: 50,
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ],
//                   ),

//                   Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(2),
//                         child: Checkbox(
//                           activeColor: primaryApp,
//                           checkColor: whiteColor,
//                           value: isCheck,
//                           onChanged: (bool? newValue) {
//                             setState(() {
//                               isCheck = newValue;
//                             });
//                           },
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                           child: RichText(
//                               text: const TextSpan(children: [
//                         TextSpan(
//                             text: "I agree to the ",
//                             style: TextStyle(
//                                 color: greyDarkColor, fontFamily: bold)),
//                         TextSpan(
//                             text: termAndCond,
//                             style:
//                                 TextStyle(color: primaryApp, fontFamily: bold)),
//                         TextSpan(
//                             text: " & ",
//                             style: TextStyle(
//                               color: greyDarkColor,
//                               fontWeight: FontWeight.bold,
//                             )),
//                         TextSpan(
//                             text: privacyPolicy,
//                             style: TextStyle(
//                               color: primaryApp,
//                               fontWeight: FontWeight.bold,
//                             ))
//                       ])))
//                     ],
//                   ),
//                   // const SizedBox(height: 5),
//                   controller.isloading.value
//                       ? const CircularProgressIndicator(
//                           valueColor: AlwaysStoppedAnimation(primaryApp),
//                         )
//                       : ourButton(
//                           color: isCheck == true ? primaryApp : greyMediumColor,
//                           title: 'Next',
//                           textColor: whiteColor,
//                           onPress: () async {
//                             if (isCheck != false) {
//                               controller.isloading(true);
//                               try {
//                                 await controller
//                                     .signupMethod(
//                                         context: context,
//                                         email: emailController.text,
//                                         password: passwordController.text)
//                                     .then((value) {
//                                   return controller.storeUserData(
//                                     name: nameController.text,
//                                     email: emailController.text,
//                                     password: passwordController.text,
//                                     birthday:
//                                     formatDateForStorage(selectedDate),
//                                     sex: selectedSex ?? "",
//                                     uHeight: heightController.text,
//                                     uWeigh: weightController.text,
//                                     skin: selectedSkinTone.toString(),
//                                   );
//                                 }).then((value) {
//                                   VxToast.show(context, msg: successfully);
//                                   Get.offAll(() => MainHome());
//                                 });
//                               } catch (e) {
//                                 auth.signOut();
//                                 VxToast.show(context, msg: e.toString());
//                                 controller.isloading(false);
//                               }
//                             }
//                           },
//                         ),
//                   //.box.width(context.screenWidth - 50).make(),
//                   const Spacer(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

