import 'package:flutter_finalproject/Views/auth_screen/termAndConditions.dart';
import 'package:flutter_finalproject/Views/auth_screen/privacyPolicy.dart';
import 'package:flutter_finalproject/Views/widgets_common/tapButton.dart';
import 'package:get/get.dart';
import 'package:flutter_finalproject/controllers/auth_controller.dart';
import 'package:flutter_finalproject/views/auth_screen/personal_details_screen.dart';
import 'package:flutter_finalproject/views/widgets_common/custom_textfield.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          children: [
            Image.asset(
              imgregister,
              height: 200,
            ),
            10.heightBox,
            Text('Hello! Register to get started').text.size(28).fontFamily(bold).make(),
            5.heightBox,
            customTextField(
              label: capitalizeFirstLetter(fullname),
              controller: nameController,
              isPass: false,
              readOnly: false,
            ),
            const SizedBox(height: 15),
            customTextField(
              label: email,
              controller: emailController,
              isPass: false,
              readOnly: false,
            ),
            const SizedBox(height: 15),
            customTextField(
              label: password,
              controller: passwordController,
              isPass: true,
              readOnly: false,
            ),
            const SizedBox(height: 15),
            customTextField(
              label: confirmPassword,
              controller: passwordRetypeController,
              isPass: true,
              readOnly: false,
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                              fontSize: 14)),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => TermAndConditions());
                          },
                          child: Text(termAndCond,
                              style: TextStyle(
                                  color: primaryApp,
                                  fontFamily: medium,
                                  fontSize: 14)),
                        ),
                      ),
                      TextSpan(
                          text: " & ",
                          style: TextStyle(
                            color: blackColor,
                            fontFamily: regular,
                            fontSize: 14,
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
                                  fontSize: 14)),
                        ),
                      ),
                    ]),
                  ),
                )
              ],
            ),
            10.heightBox,
            controller.isloading.value
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(primaryApp),
                  )
                : tapButton(
                    // Button widget
                    color: isCheck == true ? primaryApp : greyDark,
                    title: 'Next',
                    textColor: whiteColor,
                    onPress: isCheck
                        ? () {
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
