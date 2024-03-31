// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/auth_screen/login_screen.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/profile_screen/menu_setting_screen.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/auth_controller.dart';
import 'package:flutter_finalproject/controllers/profile_controller.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:get/get.dart';

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
            textAlign: TextAlign
                .center, 
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
          centerTitle:
              true, 
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
                      const Padding(
                        padding: EdgeInsets.all(8),
                        // child: const Align(
                        //   alignment: Alignment.topRight,
                        //   child: Icon(Icons.edit, color: fontBlack),
                        // ).onTap(() {
                        //   controller.nameController.text = data['name'];

                        //   Get.to(() => EditProfileScreen(data: data));
                        // }),
                      ),

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
                                // Text(
                                //   data['email'][0].toUpperCase() + data['email'].substring(1),
                                //   style: const TextStyle(fontSize: 12, color: fontGrey, fontFamily: regular),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      FutureBuilder(
                          future: FirestoreServices.getCounts(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: loadingIndcator(),
                              );
                            } else {
                              var countData = snapshot.data;

                              return const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                // children: [
                                //   detailsCard(
                                //     count: countData[0].toString(),
                                //     title: "Cart",
                                //   ),
                                //   detailsCard(
                                //     count: countData[1].toString(),
                                //     title: "Favorite",
                                //   ),
                                //   detailsCard(
                                //     count: countData[2].toString(),
                                //     title: "Order",
                                //   )
                                // ],
                              ).box.color(fontLightGrey).make();
                            }
                          }),

                      //button section

                      // ListView.separated(
                      //   shrinkWrap: true,
                      //   separatorBuilder: (context, index) {
                      //     return Container();
                      //   },
                      //   itemCount: profileButtonsList.length,
                      //   itemBuilder: (BuildContext context, int index) {
                      //     return ListTile(
                      //       onTap: () {
                      //         switch (index) {
                      //           case 0:
                      //             controller.nameController.text = data['name'];
                      //             Get.to(() => EditProfileScreen(data: data));
                      //             break;
                      //           case 1:
                      //             Get.to(() => const OrdersScreen());
                      //             break;
                      //           case 2:
                      //             Get.to(() => WishlistScreen());
                      //             break;
                      //           case 3:
                      //             Get.to(() => const MessagesScreen());
                      //             break;
                      //         }
                      //       },
                      //       leading: Image.asset(
                      //         profileButtonsIcon[index],
                      //         width: 22,
                      //       ),
                      //       title: profileButtonsList[index].text.make(),
                      //       trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      //     );
                      //   },
                      // )
                      // .box
                      // .white
                      // .rounded
                      // .margin(const EdgeInsets.all(12))
                      // .padding(const EdgeInsets.symmetric(horizontal: 16))
                      // .shadowSm
                      // .make(),
                      // .box.color(primaryApp).make(),
                      20.heightBox,

                     OutlinedButton(
                      style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                      color: whiteColor)),
                      onPressed: () async {
                        await Get.put (AuthController()).signoutMethod(context);
                        Get.offAll(() => LoginScreen);
                      },
                      child: loggedout.text.fontFamily(regular).color(primaryApp).make(),
                     )

                    ],
                  ),
                );
              }
            }));
  }
}
