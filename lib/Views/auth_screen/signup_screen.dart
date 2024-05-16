import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:get/get.dart';
import 'package:flutter_finalproject/controllers/auth_controller.dart';
import 'package:flutter_finalproject/views/auth_screen/personal_details_screen.dart';
import 'package:flutter_finalproject/views/widgets_common/custom_textfield.dart';
import 'package:flutter_finalproject/consts/consts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var controller = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordRetypeController =
      TextEditingController();

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return "";
    return text[0].toUpperCase() + text.substring(1);
  }

  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
          title: const Text('Create Account')
              .text
              .size(24)
              .fontFamily(medium)
              .make()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            customTextField(
              label: capitalizeFirstLetter(fullname),
              controller: nameController,
              isPass: false,
              readOnly: false,
            ),
            const SizedBox(height: 3),
            customTextField(
              label: email,
              controller: emailController,
              isPass: false,
              readOnly: false,
            ),
            const SizedBox(height: 3),
            customTextField(
              label: password,
              controller: passwordController,
              isPass: true,
              readOnly: false,
            ),
            const SizedBox(height: 3),
            customTextField(
              label: confirmPassword,
              controller: passwordRetypeController,
              isPass: true,
              readOnly: false,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                  Checkbox(
                    activeColor: primaryApp,
                    checkColor: whiteColor,
                    value: isCheck,
                    onChanged: (bool? newValue) {
                      setState(() {
                        isCheck = newValue ?? false;
                      });
                    },
                  ),
                Expanded(
                    child: RichText(
                        text: const TextSpan(children: [
                  TextSpan(
                      text: iAgree,
                      style: TextStyle(color: greyDark2, fontFamily: medium,fontSize: 15)),
                  TextSpan(
                      text: termAndCond,
                      style: TextStyle(color: primaryApp, fontFamily: medium,fontSize: 15)),
                  TextSpan(
                      text: " & ",
                      style: TextStyle(
                        color: greyDark2,
                        fontFamily: medium,
                        fontSize: 15,
                      )),
                  TextSpan(
                      text: privacyPolicy,
                      style: TextStyle(
                        color: primaryApp,
                        fontFamily: medium,
                        fontSize: 15,
                      ))
                ])))
              ],
            ),
            controller.isloading.value
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(primaryApp),
                  )
                : tapButton(
                    // Button widget
                    color: isCheck == true ? primaryApp : greyDark1,
                    title: 'Next',
                    textColor: whiteColor,
                    onPress: isCheck
                        ? () {
                            // Validate input before changing the screen
                            if (validateInput()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PersonalDetailsScreen(
                                    email: emailController.text,
                                    name: nameController.text,
                                    password: passwordController.text,
                                  ),
                                ),
                              );
                            }
                          }
                        : null,
                  ),
          ],
        ),
      ),
    );
  }

  bool validateInput() {
    String? passwordError =
        controller.validatePassword(passwordController.text);
    bool isValid = emailController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        passwordRetypeController.text.isNotEmpty &&
        passwordRetypeController.text == passwordController.text &&
        passwordError == null;

    if (!isValid) {
      if (emailController.text.isEmpty ||
          nameController.text.isEmpty ||
          passwordController.text.isEmpty ||
          passwordRetypeController.text.isEmpty) {
        VxToast.show(context, msg: 'Please fill in all fields.');
      } else if (passwordController.text != passwordRetypeController.text) {
        VxToast.show(context, msg: "Passwords don't match.");
      } else if (passwordError != null) {
        VxToast.show(context, msg: passwordError);
      } else {
        VxToast.show(context, msg: 'Please check your input.');
      }
    }

    return isValid;
  }
}
