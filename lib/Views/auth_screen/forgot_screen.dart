import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_finalproject/Views/auth_screen/login_screen.dart';
import 'package:flutter_finalproject/Views/widgets_common/custom_textfield.dart';
import 'package:flutter_finalproject/Views/widgets_common/tapButton.dart';
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
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: const Text('Forgot Password?')
                  .text
                  .size(26)
                  .fontFamily(bold)
                  .color(blackColor)
                  .make(),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                      'Don\'t worry! It occurs. Please enter the email address linked with your account.')
                  .text
                  .size(14)
                  .fontFamily(regular)
                  .color(greyColor)
                  .make(),
            ),
            const SizedBox(height: 30),
            customTextField(
              label: 'Enter your email',
              isPass: false,
              readOnly: false,
              controller: _emailController,
            ),
            const SizedBox(height: 20),
            tapButton(
              title: 'Send Code',
              color: primaryApp,
              textColor: whiteColor,
              onPress: () {
                sendPasswordResetEmail(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendPasswordResetEmail(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      popupForgotPassword(context, _emailController.text.trim());
    } catch (e) {
      VxToast.show(context, msg: "$e");
    }
  }
}

Future<void> popupForgotPassword(BuildContext context, String email) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Image.asset(
                    imgPopupEmail,
                    width: 220,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Check your email to reset your password!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: medium,
                      color: blackColor, 
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Get.to(LoginScreen());
                    },
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        fontFamily: medium,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ).box.width(context.screenWidth).roundedSM.margin(const EdgeInsets.symmetric(horizontal: 10)).color(primaryApp).make(),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
