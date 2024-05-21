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
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(bgLogin),
              fit: BoxFit.cover,
            ),
          ),
          child: Obx(
            () => Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('Log In',
                                        style: TextStyle(
                                            fontSize: 32, fontFamily: bold)),
                                    const SizedBox(height: 5),
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
                                        child: forgotPass.text
                                            .color(blackColor)
                                            .make(),
                                        onPressed: () {
                                          Get.to(() => ForgotScreen());
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    controller.isloading.value
                                        ? const CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                                primaryApp),
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
                                                  VxToast.show(context,
                                                      msg: successfully);
                                                  Get.to(() => MainHome());
                                                } else {
                                                  controller.isloading(false);
                                                }
                                              });
                                            },
                                          ),
                                    const SizedBox(height: 24),
                                    Row(
                                      children: [
                                        const Expanded(
                                          child: Divider(
                                              color: greyLine, height: 1),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: loginWith.text
                                              .color(greyColor)
                                              .make(),
                                        ),
                                        const Expanded(
                                          child: Divider(
                                              color: greyLine, height: 1),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceEvenly,
                                    //   children: List.generate(
                                    //       socialIconList.length,
                                    //       (index) => Container(
                                    //             padding:
                                    //                 const EdgeInsets.fromLTRB(
                                    //                     50, 15, 50, 15),
                                    //             decoration: BoxDecoration(
                                    //               borderRadius:
                                    //                   BorderRadius.circular(8),
                                    //               border: Border.all(
                                    //                 color: greyLine,
                                    //                 width: 1,
                                    //               ),
                                    //             ),
                                    //             child: Image.asset(
                                    //                 socialIconList[index],
                                    //                 width: 24,
                                    //                 height: 24),
                                    //           )),
                                    // ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: List.generate(
                                        socialIconList.length,
                                        (index) => Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              switch (index) {
                                                case 0:
                                                  controller.signInWithGoogle(
                                                      context);
                                                  break;
                                              }
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 15, 0, 15),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Don’t have an account? ",
                      ).text.color(whiteColor).size(16).fontFamily(bold).make(),
                      TextButton(
                        child: const Text(
                          'Sign Up',
                        ).text.color(primaryApp).size(16).fontFamily(bold).make(),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
