import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/widgets_common/custom_textfield.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:flutter_finalproject/consts/consts.dart';

class ForgotScreen extends StatelessWidget {
  const ForgotScreen({super.key});

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
                  .color(greyDarkColor)
                  .make(),
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text('Don\'t worry! It occurs. Please enter the email address linked with your account.')
                  .text
                  .size(14)
                  .fontFamily(regular)
                  .color(greyDarkColor)
                  .make(),
            ),
            const SizedBox(height: 20),
            customTextField(
              label: 'Enter your email',
              isPass: false,
              readOnly: false,),
            const SizedBox(height: 20),
            ourButton(
                    title: 'Send Code',
                    color: primaryApp,
                    textColor: whiteColor,
                    onPress: () {},
                  ),
          ],
        ),
      ),
    );
  }
}