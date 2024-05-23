import 'package:flutter_finalproject/Views/auth_screen/login_screen.dart';
import 'package:flutter_finalproject/Views/auth_screen/termAndConditions.dart';
import 'package:flutter_finalproject/Views/auth_screen/privacyPolicy.dart';
import 'package:flutter_finalproject/Views/widgets_common/custom_textfield.dart';
import 'package:flutter_finalproject/Views/widgets_common/tapButton.dart';
import 'package:flutter_finalproject/consts/lists.dart';
import 'package:get/get.dart';
import 'package:flutter_finalproject/controllers/auth_controller.dart';
import 'package:flutter_finalproject/views/auth_screen/personal_details_screen.dart';
import 'package:flutter_finalproject/consts/consts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              imgregister,
              height: 180,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  Text('Hello! Register to get started')
                      .text
                      .size(28)
                      .fontFamily(bold)
                      .make(),
                  8.heightBox,
                  customTextField(
                    label: capitalizeFirstLetter(fullname),
                    controller: nameController,
                    isPass: false,
                    readOnly: false,
                  ),
                  const SizedBox(height: 10),
                  customTextField(
                    label: email,
                    controller: emailController,
                    isPass: false,
                    readOnly: false,
                  ),
                  const SizedBox(height: 10),
                  customTextField(
                    label: password,
                    controller: passwordController,
                    isPass: true,
                    readOnly: false,
                  ),
                  const SizedBox(height: 10),
                  customTextField(
                    label: confirmPassword,
                    controller: passwordRetypeController,
                    isPass: true,
                    readOnly: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
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
                          text: TextSpan(children: [
                            TextSpan(
                                text: iAgree,
                                style: TextStyle(
                                    color: blackColor,
                                    fontFamily: regular,
                                    fontSize: 13)),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => TermAndConditions());
                                },
                                child: Text(termAndCond,
                                    style: TextStyle(
                                        color: primaryApp,
                                        fontFamily: medium,
                                        fontSize: 13)),
                              ),
                            ),
                            TextSpan(
                                text: " & ",
                                style: TextStyle(
                                  color: blackColor,
                                  fontFamily: regular,
                                  fontSize: 13,
                                )),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => PrivacyPolicySceen());
                                },
                                child: Text(privacyPolicy,
                                    style: TextStyle(
                                        color: primaryApp,
                                        fontFamily: medium,
                                        fontSize: 13)),
                              ),
                            ),
                          ]),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  controller.isloading.value
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(primaryApp),
                        )
                      : tapButton(
                          // Button widget
                          color: primaryApp,
                          title: 'Register',
                          textColor: whiteColor,
                          onPress: isCheck
                              ? () {
                                  if (validateInput()) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PersonalDetailsScreen(
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
                  SizedBox(height: 15),
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(color: greyLine, height: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: loginWith.text.color(greyColor).make(),
                      ),
                      const Expanded(
                        child: Divider(color: greyLine, height: 1),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      socialIconList.length,
                      (index) => Expanded(
                        child: GestureDetector(
                          onTap: () {
                            switch (index) {
                              case 0:
                                controller.signInWithGoogle(context);
                                break;
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: greyLine,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  socialIconList[index],
                                  height: 24,
                                ),
                                SizedBox(width: 10),
                                Text('Register with Google'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account? ",
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 14,
                    fontFamily: regular,
                  ),
                ),
                TextButton(
                  child: const Text(
                    'Login Now',
                    style: TextStyle(
                      color: primaryApp,
                      fontSize: 14,
                      fontFamily: bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                ),
              ],
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
