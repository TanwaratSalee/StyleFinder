import 'package:flutter_finalproject/Views/widgets_common/search_icon.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';

import '../cart_screen/cart_screen.dart';
import '../search_screen/search_screen.dart';

Widget appbarField({required BuildContext context}) { // Specify context as required
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      IconSearch(context: context),
      Center(
        child: Image.asset(icLogoOnTop, height: 40),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: IconButton(
          icon: Image.asset(
            icCart,
            width: 21,
          ),
          onPressed: () {
            Get.to(() => const CartScreen());
          },
        ),
      ),
    ],
  ).box.white.make();
}
