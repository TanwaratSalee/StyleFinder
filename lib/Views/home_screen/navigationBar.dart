// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors, file_names, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/cart_screen/cart_screen.dart';
import 'package:flutter_finalproject/Views/match_screen/match_screen.dart';
import 'package:flutter_finalproject/Views/news_screen/component/search_screen.dart';
import 'package:flutter_finalproject/Views/news_screen/news_screen.dart';
import 'package:flutter_finalproject/Views/profile_screen/profile_screen.dart';
import 'package:flutter_finalproject/Views/search_screen/search_screen.dart';
import 'package:flutter_finalproject/Views/widgets_common/exit_dialog.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/consts/images.dart';
import 'package:flutter_finalproject/consts/strings.dart';
import 'package:flutter_finalproject/controllers/news_controller.dart';
import 'package:flutter_finalproject/Views/home_screen/home_screen.dart';
import 'package:get/get.dart';
import '../../consts/styles.dart';

class MainNavigationBar extends StatefulWidget {
  @override
  State<MainNavigationBar> createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<MainNavigationBar> {
  int _selectedIndex = 0; // เพิ่มตัวแปร _selectedIndex ใน State

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(NewsController());

    var navbarItem = [
      BottomNavigationBarItem(
          icon: Image.asset(
            _selectedIndex == 0 ? icHomeSelected : icHome,
            width: 24,
          ),
          label: home),
      BottomNavigationBarItem(
          icon: Image.asset(
            _selectedIndex == 1 ? icNewsSelected : icNews,
            width: 24,
          ),
          label: news),
      BottomNavigationBarItem(
          icon: Image.asset(
            _selectedIndex == 2 ? icMatchSelected : icMatch,
            width: 24,
          ),
          label: match),
      BottomNavigationBarItem(
          icon: Image.asset(
            _selectedIndex == 3 ? icPersonSelected : icPerson,
            width: 24,
          ),
          label: person),
    ];

    var navBody = [
      const HomeScreen(),
      const NewsScreen(),
      const MatchScreen(),
      const ProfileScreen(),
    ];

    return WillPopScope(
      onWillPop: () async {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => exitDialog(context));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          leading: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: IconButton(
              icon: Image.asset(
                icSearch,
                width: 23,
              ),
              onPressed: () {Get.to(() => SearchScreenPage());},
            ),
          ),
          title: Center(
            child: Image.asset(icLogoOnTop, height: 40),
          ),
          actions: <Widget>[
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
        ),
        body: Column(
          children: [
            Expanded(
              child: navBody[
                  _selectedIndex], // ใช้ _selectedIndex เพื่อแสดงหน้าที่ถูกเลือก
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex:
              _selectedIndex, // ใช้ _selectedIndex เพื่อเลือกไอคอนที่ถูกเลือก
          selectedItemColor: primaryApp,
          selectedLabelStyle: const TextStyle(fontFamily: semibold),
          type: BottomNavigationBarType.fixed,
          backgroundColor: whiteColor,
          items: navbarItem,
          onTap: (value) {
            setState(() {
              _selectedIndex = value; // อัปเดต _selectedIndex เมื่อคลิก
            });
          },
        ),
      ),
    );
  }
}
