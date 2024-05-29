import 'package:flutter_finalproject/Views/widgets_common/custom_textfield.dart';
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
        actions: [
          Obx(() {
            if (controller.isloading.isTrue) {
              return const CircularProgressIndicator().p16();
            }
            return TextButton(
              onPressed: () async {
                // ตรวจสอบว่า New Password กับ Confirm New Password ตรงกันหรือไม่
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
                  // แสดงข้อความแจ้งเตือนหากรหัสผ่านใหม่และการยืนยันไม่ตรงกัน
                  VxToast.show(context,
                      msg: "New password and confirmation do not match");
                }
              },
              child: "Save".text.color(Colors.blue).make(),
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
          child: Column(
            children: [
              customTextField(
                label: "Old Password",
                controller: oldpassController,
                isPass: true,
                readOnly: false,
              ).p2(),
              const SizedBox(height: 15),
              customTextField(
                label: "New Password",
                controller: newpassController,
                isPass: true,
                readOnly: false,
              ).p2(),
              customTextField(
                label:
                    "Confirm New Password", // เพิ่ม TextField สำหรับการยืนยันรหัสผ่านใหม่
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
