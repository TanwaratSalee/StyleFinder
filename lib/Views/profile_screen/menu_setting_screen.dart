import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/auth_screen/login_screen.dart';
import 'package:flutter_finalproject/Views/cart_screen/address_screen.dart';
import 'package:flutter_finalproject/Views/chat_screen/messaging_screen.dart';
import 'package:flutter_finalproject/Views/orders_screen/orders_screen.dart';
import 'package:flutter_finalproject/Views/profile_screen/edit_profile_screen.dart';
import 'package:flutter_finalproject/Views/profile_screen/resetPassword_screen.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/consts/lists.dart';
import 'package:flutter_finalproject/controllers/auth_controller.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:flutter_finalproject/controllers/profile_controller.dart' as profileCtrl;
import 'package:get/get.dart';

class MenuSettingScreen extends StatelessWidget {
  const MenuSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(profileCtrl.ProfileController());

    return Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          title: const Text(
            'Setting',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: blackColor,
              fontSize: 24,
              fontFamily: medium,
            ),
          ),
        ),
        backgroundColor: whiteColor,
        body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                      stream: FirestoreServices.getUser(currentUser!.uid),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(primaryApp),
                            ),
                          );
                        } else {
                          var data = snapshot.data!.docs[0];
                          return buildUserProfile(context, data, controller);
                        }
                      }
                  ),
                ),
                buildActionsSection(context)
              ],
            )
        ));
  }

  Widget buildUserProfile(BuildContext context, dynamic data, profileCtrl.ProfileController controller) {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (context, index) => Container(),
      itemCount: profileButtonsList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () => handleProfileNavigation(index, context, data, controller),
          leading: Image.asset(profileButtonsIcon[index], width: 22),
          title: profileButtonsList[index]
              .text
              .color(greyDark1)
              .fontFamily(regular)
              .make(),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        );
      },
    ).box.color(whiteColor).rounded.margin(const EdgeInsets.symmetric(horizontal: 4, vertical: 8)).padding(const EdgeInsets.symmetric(horizontal: 16)).make();
  }

  Widget buildActionsSection(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 30),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.transparent),
          ),
          onPressed: () => showLogoutDialog(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(icLogout, width: 30),
              const SizedBox(width: 8),
              const Text('Logout', style: TextStyle(fontFamily: regular, fontSize: 16, color: greyDark1))
                  .text
                  .color(greyDark1)
                  .fontFamily(regular)
                  .make(),
            ],
          ),
        ).box.color(thinGrey01).rounded.margin(const EdgeInsets.symmetric(horizontal: 12, vertical: 8)).padding(const EdgeInsets.symmetric(horizontal: 8)).make(),
      ],
    );
  }

 void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return Dialog(
        backgroundColor: whiteColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            45.heightBox,
            const Text('Are you sure to logout?').text.size(16).fontFamily(regular).make(),
            45.heightBox,
            const Divider(height: 1,color: greyColor,),
            IntrinsicHeight( 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded( 
                    child: TextButton(
                      child: const Text('Cancel', style: TextStyle(fontFamily: regular, fontSize: 18, color: redColor)),
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
                  ),
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: greyColor,
                  ),
                  Expanded( 
                    child: TextButton(
                      child: const Text('Logout', style: TextStyle(fontFamily: regular, color: greyDark1, fontSize: 18)),
                      onPressed: () async {
                        await Get.put(AuthController()).signoutMethod(context);
                        Navigator.of(dialogContext).pop(); 
                        Get.offAll(() => const LoginScreen()); 
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}


  void handleProfileNavigation(int index, BuildContext context, dynamic data, profileCtrl.ProfileController controller) {
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
  }
}
