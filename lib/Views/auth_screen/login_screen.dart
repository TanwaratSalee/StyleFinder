import 'package:flutter_finalproject/Views/auth_screen/forgot_screen.dart';
import 'package:flutter_finalproject/Views/auth_screen/register_screen.dart';
import 'package:flutter_finalproject/Views/home_screen/mainHome.dart';
import 'package:flutter_finalproject/Views/widgets_common/custom_textfield.dart';
import 'package:flutter_finalproject/Views/widgets_common/tapButton.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/consts/lists.dart';
import 'package:flutter_finalproject/controllers/auth_controller.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  imglogin,
                  height: 180,
                ),
                SizedBox(height: 20),
                const Text(login).text.size(28).fontFamily(bold).make(),
                SizedBox(height: 20),
                customTextField(
                  label: email,
                  isPass: false,
                  readOnly: false,
                  controller: controller.emailController,
                ),
                const SizedBox(height: 15),
                customTextField(
                  label: password,
                  isPass: true,
                  readOnly: false,
                  controller: controller.passwordController,
                ),
                // ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: forgotPass.text.color(blackColor).make(),
                    onPressed: () {
                      Get.to(() => ForgotScreen());
                    },
                  ),
                ),
                controller.isloading.value
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(primaryApp),
                      )
                    : tapButton(
                        color: primaryApp,
                        title: 'Sign in',
                        textColor: whiteColor,
                        onPress: () async {
                          controller.isloading(true);
                          await controller
                              .loginMethod(context: context)
                              .then((value) {
                            if (value != null) {
                              Get.to(() => MainHome());
                            } else {
                              controller.isloading(false);
                            }
                          });
                        },
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
                                height: 20,
                              ),
                              SizedBox(width: 10),
                              Text('Sign in with Google'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don’t have an account?",
                      style: TextStyle(
                        color: blackColor,
                        fontSize: 14,
                        fontFamily: regular,
                      ),
                    ),
                    TextButton(
                      child: Text(
                        'Register Now',
                        style: TextStyle(
                          color: primaryApp,
                          fontSize: 14,
                          fontFamily: bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
