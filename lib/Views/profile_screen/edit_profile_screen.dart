// ignore_for_file: use_build_context_synchronously, use_super_parameters

import 'dart:io';

import 'package:flutter_finalproject/Views/widgets_common/custom_textfield.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/profile_controller.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  final dynamic data;

  const EditProfileScreen({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();
    controller.nameController.text = data['name'];
    controller.emailController.text = data['email'];
    controller.heightController.text = data['height'];
    controller.weightController.text = data['weight'];

    // controller.old Controller.text = data['pass'];

    return Scaffold(
      backgroundColor: whiteColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title:
            "Edit Profile".text.fontFamily(regular).color(fontGreyDark).make(),
        actions: [
          TextButton(
            onPressed: () async {
              if (controller.isloading.isTrue) {
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(primaryApp),
                );
              }
              controller.isloading(true);

              //if image is not selected
              if (controller.profileImgPath.value.isNotEmpty) {
                await controller.uploadProfileImage();
              } else {
                controller.profileImageLink = data['imageUrl'];
              }
            },
            child: "Save".text.color(primaryApp).fontFamily(regular).size(18).make(),
          ),
        ],
      ),
      body: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //if data image url and contoller path is empty
            data['imageUrl'] == '' && controller.profileImgPath.isEmpty
                ? Image.asset(
                    imProfile,
                    width: 100,
                    fit: BoxFit.cover,
                  ).box.roundedFull.clip(Clip.antiAlias).make()
                // if data is not empty but controller path is empty
                : data['imageUrl'] != '' && controller.profileImgPath.isEmpty
                    ? Image.network(
                        data['imageUrl'],
                        width: 130,
                        fit: BoxFit.cover,
                      ).box.roundedFull.clip(Clip.antiAlias).make()
                    //if both are emtpy
                    : Image.file(
                        File(controller.profileImgPath.value),
                        width: 130,
                        fit: BoxFit.cover,
                      ).box.roundedFull.clip(Clip.antiAlias).make(),
            // Image.asset(imProfile, width: 150,).box.roundedFull.clip(Clip.antiAlias).make(),

            10.heightBox,
            SizedBox(
                width: context.screenWidth - 260,
                height: context.screenWidth - 360,
                child: ourButton(
                    color: whiteColor,
                    onPress: () {
                      controller.changeImage(context);
                    },
                    textColor: primaryApp,
                    title: "Edit Picture")),
           
            10.heightBox,
            // const Divider(),
            20.heightBox,
            customTextField(
              controller: controller.nameController,
              label: fullname,
              isPass: false,
              readOnly: false,
            ),
            customTextField(
                controller: controller.emailController,
                label: email,
                isPass: false,
                readOnly: true),

            customTextField(
              controller: controller.heightController,
              label: 'Height',
              isPass: false,
              readOnly: false,
            ),    

            customTextField(
              controller: controller.heightController,
              label: 'Height',
              isPass: false,
              readOnly: false,
            ),

            customTextField(
                controller: controller.weightController,
                label: 'Weight',
                isPass: false,
                readOnly: true),    
            // customTextField(
            //     controller: controller.oldpassController,
            //     label: oldpass,
            //     isPass: true,
            //     readOnly: false),
            // customTextField(
            //     controller: controller.newpassController,
            //     label: newpass,
            //     isPass: true,
            //     readOnly: false),
            // 30.heightBox,

            // controller.isloading.value
            //     ? const CircularProgressIndicator(
            //         valueColor: AlwaysStoppedAnimation(primaryApp),
            //       )
            //     : SizedBox(
            //         width: context.screenWidth - 60,
            // child: ourButton(
            //     color: primaryApp,
            //     onPress: () async {
            //       controller.isloading(true);

            //       //if image is not selected
            //       if (controller.profileImgPath.value.isNotEmpty) {
            //         await controller.uploadProfileImage();
            //       } else {
            //         controller.profileImageLink = data['imageUrl'];
            //       }

            //       //if old password matches data
            //       // if(data['password'] == controller.oldpassController.text) {
            //       //   await controller.changeAuthPassword(
            //       //     email: data['email'],
            //       //     password: controller.oldpassController.text,
            //       //     newpassword: controller.newpassController.text
            //       //   );

            //       //   await controller.updateProfile(
            //       //     imgUrl: controller.profileImageLink,
            //       //     name: controller.nameController.text,
            //       //     password: controller.newpassController.text
            //       //   );
            //       // VxToast.show(context, msg: "Updates");
            //       // } else {
            //       // VxToast.show(context, msg: "Wrong old password");
            //       // controller.isloading(false);
            //       // }

            //       //if old password matches data
            //       if (data['password'] ==
            //           controller.oldpassController.text) {
            //         await controller.changeAuthPassword(
            //             email: data['email'],
            //             password: controller.oldpassController.text,
            //             newpassword: controller.newpassController.text);

            //         await controller.updateProfile(
            //             imgUrl: controller.profileImageLink,
            //             name: controller.nameController.text,
            //             password: controller.newpassController.text);
            //         VxToast.show(context, msg: "Updates");
            //       } else {
            //         VxToast.show(context, msg: "Wrong old password");
            //         controller.isloading(false);
            //       }
            //     },
            //     textColor: whiteColor,
            //     title: "Save"),
            // )
          ],
        ).paddingAll(16),
      ),
    );
  }
}
