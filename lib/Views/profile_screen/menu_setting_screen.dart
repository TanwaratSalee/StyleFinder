import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_finalproject/Views/auth_screen/login_screen.dart';
import 'package:flutter_finalproject/Views/cart_screen/address_screen.dart';
import 'package:flutter_finalproject/Views/chat_screen/messaging_screen.dart';
import 'package:flutter_finalproject/Views/orders_screen/orders_screen.dart';
import 'package:flutter_finalproject/Views/profile_screen/edit_profile_screen.dart';
import 'package:flutter_finalproject/Views/profile_screen/resetPassword_screen.dart';
import 'package:flutter_finalproject/Views/wishlist_screen/wishlist_screen.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/consts/lists.dart';
import 'package:flutter_finalproject/controllers/profile_controller.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:get/get.dart';

class MenuSettingScreen extends StatelessWidget {
  const MenuSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());

    return Scaffold(
        appBar: AppBar(
  backgroundColor: whiteColor,
  title: Text(
    'Setting',
    textAlign: TextAlign.center, // This centers the title in the space available.
    style: TextStyle(
      color: fontBlack, 
      fontSize: 26,
      fontFamily: 'regular',
    ),
  ),
),

        backgroundColor: bgGreylight,
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
                      Padding(
                        padding: const EdgeInsets.all(8),
                        // child: const Align(
                        //   alignment: Alignment.topRight,
                        //   child: Icon(Icons.edit, color: fontBlack),
                        // ).onTap(() {
                        //   controller.nameController.text = data['name'];

                        //   Get.to(() => EditProfileScreen(data: data));
                        // }),
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
                                  Get.to(() => const PasswordScreen());
                                  break;
                                case 2:
                                  Get.to(() => const AddressScreen());
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
                            title: profileButtonsList[index].text.make(),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          );
                        },
                      )
                          .box
                          // .white
                          // .rounded
                          // .margin(const EdgeInsets.all(12))
                          .padding(const EdgeInsets.symmetric(horizontal: 16))
                          // .shadowSm
                          .make(),
                      //.box.color(primaryApp).make(),
                      // 20.heightBox,

                      OutlinedButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Get.offAll(() => const LoginScreen());
                          },
                          child: logout.text.fontFamily(regular).black.make())
                    ],
                  ),
                );
              }
            }));
  }
}
