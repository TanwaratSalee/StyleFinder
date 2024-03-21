// ignore_for_file: use_build_context_synchronously
import 'package:flutter_finalproject/Views/widgets_common/custom_textfield.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

void validateAndSubmit() {
    Get.dialog(
      AlertDialog(
        title: Text("Missing Information"),
        content: Text("Please fill out all the fields."),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Get.back(); // ปิด dialog
            },
          ),
        ],
      ),
    );
    return; // หยุดการทำงานของฟังก์ชันเพื่อไม่ให้ดำเนินการต่อหากข้อมูลไม่ครบ
  }

  // โค้ดสำหรับบันทึกข้อมูลหากข้อมูลครบถ้วน
  // saveDataToFirebase();



class _SignupScreenState extends State<SignupScreen> {
  bool? isCheck = false;
  var controller = Get.put(AuthController());

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Create Account'),
      ),
      backgroundColor: whiteColor,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Obx(() => Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              customTextField(
                  label: username, controller: nameController, isPass: false, readOnly: false,),
              const SizedBox(height: 3),
              customTextField(
                  label: email, controller: emailController, isPass: false, readOnly: false,),
              const SizedBox(height: 3),
              customTextField(
                  label: password, controller: passwordController, isPass: true, readOnly: false,),
              const SizedBox(height: 3),
              customTextField(
                  label: confirmPassword, controller: passwordRetypeController, isPass: true, readOnly: false,),
              const SizedBox(height: 10),

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: Checkbox(
                      activeColor: primaryApp,
                      checkColor: whiteColor,
                      value: isCheck,
                      onChanged: (bool? newValue) {
                        setState(() {
                          isCheck = newValue;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                      child: RichText(
                          text: const TextSpan(children: [
                    TextSpan(
                        text: "I agree to the ",
                        style: TextStyle(
                          color: fontGreyDark,
                          fontFamily: bold
                        )),
                    TextSpan(
                        text: termAndCond,
                        style: TextStyle(
                          color: primaryApp,
                          fontFamily: bold
                        )),
                    TextSpan(
                        text: " & ",
                        style: TextStyle(
                          color: fontGreyDark,
                          fontWeight: FontWeight.bold,
                        )),
                    TextSpan(
                        text: privacyPolicy,
                        style: TextStyle(
                          color: primaryApp,
                          fontWeight: FontWeight.bold,
                        ))
                  ])))
                ],
              ),
              // const SizedBox(height: 5),
              controller.isloading.value
              ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(primaryApp),) : 
                ourButton(
                color: isCheck == true ? primaryApp : fontGrey,
                title: 'Next',
                textColor: whiteColor,
                onPress: () async {
                  if (isCheck != false) {
                    controller.isloading(true);
                    try {
                      await controller.signupMethod(
                        context: context, email: emailController.text, password: passwordController.text
                      ).then((value) {
                        return controller.storeUserData(name: nameController.text, email: emailController.text, password: passwordController.text);
                      }).then((value) {
                        VxToast. show(context, msg: successfully);
                        Get.offAll(() => DetailUserScreen());
                      });
                    } catch (e) {
                      auth.signOut();
                      VxToast.show(context, msg: e.toString());
                      controller.isloading(false);
                    }
                  }
                },
              ),
              //.box.width(context.screenWidth - 50).make(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailUserScreen {
}

