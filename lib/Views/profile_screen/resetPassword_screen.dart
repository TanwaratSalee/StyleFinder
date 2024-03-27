// password_screen.dart
// ignore_for_file: use_build_context_synchronously, use_super_parameters, file_names

import 'package:flutter_finalproject/Views/widgets_common/custom_textfield.dart';
import 'package:get/get.dart';
import 'package:flutter_finalproject/controllers/profile_controller.dart';
import 'package:flutter_finalproject/consts/consts.dart'; // Ensure this file exists and contains your constants

class PasswordScreen extends StatelessWidget {
  final oldpassController = TextEditingController();
  final newpassController = TextEditingController();

  PasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: whiteColor, // Ensure this constant is defined
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Edit Profile",
            style: TextStyle(fontFamily: 'Regular', color: Colors.black)),
        actions: [
          Obx(() {
            if (controller.isloading.isTrue) {
              return const CircularProgressIndicator().p16();
            }
            return TextButton(
              onPressed: () async {
                controller.isloading(true);

                final result = await controller.changeAuthPassword(
                  oldPassword: oldpassController.text,
                  newPassword: newpassController.text,
                );

                if (result) {
                  VxToast.show(context, msg: "Password updated successfully");
                } else {
                  VxToast.show(context, msg: "Failed to update password");
                }

                controller.isloading(false);
              },
              child: "Save".text.color(Colors.blue).make(),
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            customTextField(
              label: "Old Password",
              controller: oldpassController,
              isPass: true,
              readOnly: false,
            ).p16(),

            customTextField(
              label: "New Password",
              controller: newpassController,
              isPass: true,
              readOnly: false,
            ).p16(),

            // Add other widgets as needed
          ],
        ),
      ),
    );
  }
}
