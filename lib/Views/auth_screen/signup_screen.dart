import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/auth_screen/detail_user_screen.dart';
import 'package:flutter_finalproject/Views/widgets_common/custom_textfield.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/consts/strings.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../consts/styles.dart';
import '../../controllers/auth_controller.dart';

// ... You need to define the customTextField and OurButton widgets as per your design ...

class AccountCreationScreen extends StatefulWidget {
  const AccountCreationScreen({Key? key}) : super(key: key);

  @override
  _AccountCreationScreenState createState() => _AccountCreationScreenState();
}

class _AccountCreationScreenState extends State<AccountCreationScreen> {
   var controller = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordRetypeController = TextEditingController();

  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            customTextField(
                    label: fullname,
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
            SizedBox(height: 20),

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
                      isCheck = newValue ?? false;
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
                                color: fontGreyDark, fontFamily: bold)),
                        TextSpan(
                            text: termAndCond,
                            style:
                                TextStyle(color: primaryApp, fontFamily: bold)),
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
             controller.isloading.value
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(primaryApp),
                        )
                      : ourButton(
                        color: isCheck == true ? primaryApp : fontGrey,
              title: 'Next',
              textColor: whiteColor,
              onPress: () {
                // Implement validation before navigating
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
