import 'package:flutter_finalproject/Views/search_screen/recent_search_screen.dart';
import 'package:flutter_finalproject/Views/store_screen/search_screen.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';

import '../cart_screen/cart_screen.dart';

Widget appbarField({required BuildContext context}) {
  // Specify context as required
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreenPage()),
            );
          },
          child: Row(
            children: [
              Icon(Icons.search, color: greyDark, size: 30,),
            ],
          )),
      Center(
        child: Image.asset(icLogoOnTop, height: 35),
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
  );
}
