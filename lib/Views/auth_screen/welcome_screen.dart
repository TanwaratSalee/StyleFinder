import 'package:flutter_finalproject/Views/auth_screen/login_screen.dart';
import 'package:flutter_finalproject/Views/auth_screen/register_screen.dart';
import 'package:flutter_finalproject/Views/news_screen/text.dart';
import 'package:flutter_finalproject/Views/widgets_common/tapButton.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  var isloading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Image.asset(
              imgFirstpage,
              height: 300,
            ),
            SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                5.widthBox,
                Text(
                  'StyleFinder',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: primaryApp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                'Start discovering your favorite everyday fashion. The fashion e-commerce platform with a variety of brands. Shop now!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: greyColor,
                ),
              ),
            ),
            SizedBox(height: 30),
            tapButton(
              color: primaryApp,
              title: 'Login',
              textColor: whiteColor,
              onPress: () async {
                isloading(true);
                await Get.to(() => LoginScreen());
              },
            ).box.margin(EdgeInsets.symmetric(horizontal: 30)).make(),
            SizedBox(height: 15),
            tapButton(
              // borderColor: greyColor,
              color: whiteColor,
              title: 'Register',
              textColor: blackColor,
              onPress: () async {
                isloading(true);
                await Get.to(() => RegisterScreen());
              },
            ).box.margin(EdgeInsets.symmetric(horizontal: 30)).make(),
            
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                
              },
              child: Text(
                'Continue as a guest',
                style: TextStyle(fontSize: 16, color: greyDark),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
