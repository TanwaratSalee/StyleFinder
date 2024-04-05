// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/auth_screen/login_screen.dart';
import 'package:flutter_finalproject/Views/chat_screen/messaging_screen.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/orders_screen/orders_screen.dart';
import 'package:flutter_finalproject/Views/profile_screen/edit_profile_screen.dart';
import 'package:flutter_finalproject/Views/profile_screen/menu_setting_screen.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/auth_controller.dart';
import 'package:flutter_finalproject/controllers/profile_controller.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:get/get.dart';

import '../../consts/lists.dart';
import '../wishlist_screen/wishlist_screen.dart';
import 'component/detail_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());

    return Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          automaticallyImplyLeading: false,
          title: const Text(
            'Profile',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: fontBlack,
              fontSize: 26,
              fontFamily: 'regular',
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.menu,
                color: fontBlack,
              ),
              onPressed: () {
                Get.to(() => const MenuSettingScreen());
              },
            ),
          ],
          centerTitle: true,
        ),
        backgroundColor: whiteColor,
        body: StreamBuilder(
            stream: FirestoreServices.getUser(currentUser!.uid),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(primaryApp),
                  ),
                );
              } else {
                var data = snapshot.data!.docs[0];

                return SafeArea(
                  child: Column(
                    children: [

                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                data['imageUrl'] == ''
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.asset(
                                          imProfile,
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.network(
                                          data['imageUrl'],
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                const SizedBox(height: 5),
                                Text(
                                  data['name'][0].toUpperCase() +
                                      data['name'].substring(1),
                                  style: const TextStyle(
                                      fontSize: 24,
                                      color: fontBlack,
                                      fontFamily: regular),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // FutureBuilder(
                      //     future: FirestoreServices.getCounts(),
                      //     builder:
                      //         (BuildContext context, AsyncSnapshot snapshot) {
                      //       if (!snapshot.hasData) {
                      //         return Center(
                      //           child: loadingIndicator(),
                      //         );
                      //       } else {
                      //         var countData = snapshot.data;

                              // return const Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceEvenly,
                              //   children: [
                              //     detailsCard(
                              //       count: countData[0].toString(),
                              //       title: "Cart",
                              //     ),
                              //     detailsCard(
                              //       count: countData[1].toString(),
                              //       title: "Favorite",
                              //     ),
                              //     detailsCard(
                              //       count: countData[2].toString(),
                              //       title: "Order",
                              //     )
                              //   ],
                              // ).box.color(fontLightGrey).make();
                          //   }
                          // }),

                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: whiteColor)),
                        onPressed: () async {
                          await Get.put(AuthController())
                              .signoutMethod(context);
                          Get.offAll(() => LoginScreen);
                        },
                        child: loggedout.text
                            .fontFamily(regular)
                            .color(primaryApp)
                            .make(),
                      )
                    ],
                  ),
                );
              }
            }));
  }
}