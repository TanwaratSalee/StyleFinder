// ignore_for_file: library_prefixes

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/auth_screen/login_screen.dart';
import 'package:flutter_finalproject/Views/cart_screen/address_screen.dart';
import 'package:flutter_finalproject/Views/chat_screen/messaging_screen.dart';
import 'package:flutter_finalproject/Views/orders_screen/orders_screen.dart';
import 'package:flutter_finalproject/Views/profile_screen/edit_profile_screen.dart';
import 'package:flutter_finalproject/Views/wishlist_screen/wishlist_screen.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/consts/lists.dart';
import 'package:flutter_finalproject/controllers/auth_controller.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:flutter_finalproject/controllers/profile_controller.dart'
    as profileCtrl;

// Then, when you want to use ProfileController, you prefix it like this:

import 'package:get/get.dart';

import 'resetPassword_screen.dart';

class MenuSettingScreen extends StatelessWidget {
  const MenuSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // var controller = Get.put(ProfileController());
    var controller = Get.put(profileCtrl.ProfileController());

    return Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          title: const Text(
            'Setting',
            textAlign: TextAlign
                .center, // This centers the title in the space available.
            style: TextStyle(
              color: blackColor,
              fontSize: 24,
              fontFamily: medium,
            ),
          ),
        ),
        backgroundColor: whiteColor,
        body: StreamBuilder(
            stream: FirestoreServices.getUser(currentUser!.uid),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                // ตรวจสอบว่ามีข้อมูลและลิสต์ docs ไม่ว่างเปล่า
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
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: const Text('Account')
                              .text
                              .size(20)
                              .fontFamily(medium)
                              .make(),
                        ),
                      ),

                      ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) {
                          return Container();
                        },
                        itemCount: profileButtonsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            onTap: () {
                              switch (index) {
                                case 0:
                                  controller.nameController.text = data['name'];
                                  Get.to(() => EditProfileScreen(data: data));
                                  break;
                                case 1:
                                  Get.to(() => PasswordScreen());
                                  break;
                                case 2:
                                  Get.to(() => AddressScreen());
                                  break;
                                case 3:
                                  Get.to(() => const OrdersScreen());
                                  break;
                                case 4:
                                  Get.to(() => const MessagesScreen());
                                  break;
                              }
                            },
                            leading: Image.asset(
                              profileButtonsIcon[index],
                              width: 22,
                            ),
                            title: profileButtonsList[index]
                                .text
                                .color(greyDark1)
                                .fontFamily(regular)
                                .make(),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 16),
                          );
                        },
                      )
                          .box
                          .color(thinPrimaryApp)
                          .rounded
                          .margin(const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8))
                          .padding(const EdgeInsets.symmetric(horizontal: 16))
                          // .shadowSm
                          .make(),
                      //.box.color(primaryApp).make(),
                      20.heightBox,

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: const Text('Actions')
                              .text
                              .size(20)
                              .fontFamily(medium)
                              .make(),
                        ),
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.transparent),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return Dialog(
                                    backgroundColor: whiteColor,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 30),
                                        const Text(
                                          'Are you sure you want to logout?',
                                          style: TextStyle(
                                              fontFamily: regular,
                                              fontSize: 18),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        const Divider(
                                          height: 1,
                                        ), // เส้นแบ่ง
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            TextButton(
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  fontFamily: regular,
                                                  fontSize: 18,
                                                  color: greyDark1,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(dialogContext)
                                                    .pop();
                                              },
                                            ),
                                            Container(
                                                height: 50,
                                                child: const VerticalDivider(
                                                    width: 70)),
                                            TextButton(
                                              child: const Text(
                                                'Logout',
                                                style: TextStyle(
                                                  fontFamily: regular,
                                                  color: redColor,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              onPressed: () async {
                                                await Get.put(AuthController())
                                                    .signoutMethod(context);
                                                Navigator.of(dialogContext).pop(); // ปิด Custom Popup
                                                Get.offAll(() =>
                                                    const LoginScreen()); // นำทางกลับไปหน้า login
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  icLogout,
                                  width: 30,
                                ),
                                const SizedBox(width: 8),
                                const Text('Logout',
                                        style: TextStyle(
                                            fontFamily: regular,
                                            fontSize: 16,
                                            color: greyDark1))
                                    .text
                                    .color(greyDark1)
                                    .fontFamily(regular)
                                    .make(),
                              ],
                            ),
                          )
                        ],
                      )
                          .box
                          .color(thinPrimaryApp)
                          .rounded
                          .margin(const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8))
                          .padding(const EdgeInsets.symmetric(horizontal: 8))
                          .make(),
                    ],
                  ),
                );
              }
            }));
  }
}
