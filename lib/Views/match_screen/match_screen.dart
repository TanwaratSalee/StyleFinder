import 'package:flutter_finalproject/Views/auth_screen/login_screen.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/auth_controller.dart';
import 'package:get/get.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: () async {
          await Get.put(AuthController()).signoutMethod(context);
          Get.offAll(() => const LoginScreen());
        },
        child: logout.text.fontFamily(regular).black.make());
  }
}
