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
                          padding: EdgeInsets.only(left: 30),
                          child: Text('Account')
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
                                  Get.to(() => OrdersScreen());
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
                          padding: EdgeInsets.only(left: 30),
                          child: Text('Actions')
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
                              // แสดงไดอะล็อกยืนยัน
                              showDialog(
                                context: context,
                                barrierDismissible:
                                    false, // กดนอกพื้นที่ไดอะล็อกไม่ได้
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    title: const Center(
                                        child: Text('Logout',
                                            style: TextStyle(
                                                fontWeight: FontWeight
                                                    .bold))), // ทำให้คำว่า Logout อยู่ตรงกลางและหนาขึ้น
                                    content: Column(
                                      mainAxisSize: MainAxisSize
                                          .min, // ปรับขนาด Column ให้เหมาะสมกับเนื้อหา
                                      children: [
                                        const Text(
                                            'Are you sure you want to logout?'),
                                        const SizedBox(
                                            height:
                                                20), // เพิ่มระยะห่างเล็กน้อยก่อนเส้นแบ่ง
                                        const Divider(), // เส้นแบ่ง
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            TextButton(
                                              child: Text('Cancel',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue)),
                                              onPressed: () {
                                                Navigator.of(dialogContext)
                                                    .pop(); // ปิดไดอะล็อกโดยไม่ทำอะไร
                                              },
                                            ),
                                            Container(
                                              height: 40,
                                              child: const VerticalDivider(
                                                  width:
                                                      50), // สร้างเส้นกั้นระหว่างปุ่ม
                                            ),
                                            TextButton(
                                              child: Text('Logout',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red)),
                                              onPressed: () async {
                                                // เรียกใช้เมธอด logout
                                                await Get.put(AuthController())
                                                    .signoutMethod(context);
                                                Navigator.of(dialogContext)
                                                    .pop(); // ปิดไดอะล็อก
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
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // ทำให้ข้อความอยู่ตรงกลางของปุ่ม
                              children: [
                                Image.asset(
                                  icLogout,
                                  width: 30,
                                ),
                                const SizedBox(width: 8),
                                const Text('Logout',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
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
                          // .shadowSm
                          .make(),
                    ],
                  ),
                );
              }
            }));
  }
}
