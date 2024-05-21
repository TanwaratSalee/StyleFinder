import 'package:flutter_finalproject/Views/auth_screen/forgot_screen.dart';
import 'package:flutter_finalproject/Views/auth_screen/signup_screen.dart';
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                bgLogin,
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: [
                        const Text('Log In',
                            style: TextStyle(fontSize: 36, fontFamily: bold)),
                        SizedBox(height: 16),
                        customTextField(
                          label: 'Email',
                          isPass: false,
                          readOnly: false,
                          controller: controller.emailController,
                        ),
                        const SizedBox(height: 15),
                        customTextField(
                          label: 'Password',
                          isPass: true,
                          readOnly: false,
                          controller: controller.passwordController,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            child: forgotPass.text.color(blackColor).make(),
                            onPressed: () {
                              Get.to(() => ForgotScreen());
                            },
                          ),
                        ),
                        SizedBox(height: 16),
                        controller.isloading.value
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(primaryApp),
                              )
                            : tapButton(
                                color: primaryApp,
                                title: 'Login',
                                textColor: whiteColor,
                                onPress: () async {
                                  controller.isloading(true);

                                  await controller
                                      .loginMethod(context: context)
                                      .then((value) {
                                    if (value != null) {
                                      VxToast.show(context, msg: successfully);
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: greyLine,
                                      width: 1,
                                    ),
                                  ),
                                  child: Image.asset(
                                    socialIconList[index],
                                    width: 80,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                        .box
                        .white
                        .padding(EdgeInsets.symmetric(
                            horizontal: 24, vertical: 18))
                        .margin(EdgeInsets.symmetric(horizontal: 24))
                        .rounded
                        .make(),
                        20.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don’t have an account? ",
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 16,
                            fontFamily: bold,
                          ),
                        ),
                        TextButton(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: primaryApp,
                              fontSize: 16,
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
          ],
        ),
      ),
    );
  }
}
