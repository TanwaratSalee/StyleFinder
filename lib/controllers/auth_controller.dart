import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_finalproject/Views/auth_screen/login_screen.dart';
import 'package:flutter_finalproject/Views/auth_screen/personal_details_screen_google.dart';
import 'package:flutter_finalproject/Views/auth_screen/verifyemail_screen.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import '../Views/home_screen/mainHome.dart';

class AuthController extends GetxController {
  var isloading = false.obs;
  DateTime selectedDate = DateTime.now();
  String? selectedSex;
  Color? selectedSkinTone;
  bool canSelectSkin = true;

  //textcontrollers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var heightController = TextEditingController();
  var weightController = TextEditingController();

  var isLoading = false.obs;

  //login method
  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;

    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      print("Login successful: $userCredential");
      VxToast.show(context, msg: "Login successful");
    } on FirebaseAuthException catch (e) {
      print("Login failed: $e");
      VxToast.show(context, msg: "Login failed: $e", bgColor: Colors.red);
    }

    return userCredential;
  }

  //signup method
  Future<UserCredential?> signupMethod({email, password, context}) async {
    UserCredential? userCredential;

    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      VxToast.show(context, msg: "Signup successful");
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: "Signup failed: $e", bgColor: blackColor);
    }
    return userCredential;
  }

  bool validateUserData() {
    if (selectedDate == null ||
        selectedSex == null ||
        selectedSkinTone == null) {
      return false;
    }
    if (heightController.text.isEmpty || weightController.text.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> saveUserData({
    required String name,
    required String email,
    required String password,
    required DateTime birthday,
    required String gender,
    required String uHeight,
    required String uWeight,
    required Color skin,
  }) async {
    isloading(true);
    try {
      final UserCredential currentUser =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String formattedDateWithDay =
          DateFormat('EEEE, dd/MM/yyyy').format(birthday);

      await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(currentUser.user!.uid)
          .set({
        'email': email,
        'name': name,
        'imageUrl': '',
        'id': currentUser.user!.uid,
        'birthday': formattedDateWithDay,
        'gender': gender,
        'height': uHeight,
        'weight': uWeight,
        'skinTone': skin.value,
        'cart_count': "0",
        'wishlist_count': "0",
        'order_count': "0"
      });

      VxToast.show(Get.context!, msg: 'User data saved successfully!');

      Get.offAll(() => VerifyEmailScreen(
            email: email,
            name: name,
            password: password,
          ));
    } catch (e) {
      print("Failed to upload user data: $e");
      VxToast.show(Get.context!, msg: 'Failed to upload user data: $e');
    } finally {
      isloading(false);
    }
  }

  Future<void> saveUserDataGoogle({
    required UserCredential currentUser,
    required String name,
    required DateTime birthday,
    required String gender,
    required String uHeight,
    required String uWeight,
    required Color skin,
  }) async {
    try {
      String formattedDateWithDay =
          DateFormat('EEEE, dd/MM/yyyy').format(birthday);

      await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(currentUser.user!.uid)
          .set({
        'email': currentUser.user!.email,
        'name': name,
        'imageUrl': currentUser.user!.photoURL ?? '',
        'id': currentUser.user!.uid,
        'birthday': formattedDateWithDay,
        'gender': gender,
        'height': uHeight,
        'weight': uWeight,
        'skinTone': skin.value,
        'cart_count': "0",
        'wishlist_count': "0",
        'order_count': "0"
      });

      VxToast.show(Get.context!, msg: 'User data saved successfully!');
      Get.offAll(() => MainHome());
    } catch (e) {
      print("Failed to upload user data: $e");
      VxToast.show(Get.context!, msg: 'Failed to upload user data: $e');
    }
  }

  Future<void> sendPasswordResetEmail(
      String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      VxToast.show(context, msg: 'Password reset email has been sent.');
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: 'Error: ${e.message}', bgColor: Colors.red);
    }
  }

  //Signout method
  signoutMethod(context) async {
    print('Starting to logout...');
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
      VxToast.show(context, msg: 'Logout successful');
      print('Navigated to LoginScreen');
    } catch (e) {
      print('Logout error: $e');
      VxToast.show(context, msg: 'Logout error: $e', bgColor: Colors.red);
    }
  }

Future<void> signInWithGoogle(BuildContext context) async {
  isLoading(true);
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    final String email = userCredential.user?.email ?? "No Email";
    final String name = userCredential.user?.displayName ?? "No Name";
    final String uid = userCredential.user?.uid ?? "";

    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      final String gender = userDoc['gender'] ?? '';
      if (gender.isEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PersonalDetailsScreenGoogle(
              email: email,
              name: name,
              password: "Not Available",
              userCredential: userCredential,
            ),
          ),
        );
      } else {
        Get.offAll(() => MainHome());
        VxToast.show(context, msg: 'Login with Google successful');
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PersonalDetailsScreenGoogle(
            email: email,
            name: name,
            password: "Not Available",
            userCredential: userCredential,
          ),
        ),
      );
    }
  } catch (e) {
    print("Error signing in with Google: $e");
    VxToast.show(context,
        msg: 'Error signing in with Google: $e', bgColor: Colors.red);
  } finally {
    isLoading(false);
  }
}


  // Login with Facebook
  Future<void> signInWithFacebook() async {
    isLoading(true);
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      if (loginResult.accessToken != null) {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        Get.offAll(() => MainHome());
        VxToast.show(Get.context!, msg: 'Login with Facebook successful');
      } else {
        print('Error: Access token is null');
        VxToast.show(Get.context!,
            msg: 'Error: Access token is null', bgColor: Colors.red);
      }
    } catch (e) {
      print("Error signing in with Facebook: $e");
      VxToast.show(Get.context!,
          msg: 'Error signing in with Facebook: $e', bgColor: Colors.red);
    } finally {
      isLoading(false);
    }
  }

  // Custom Dialog Display
  Future<void> showCustomDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(height: 50),
                Image.asset(imgPopup),
                SizedBox(height: 40),
                Text(
                  'Check your email to reset your password!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password cannot be empty.';
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Password must contain at least one lowercase letter.';
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password must contain at least one uppercase letter.';
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must contain at least one digit.';
    }
    if (!RegExp(r'[@#$%^&+=!]').hasMatch(password)) {
      return 'Password must contain at least one special character. eg @#\$%^&+=!';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters long.';
    }
    return null;
  }
}
