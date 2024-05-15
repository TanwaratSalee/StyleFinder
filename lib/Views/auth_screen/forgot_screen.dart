import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_finalproject/Views/auth_screen/login_screen.dart';
import 'package:flutter_finalproject/Views/widgets_common/custom_textfield.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';

class ForgotScreen extends StatelessWidget {
  ForgotScreen({super.key});

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
          // title: Text('Forgot Password?'),
          ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: const Text('Forgot Password?')
                  .text
                  .size(26)
                  .fontFamily(bold)
                  .color(greyDark2)
                  .make(),
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                      'Don\'t worry! It occurs. Please enter the email address linked with your account.')
                  .text
                  .size(14)
                  .fontFamily(regular)
                  .color(greyDark2)
                  .make(),
            ),
            const SizedBox(height: 20),
            customTextField(
              label: 'Enter your email',
              isPass: false,
              readOnly: false,
              controller: _emailController,
            ),
            const SizedBox(height: 20),
            ourButton(
              title: 'Send Code',
              color: primaryApp,
              textColor: whiteColor,
              onPress: () {
                _sendPasswordResetEmail(context);
                popupForgotPassword(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendPasswordResetEmail(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      VxToast.show(context,
          msg:
              "Sent a reset password has been sent to ${_emailController.text}");
      VxToast.show(context,
          msg: "Reset password sent in your E-mail ${_emailController.text}");
    } catch (e) {
      VxToast.show(context, msg: "$e");
    }
  }
}

Future<void> popupForgotPassword(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Theme(
        data: ThemeData(
          dialogBackgroundColor: whiteColor,
        ),
        child: AlertDialog(
          backgroundColor: whiteColor,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        imgPopup,
                        width: 220,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        'Check your email to reset your password!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: medium,
                          color: greyDark2,
                          fontSize: 20,
                        ),
                      ),
                      20.heightBox,
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Get.to(LoginScreen());
                        },
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            fontFamily: medium,
                            fontSize: 16,
                            color: whiteColor,
                          ),
                        ),
                      ).box.width(context.screenWidth).roundedSM.margin(EdgeInsets.symmetric(horizontal: 10)).color(primaryApp).make(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
