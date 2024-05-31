import 'package:flutter_finalproject/Views/widgets_common/custom_textfield.dart';
import 'package:flutter_finalproject/Views/widgets_common/tapButton.dart';
import 'package:get/get.dart';
import 'package:flutter_finalproject/controllers/profile_controller.dart';
import 'package:flutter_finalproject/consts/consts.dart';

class PasswordScreen extends StatelessWidget {
  final oldpassController = TextEditingController();
  final newpassController = TextEditingController();
  final confirmNewPassController = TextEditingController();

  PasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: whiteColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Reset Password",
           ).text
            .size(26)
            .fontFamily(semiBold)
            .color(blackColor)
            .make(),
       
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 35),
        child: SizedBox(
          height: 50,
          child: tapButton(
            onPress: () async {
                // ตรวจสอบว่า New Password กับ Confirm New Password 
                if (newpassController.text == confirmNewPassController.text) {
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
                } else {
                  VxToast.show(context,
                      msg: "New password and confirmation do not match");
                }
              },
            color: primaryApp,
            textColor: whiteColor,
            title: "Save",
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            children: [
              15.heightBox,
              customTextField(
                label: "Old Password",
                controller: oldpassController,
                isPass: true,
                readOnly: false,
              ).p2(),
              25.heightBox,
              customTextField(
                label: "New Password",
                controller: newpassController,
                isPass: true,
                readOnly: false,
              ).p2(),
              5.heightBox,
              customTextField(
                label:"Confirm New Password",
                controller: confirmNewPassController,
                isPass: true,
                readOnly: false,
              ).p2(),
              15.heightBox,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '- Password must be at least 8 characters long.\n'
                  '- Password must include at least one lowercase letter.\n'
                  '- Password must include an uppercase letter.\n'
                  '- Password must include a digit.\n'
                  '- Password must include a special characte. (e.g., @#\$%^&+=!).\n',
                  style: TextStyle(
                    fontFamily: regular,
                    fontSize: 12,
                    color: greyDark,
                    height: 1.5,
                  ),
                ),
              ).box.padding(EdgeInsets.only(left: 15)).make()
            ],
          ),
        ),
      ),
    );
  }
}
