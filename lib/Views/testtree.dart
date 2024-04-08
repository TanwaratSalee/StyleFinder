// // // ignore_for_file: unused_local_variable

// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter_finalproject/Views/profile_screen/menu_setting_screen.dart';
// // import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
// // import 'package:flutter_finalproject/consts/consts.dart';
// // import 'package:flutter_finalproject/controllers/profile_controller.dart';
// // import 'package:flutter_finalproject/services/firestore_services.dart';
// // import 'package:get/get.dart';

// // class qProfileScreen extends StatelessWidget {
// //   const qProfileScreen({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     var controller = Get.put(ProfileController());

// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: whiteColor,
// //         automaticallyImplyLeading: false,
// //         title: const Text(
// //           'Profile',
// //           textAlign: TextAlign.center,
// //           style: TextStyle(
// //             color: blackColor,
// //             fontSize: 26,
// //             fontFamily: 'regular',
// //           ),
// //         ),
// //         actions: <Widget>[
// //           IconButton(
// //             icon: const Icon(
// //               Icons.menu,
// //               color: blackColor,
// //             ),
// //             onPressed: () {
// //               Get.to(() => const MenuSettingScreen());
// //             },
// //           ),
// //         ],
// //         centerTitle: true,
// //       ),
// //       backgroundColor: whiteColor,
// //       body: StreamBuilder(
// //         stream: FirestoreServices.getUser(currentUser!.uid),
// //         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
// //           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
// //             return const Center(
// //               child: CircularProgressIndicator(
// //                 valueColor: AlwaysStoppedAnimation(primaryApp),
// //               ),
// //             );
// //           } else {
// //             var data = snapshot.data!.docs[0];

// //             return SafeArea(
// //               child: Column(
// //                 children: [
// //                   Center(
// //                     child: Padding(
// //                       padding: const EdgeInsets.symmetric(vertical: 8.0),
// //                       child: SingleChildScrollView(
// //                         child: Column(
// //                           mainAxisSize: MainAxisSize.min,
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             data['imageUrl'] == ''
// //                                 ? ClipRRect(
// //                                     borderRadius: BorderRadius.circular(100),
// //                                     child: Image.asset(
// //                                       imProfile,
// //                                       width: 120,
// //                                       height: 120,
// //                                       fit: BoxFit.cover,
// //                                     ),
// //                                   )
// //                                 : ClipRRect(
// //                                     borderRadius: BorderRadius.circular(100),
// //                                     child: Image.network(
// //                                       data['imageUrl'],
// //                                       width: 120,
// //                                       height: 120,
// //                                       fit: BoxFit.cover,
// //                                     ),
// //                                   ),
// //                             const SizedBox(height: 5),
// //                             Text(
// //                               data['name'][0].toUpperCase() +
// //                                   data['name'].substring(1),
// //                               style: const TextStyle(
// //                                 fontSize: 24,
// //                                 color: blackColor,
// //                                 fontFamily: regular,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   Expanded(
// //                     child: StreamBuilder<QuerySnapshot>(
// //                       stream: FirestoreServices.getWishlists(),
// //                       builder: (context, snapshot) {
// //                         if (!snapshot.hasData) {
// //                           return const Center(
// //                             child: CircularProgressIndicator(),
// //                           );
// //                         }
// //                         final data = snapshot.data!.docs;
// //                         if (data.isEmpty) {
// //                           return const Center(
// //                             child: Text("No orders yet!",
// //                                 style: TextStyle(color: fontGreyDark)),
// //                           );
// //                         }
// //                         return ListView.separated(
// //                           itemCount: data.length,
// //                           itemBuilder: (context, index) {
// //                             return GestureDetector(
// //                               onTap: () {
// //                                 Navigator.push(
// //                                   context,
// //                                   MaterialPageRoute(
// //                                     builder: (context) => ItemDetails(
// //                                       title: data[index]['p_name'],
// //                                       data: data[index],
// //                                     ),
// //                                   ),
// //                                 );
// //                               },
// //                               child: Container(
// //                                 margin: const EdgeInsets.symmetric(
// //                                     vertical: 5, horizontal: 10),
// //                                 decoration: BoxDecoration(
// //                                   color: whiteColor,
// //                                   borderRadius: BorderRadius.circular(8),
// //                                 ),
// //                                 child: Row(
// //                                   crossAxisAlignment: CrossAxisAlignment.start,
// //                                   children: <Widget>[
// //                                     Padding(
// //                                       padding: const EdgeInsets.all(10.0),
// //                                       child: ClipRRect(
// //                                         borderRadius: BorderRadius.circular(8),
// //                                         child: Image.network(
// //                                           data[index]['p_imgs'][0],
// //                                           height: 75,
// //                                           width: 65,
// //                                           fit: BoxFit.cover,
// //                                         ),
// //                                       ),
// //                                     ),
// //                                     Expanded(
// //                                       child: Padding(
// //                                         padding: const EdgeInsets.fromLTRB(
// //                                             0, 10, 0, 10),
// //                                         child: Column(
// //                                           crossAxisAlignment:
// //                                               CrossAxisAlignment.start,
// //                                           children: <Widget>[
// //                                             Text(
// //                                               data[index]['p_name'],
// //                                               style: const TextStyle(
// //                                                 fontSize: 16,
// //                                                 fontFamily: regular,
// //                                               ),
// //                                             ),
// //                                             Text(
// //                                               "${data[index]['p_price']}",
// //                                               style: const TextStyle(
// //                                                 fontSize: 14,
// //                                                 fontFamily: light,
// //                                               ),
// //                                             ),
// //                                           ],
// //                                         ),
// //                                       ),
// //                                     ),
// //                                     IconButton(
// //                                       icon: const Icon(Icons.favorite,
// //                                           color: Colors.red),
// //                                       onPressed: () async {
// //                                         await FirebaseFirestore.instance
// //                                             .collection(productsCollection)
// //                                             .doc(data[index].id)
// //                                             .update({
// //                                           'p_wishlist':
// //                                               FieldValue.arrayRemove([
// //                                             FirebaseAuth
// //                                                 .instance.currentUser!.uid
// //                                           ])
// //                                         });
// //                                       },
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                             );
// //                           },
// //                           separatorBuilder: (context, index) => Padding(
// //                             padding: const EdgeInsets.symmetric(horizontal: 10),
// //                             child: Divider(
// //                               color: Colors.grey[200],
// //                               thickness: 1,
// //                             ),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             );
// //           }
// //         },
// //       ),
// //     );
// //   }
// // }

// // ignore_for_file: unused_local_variable

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_finalproject/Views/profile_screen/menu_setting_screen.dart';
// import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
// import 'package:flutter_finalproject/consts/consts.dart';
// import 'package:flutter_finalproject/controllers/profile_controller.dart';
// import 'package:flutter_finalproject/services/firestore_services.dart';
// import 'package:get/get.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var controller = Get.put(ProfileController());

//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: whiteColor,
//           automaticallyImplyLeading: false,
//           title: const Text(
//             'Profile',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: fontBlack,
//               fontSize: 26,
//               fontFamily: 'regular',
//             ),
//           ),
//           actions: <Widget>[
//             IconButton(
//               icon: const Icon(
//                 Icons.menu,
//                 color: fontBlack,
//               ),
//               onPressed: () {
//                 Get.to(() => const MenuSettingScreen());
//               },
//             ),
//           ],
//           centerTitle: true,
//         ),
//         backgroundColor: whiteColor,
//         body: StreamBuilder(
//             stream: FirestoreServices.getUser(currentUser!.uid),
//             builder:
//                 (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//               if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                 return const Center(
//                   child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation(primaryApp),
//                   ),
//                 );
//               } else {
//                 var data = snapshot.data!.docs[0];

//                 return SafeArea(
//                   child: Column(
//                     children: [
//                       Center(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: SingleChildScrollView(
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 data['imageUrl'] == ''
//                                     ? ClipRRect(
//                                         borderRadius:
//                                             BorderRadius.circular(100),
//                                         child: Image.asset(
//                                           imProfile,
//                                           width: 120,
//                                           height: 120,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       )
//                                     : ClipRRect(
//                                         borderRadius:
//                                             BorderRadius.circular(100),
//                                         child: Image.network(
//                                           data['imageUrl'],
//                                           width: 120,
//                                           height: 120,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                 const SizedBox(height: 5),
//                                 Text(
//                                   data['name'][0].toUpperCase() +
//                                       data['name'].substring(1),
//                                   style: const TextStyle(
//                                       fontSize: 24,
//                                       color: fontBlack,
//                                       fontFamily: regular),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),

//                       // FutureBuilder<QuerySnapshot>(
//                       //     future: FirestoreServices.getWishlists(),
//                       //     builder: (context, snapshot) {
//                       //       if (!snapshot.hasData) {
//                       //         return const Center(
//                       //             child: CircularProgressIndicator());
//                       //       }
//                       //       final data = snapshot.data!.docs;
//                       //       if (data.isEmpty) {
//                       //         return const Center(
//                       //             child: Text("No orders yet!",
//                       //                 style: TextStyle(color: fontGreyDark)));
//                       //       }
//                       //       return ListView.separated(
//                       //         itemCount: data.length,
//                       //         itemBuilder: (context, index) {
//                       //           return GestureDetector(
//                       //             onTap: () {
//                       //               Navigator.push(
//                       //                 context,
//                       //                 MaterialPageRoute(
//                       //                   builder: (context) => ItemDetails(
//                       //                     title: data[index]['p_name'],
//                       //                     data: data[index],
//                       //                   ),
//                       //                 ),
//                       //               );
//                       //             },
//                       //             child: Container(
//                       //               margin: const EdgeInsets.symmetric(
//                       //                   vertical: 5, horizontal: 10),
//                       //               decoration: BoxDecoration(
//                       //                 color: whiteColor,
//                       //                 borderRadius: BorderRadius.circular(8),
//                       //               ),
//                       //               child: Row(
//                       //                 crossAxisAlignment:
//                       //                     CrossAxisAlignment.start,
//                       //                 children: <Widget>[
//                       //                   Padding(
//                       //                     padding: const EdgeInsets.all(10.0),
//                       //                     child: ClipRRect(
//                       //                       borderRadius:
//                       //                           BorderRadius.circular(8),
//                       //                       child: Image.network(
//                       //                         data[index]['p_imgs'][0],
//                       //                         height: 75,
//                       //                         width: 65,
//                       //                         fit: BoxFit.cover,
//                       //                       ),
//                       //                     ),
//                       //                   ),
//                       //                   Expanded(
//                       //                     child: Padding(
//                       //                       padding: const EdgeInsets.fromLTRB(
//                       //                           0, 10, 0, 10),
//                       //                       child: Column(
//                       //                         crossAxisAlignment:
//                       //                             CrossAxisAlignment.start,
//                       //                         children: <Widget>[
//                       //                           Text(
//                       //                             data[index]['p_name'],
//                       //                             style: const TextStyle(
//                       //                               fontSize: 16,
//                       //                               fontFamily: regular,
//                       //                             ),
//                       //                           ),
//                       //                           Text(
//                       //                             "${data[index]['p_price']}",
//                       //                             style: const TextStyle(
//                       //                               fontSize: 14,
//                       //                               fontFamily: light,
//                       //                             ),
//                       //                           ),
//                       //                         ],
//                       //                       ),
//                       //                     ),
//                       //                   ),
//                       //                   IconButton(
//                       //                     icon: const Icon(Icons.favorite,
//                       //                         color: Colors.red),
//                       //                     onPressed: () async {
//                       //                       await FirebaseFirestore.instance
//                       //                           .collection(productsCollection)
//                       //                           .doc(data[index].id)
//                       //                           .update({
//                       //                         'p_wishlist':
//                       //                             FieldValue.arrayRemove([
//                       //                           FirebaseAuth
//                       //                               .instance.currentUser!.uid
//                       //                         ])
//                       //                       });
//                       //                     },
//                       //                   ),
//                       //                 ],
//                       //               ),
//                       //             ),
//                       //           );
//                       //         },
//                       //         separatorBuilder: (context, index) => Padding(
//                       //           padding:
//                       //               const EdgeInsets.symmetric(horizontal: 10),
//                       //           child: Divider(
//                       //             color: Colors.grey[200],
//                       //             thickness: 1,
//                       //           ),
//                       //         ),
//                       //       );
//                       //     }),

//                       // OutlinedButton(
//                       //     style: OutlinedButton.styleFrom(
//                       //         side: const BorderSide(color: whiteColor)),
//                       //     onPressed: () async {
//                       //       await Get.put(AuthController())
//                       //           .signoutMethod(context);
//                       //       Get.offAll(() => LoginScreen);
//                       //     },
//                       //     child: loggedout.text
//                       //         .fontFamily(regular)
//                       //         .color(primaryApp)
//                       //         .make(),
//                       //   )
//                     ],
//                   ),
//                 );
//               }
//             }));
//   }
// }
