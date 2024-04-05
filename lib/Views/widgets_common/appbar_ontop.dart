import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';

import '../cart_screen/cart_screen.dart';
import '../search_screen/search_screen.dart';

Widget appbarField({context}) {
  return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: IconButton(
            icon: Image.asset(
              icSearch,
              width: 23,
            ),
            onPressed: () {
              showGeneralDialog(
                barrierLabel: "Barrier",
                barrierDismissible: true,
                barrierColor: Colors.black.withOpacity(0.5),
                transitionDuration: const Duration(milliseconds: 300),
                context: context,
                pageBuilder: (_, __, ___) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width,
                      child: const SearchScreenPage(),
                      decoration: const BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(18),
                          bottomRight: Radius.circular(18),
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                    ),
                  );
                },
                transitionBuilder: (context, anim1, anim2, child) {
                  return SlideTransition(
                    position: Tween(
                            begin: const Offset(0, -1), end: const Offset(0, 0))
                        .animate(anim1),
                    child: child,
                  );
                },
              );
            },
          ),
        ),
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
    );
  }
