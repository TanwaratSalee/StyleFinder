import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/auth_screen/login_screen.dart';
import 'package:flutter_finalproject/Views/chat_screen/messaging_screen.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/orders_screen/orders_screen.dart';
import 'package:flutter_finalproject/Views/profile_screen/component/detail_card.dart';
import 'package:flutter_finalproject/Views/profile_screen/edit_profile_screen.dart';
import 'package:flutter_finalproject/Views/wishlist_screen/wishlist_screen.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/consts/lists.dart';
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
        backgroundColor: bgGreylight,
        body: StreamBuilder(
            stream: FirestoreServices.getUser(currentUser!.uid),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
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
                                        borderRadius: BorderRadius.circular(
                                            100), // Makes image rounded
                                        child: Image.asset(
                                          imProfile,
                                          width: 120,
                                          height:
                                              120, // Specify height to ensure the box is fully rounded
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            100), // Makes image rounded
                                        child: Image.network(
                                          data['imageUrl'],
                                          width: 120,
                                          height:
                                              120, // Specify height to ensure the box is fully rounded
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                // SizedBox(
                                //   width: 20,
                                //   height: 20,
                                // ),
                                Text(
                                  data['name'],
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: fontBlack),
                                ),
                                Text(
                                  data['email'],
                                  style: TextStyle(
                                      fontSize: 12, color: fontGrey),
                                ),
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

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  detailsCard(
                                      count: countData[0].toString(),
                                      title: "in your cart",
                                      width: context.screenWidth / 3.4),
                                  detailsCard(
                                      count: countData[1].toString(),
                                      title: "in your wishlist",
                                      width: context.screenWidth / 3.2),
                                  detailsCard(
                                      count: countData[2].toString(),
                                      title: "your order",
                                      width: context.screenWidth / 3.4)
                                ],
                              );
                            }
                          }),

                      //button section
                      20.heightBox,

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
                                  Get.to(() => const OrdersScreen());
                                  break;
                                case 2:
                                  Get.to(() => const WishlistScreen());
                                  break;
                                case 3:
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
                      ).box
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
                            await Get.put(AuthController())
                                .signoutMethod(context);
                            Get.offAll(() => const LoginScreen());
                          },
                          child: logout.text.fontFamily(semibold).black.make())
                    ],
                  ),
                );
              }
            }));
  }
}
