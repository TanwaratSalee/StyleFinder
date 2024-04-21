import 'package:flutter_finalproject/Views/cart_screen/cart_screen.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';

class MatchProductScreen extends StatelessWidget {
  const MatchProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: whiteColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 20),
            Image.asset(icLogoOnTop, height: 40), // Logo on the left
            IconButton(
              // Cart icon on the right
              icon: Image.asset(icCart, width: 21),
              onPressed: () {
                Get.to(() => const CartScreen());
              },
            ),
          ],
        ),
      ),
      );
  }
}
