// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:flutter_finalproject/Views/cart_screen/qr_screen.dart';
// import 'package:flutter_finalproject/Views/cart_screen/visa_screen.dart';
// import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
// import 'package:flutter_finalproject/Views/home_screen/mainHome.dart';
// import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
// import 'package:flutter_finalproject/consts/colors.dart';
// import 'package:flutter_finalproject/consts/lists.dart';
// import 'package:flutter_finalproject/consts/styles.dart';
// import 'package:flutter_finalproject/controllers/cart_controller.dart';
// import 'package:get/get.dart';
// import 'package:velocity_x/velocity_x.dart';

// class OldPaymentMethods extends StatelessWidget {
//   const OldPaymentMethods({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var controller = Get.find<CartController>();

//     return Obx(
//       () => Scaffold(
//         backgroundColor: whiteColor,
//         bottomNavigationBar: SizedBox(
//           height: 70,
//           child: controller.placingOrder.value
//               ? Center(
//                   child: loadingIndicator(),
//                 )
//               : ourButton(
//                   onPress: () async {
//                     String selectedPaymentMethod =
//                         textpaymentMethods[controller.paymentIndex.value];
//                     if (selectedPaymentMethod == 'Mobile Banking') {
//                       print('Selected Payment Method: $selectedPaymentMethod');
//                       Get.to(() => const QRScreen());
//                     } else if (selectedPaymentMethod == 'Visa') {
//                       print('Selected Payment Method: $selectedPaymentMethod');
//                       Get.to(() => const VisaCardScreen());
//                     } else if (selectedPaymentMethod == 'Cash On Delivery') {
//                       print('Selected Payment Method: $selectedPaymentMethod');
//                       await controller.placeMyOrder(
//                           orderPaymentMethod: selectedPaymentMethod,
//                           totalAmount: controller.totalP.value);

//                       await controller.clearCart();
//                       VxToast.show(context, msg: "Order placed successfully");

//                       Get.offAll(() => MainHome());
//                     } else {
//                       VxToast.show(context,
//                           msg: "Selected payment method is not supported yet.");
//                     }
//                   },
//                   color: primaryApp,
//                   textColor: whiteColor,
//                   title: "Place my order"),
//         ),
//         appBar: AppBar(
//           title: "Choose Payment "
//               .text
//               .color(greyDark)
//               .fontFamily(regular)
//               .make(),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Obx(
//             () => Column(
//               children: List.generate(
//                 paymentMethodsImg.length,
//                 (index) {
//                   return GestureDetector(
//                     onTap: () {
//                       controller.changePaymentIndex(index);
//                     },
//                     child: Container(
//                       clipBehavior: Clip.antiAlias,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: controller.paymentIndex.value == index
//                                 ? primaryApp
//                                 : Colors.transparent,
//                             width: 4,
//                           )),
//                       margin: const EdgeInsets.only(bottom: 8),
//                       child: Stack(
//                         alignment: Alignment.topRight,
//                         children: [
//                           Image.asset(paymentMethodsImg[index],
//                               width: double.infinity,
//                               height: 120,
//                               colorBlendMode:
//                                   controller.paymentIndex.value == index
//                                       ? BlendMode.darken
//                                       : BlendMode.color,
//                               color: controller.paymentIndex.value == index
//                                   ? blackColor.withOpacity(0.4)
//                                   : Colors.transparent,
//                               fit: BoxFit.cover),
//                           controller.paymentIndex.value == index
//                               ? Transform.scale(
//                                   scale: 1.3,
//                                   child: Checkbox(
//                                     activeColor: primaryApp,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(50),
//                                     ),
//                                     value: true,
//                                     onChanged: (value) {},
//                                   ),
//                                 )
//                               : Container(),
//                           Positioned(
//                             bottom: 10,
//                             left: 10,
//                             child: textpaymentMethods[index]
//                                 .text
//                                 .color(blackColor)
//                                 .fontFamily(bold)
//                                 .size(16)
//                                 .make(),
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// class PaymentMethods extends StatelessWidget {
//   const PaymentMethods({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var controller = Get.find<CartController>();

//     return Obx(
//       () => Scaffold(
//         backgroundColor: whiteColor,
//         bottomNavigationBar: SizedBox(
//           height: 70,
//           child: controller.placingOrder.value
//               ? Center(child: loadingIndicator())
//               : ourButton(
//                   onPress: () async {
//                     String selectedPaymentMethod =
//                         textpaymentMethods[controller.paymentIndex.value];
//                     if (selectedPaymentMethod == 'Mobile Banking') {
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: Text('Mobile Banking Options'),
//                             content: _buildExpandedList(
//                                 context), // แสดง ListView ใน dialog
//                             actions: <Widget>[
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.of(context).pop();
//                                 },
//                                 child: Text('Close'),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     } else if (selectedPaymentMethod == 'Visa') {
//                       print('Selected Payment Method: $selectedPaymentMethod');
//                       Get.to(() => const VisaCardScreen());
//                     } else if (selectedPaymentMethod == 'Cash On Delivery') {
//                       print('Selected Payment Method: $selectedPaymentMethod');
//                       await controller.placeMyOrder(
//                           orderPaymentMethod: selectedPaymentMethod,
//                           totalAmount: controller.totalP.value);
//                       await controller.clearCart();
//                       VxToast.show(context, msg: "Order placed successfully");
//                       Get.offAll(() => MainHome());
//                     } else {
//                       VxToast.show(context,
//                           msg: "Selected payment method is not supported yet.");
//                     }
//                   },
//                   color: primaryApp,
//                   textColor: whiteColor,
//                   title: "Place my order"),
//         ),
//         appBar: AppBar(
//           title:
//               "Choose Payment".text.color(greyDark).fontFamily(regular).make(),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Obx(
//             () => Column(
//               children: List.generate(
//                 paymentIcons
//                     .length, // Ensure this length matches your list's length
//                 (index) {
//                   bool isSelected = controller.paymentIndex.value == index;
//                   return GestureDetector(
//                     onTap: () {
//                       controller.changePaymentIndex(index);
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                           color: isSelected
//                               ? primaryApp.withOpacity(0.1)
//                               : Colors.transparent,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: isSelected ? primaryApp : Colors.transparent,
//                             width: 4,
//                           )),
//                       margin: const EdgeInsets.only(bottom: 8),
//                       padding: EdgeInsets.all(16),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Image.asset(
//                                 paymentIcons[index],
//                                 width: 25,
//                               ),
//                               SizedBox(width: 20),
//                               textpaymentMethods[index]
//                                   .text
//                                   .color(blackColor)
//                                   .fontFamily(regular)
//                                   .size(16)
//                                   .make(),
//                             ],
//                           ),
//                           isSelected
//                               ? Checkbox(
//                                   activeColor: primaryApp,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(50),
//                                   ),
//                                   value: true,
//                                   onChanged: (value) {},
//                                 )
//                               : SizedBox(
//                                   width: 24,
//                                   height:
//                                       24), // Placeholder to maintain alignment
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class MobileBankingPopup extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Mobile Banking Details'),
//       content: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Here are the details for Mobile Banking:'),
//             // Add your mobile banking details here
//             // Example: Text('Bank Name: XYZ Bank'),
//             // Example: Text('Account Number: 123456789'),
//           ],
//         ),
//       ),
//       actions: <Widget>[
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: Text('Close'),
//         ),
//       ],
//     );
//   }
// }

// Widget _buildExpandedList(BuildContext context) {
//   return Card(
//     color: Colors.white,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(8.0),
//       side: BorderSide(color: greyColor),
//     ),
//     child: ListView.builder(
//       physics: NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       itemCount: 5, // จำนวนรายการตัวเลือกของ Mobile Banking
//       itemBuilder: (context, index) {
//         switch (index) {
//           case 0:
//             return Column(
//               children: [
//                 ListTile(
//                   title: Text('K PLUS'),
//                   leading: CircleAvatar(
//                     radius: 20,
//                     backgroundImage: AssetImage(imgMB[index]),
//                   ),
//                   onTap: () {
//                     print('Tapped on Custom Option 1');
//                     // เพิ่มโค้ดที่ต้องการให้ทำงานเมื่อกดที่ตัวเลือก 1
//                   },
//                 ),
//                 Divider(
//                   color: greyColor,
//                   thickness: 1,
//                   height: 0,
//                 ),
//               ],
//             );
//           case 1:
//             return Column(
//               children: [
//                 ListTile(
//                   title: Text('SCB'),
//                   leading: CircleAvatar(
//                     radius: 20,
//                     backgroundImage: AssetImage(imgMB[index]),
//                   ),
//                   onTap: () {
//                     print('Tapped on Custom Option 2');
//                     // เพิ่มโค้ดที่ต้องการให้ทำงานเมื่อกดที่ตัวเลือก 2
//                   },
//                 ),
//                 Divider(
//                   color: greyColor,
//                   thickness: 1,
//                   height: 0,
//                 ),
//               ],
//             );
//           // เพิ่ม case สำหรับรายการตัวเลือกของ Mobile Banking อื่น ๆ ตามต้องการ
//           default:
//             return SizedBox();
//         }
//       },
//     ),
//   );
// }
