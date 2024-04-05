import 'package:flutter_finalproject/Views/auth_screen/forgot_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_finalproject/Views/auth_screen/signup_screen.dart';
import 'package:flutter_finalproject/Views/home_screen/mainHome.dart';
import 'package:flutter_finalproject/Views/widgets_common/custom_textfield.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/consts/lists.dart';
import 'package:flutter_finalproject/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
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
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 150),
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('Log In',
                                        style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 5),
                                    customTextField(
                                        label: email,
                                        isPass: false,
                                        readOnly: false,
                                        controller: controller.emailController),
                                    const SizedBox(height: 5),
                                    customTextField(
                                        label: password,
                                        isPass: true,
                                        readOnly: false,
                                        controller:
                                            controller.passwordController),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        child: forgotPass.text
                                            .color(fontBlack)
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
                                        : ourButton(
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
                                                  Get.offAll(() => MainHome());
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
                                              color: fontGrey, height: 1),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: loginWith.text
                                              .color(fontGreyDark)
                                              .make(),
                                        ),
                                        const Expanded(
                                          child: Divider(
                                              color: fontGrey, height: 1),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: List.generate(
                                          socialIconList.length,
                                          (index) => Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        50, 15, 50, 15),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: fontLightGrey,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Image.asset(
                                                    socialIconList[index],
                                                    width: 24,
                                                    height: 24),
                                              )),
                                    ),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: List.generate(
    socialIconList.length,
    (index) => GestureDetector(
      onTap: () {
        switch (index) {
          case 0: // Google
            signInWithGoogle();
            break;
          case 1: // Facebook
            signInWithFacebook();
            break;
          // เพิ่มเติมตามลำดับของไอคอนโซเชียลอื่น ๆ ตามต้องการได้เลย
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: fontLightGrey,
            width: 1,
          ),
        ),
        child: Image.asset(
          socialIconList[index],
          width: 24,
          height: 24,
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
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: regular,
                        color: Colors.white,
                      ),
                    ),
                    TextButton(
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: bold,
                          color: primaryApp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()),
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
    );
  }
  
Future<void> signInWithGoogle() async {
  try {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    // Navigate to MainHome() page
    Get.offAll(() => MainHome());
  } catch (e) {
    print("Error signing in with Google: $e");
    // Handle error
  }
}

Future<UserCredential?> signInWithFacebook() async {
  // Trigger the sign-in flow
  final LoginResult loginResult = await FacebookAuth.instance.login();

  // Check if loginResult.accessToken is not null
  if (loginResult.accessToken != null) {
    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  } else {
    // Handle the case when accessToken is null
    print('Error: Access token is null');
    return null; // or throw an error, depending on your requirement
  }
}


}