// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/cart_screen/cart_screen.dart';
import 'package:flutter_finalproject/Views/collection_screen/collection_screen.dart';
import 'package:flutter_finalproject/Views/collection_screen/testcollection.dart';
import 'package:flutter_finalproject/Views/match_screen/match_screen.dart';
import 'package:flutter_finalproject/Views/news_screen/news_screen.dart';
import 'package:flutter_finalproject/Views/profile_screen/profile_screen.dart';
import 'package:flutter_finalproject/Views/widgets_common/exit_dialog.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/consts/images.dart';
import 'package:flutter_finalproject/consts/strings.dart';
import 'package:flutter_finalproject/controllers/news_controller.dart';
import 'package:flutter_finalproject/Views/home_screen/home_screen.dart';
import 'package:get/get.dart';
import '../../consts/styles.dart';

class MainNavigationBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(NewsController());

    var navbarItem = [
      BottomNavigationBarItem(
          icon: Image.asset(
            icHome,
            width: 26,
          ),
          label: home),
      BottomNavigationBarItem(
          icon: Image.asset(
            icCollection,
            width: 26,
          ),
          label: collection),
      BottomNavigationBarItem(
          icon: Image.asset(
            icNews,
            width: 26,
          ),
          label: news),
      BottomNavigationBarItem(
          icon: Image.asset(
            icMatch,
            width: 26,
          ),
          label: match),
      BottomNavigationBarItem(
          icon: Image.asset(
            icPerson,
            width: 26,
          ),
          label: person),
    ];

    var navBody = [
      const HomeScreen(),
      const CollectionScreen(),
      const NewsScreen(),
      const MatchScreen(),
      const ProfileScreen(),
    ];

    return WillPopScope(
      onWillPop: () async {
        showDialog(
          barrierDismissible: false, context: context, builder: (context) => exitDialog(context));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
      backgroundColor: whiteColor,
          leading: IconButton(
              icon: Image.asset(
            icSearch,
            width: 20,
          ),
            onPressed: () {
              // ตอบสนองเมื่อปุ่มถูกกด
            },
            ),
          title: Center(
            child: Image.asset(icLogoOnTop, height: 40), 
          ),
          actions: <Widget>[
            
            IconButton(
              icon: Image.asset(
            icCart,
            width: 24,
          ),
            onPressed: () {
              Get.to(() => const CartScreen());
              
            },
            ),
          ],
        ),
        body: Column(
          children: [
            Obx(() => Expanded(child: navBody.elementAt (controller.currentNavIndex.value))),
          ],
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.currentNavIndex.value,
            selectedItemColor: primaryApp,
            selectedLabelStyle: const TextStyle(fontFamily: semibold),
            type: BottomNavigationBarType.fixed,
            backgroundColor: whiteColor,
            items: navbarItem,
            onTap: (value) {
              controller.currentNavIndex.value = value;
            },
          ),
        ),
      ),
    );
  }
}
