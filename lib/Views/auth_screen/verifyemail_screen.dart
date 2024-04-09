import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/auth_screen/login_screen.dart';
import 'package:flutter_finalproject/Views/auth_screen/personal_details_screen.dart';
import 'package:flutter_finalproject/Views/home_screen/mainHome.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  final String name;
  final String password;

  VerifyEmailScreen({
    Key? key,
    required this.email,
    required this.name,
    required this.password,
  }) : super(key: key);

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  var controller = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    sendVerificationEmail();
    setTimerForAutoRedirect();
  }

  bool validateInput() {
    if (widget.email.isNotEmpty && widget.name.isNotEmpty && widget.password.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

Future<void> sendVerificationEmail() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null && !user.emailVerified) {
    try {
      await user.sendEmailVerification();
      print("Email verification link has been sent.");
    } catch (e) {
      print("An error occurred while sending email verification: $e");
    }
  } else {
    print("No user logged in or email already verified.");
  }
}


void setTimerForAutoRedirect() {
  Timer.periodic(
    const Duration(seconds: 1),
    (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      var user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        Get.offAll(() => MainHome());
      }
    },
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(
              Icons.email_outlined,
              size: 100,
              color: Color.fromRGBO(53, 194, 193, 1),
            ),
            SizedBox(height: 50),
            Text(
              'Verify your email address',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'We have just sent an email verification link to your email. Please check your email and click on the link to verify your Email address.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'If not auto redirected after verification, click on the Continue button.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text('Continue', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                var user = FirebaseAuth.instance.currentUser;
                await user?.reload();
                user = FirebaseAuth.instance.currentUser;

                if (user != null && user.emailVerified) {
                  Get.offAll(() => MainHome());
                } else {
                  Get.snackbar('Verification Required', 'Please verify your email first.', snackPosition: SnackPosition.BOTTOM);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(53, 194, 193, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
              foregroundColor: Color.fromRGBO(53, 194, 193, 1),
              ),
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null && !user.emailVerified) {
                  await user.sendEmailVerification();
                }
              },
              child: Text('Resend Email Link'),
            ),
            TextButton(
              style: TextButton.styleFrom(
              foregroundColor: Color.fromRGBO(53, 194, 193, 1),
              ),
              onPressed: () {
                Get.offAll(() => LoginScreen());
              },
              child: Text('← back to login'),
            ),
          ],
        ),
      ),
    );
  }
}
