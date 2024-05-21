import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/match_screen/match_screen.dart';
import 'package:flutter_finalproject/Views/news_screen/news_screen.dart';
import 'package:flutter_finalproject/Views/profile_screen/profile_screen.dart';
import 'package:flutter_finalproject/Views/widgets_common/exit_dialog.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/consts/images.dart';
import 'package:flutter_finalproject/consts/strings.dart';
import 'package:flutter_finalproject/Views/home_screen/home_screen.dart';
import 'package:flutter_finalproject/controllers/news_controller.dart';
import 'package:get/get.dart';
import '../../consts/styles.dart';

class MainHome extends StatefulWidget {
  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  late NewsController _newsController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _newsController = Get.put(NewsController());
  }

  @override
  Widget build(BuildContext context) {
    var navbarItem = [
      BottomNavigationBarItem(
          icon: Image.asset(
            _selectedIndex == 0 ? icHomeSelected : icHome,
            width: 24,
            color: _selectedIndex == 0 ? primaryApp : greyDark,
          ),
          label: home),
      BottomNavigationBarItem(
          icon: Image.asset(
            _selectedIndex == 1 ? icNewsSelected : icNews,
            width: 24,
            color: _selectedIndex == 1 ? primaryApp : greyDark,
          ),
          label: news),
      BottomNavigationBarItem(
          icon: Image.asset(
            _selectedIndex == 2 ? icMatchSelected : icMatch,
            width: 24,
            color: _selectedIndex == 2 ? primaryApp : greyDark,
          ),
          label: match),
      BottomNavigationBarItem(
          icon: Image.asset(
            _selectedIndex == 3 ? icPersonSelected : icPerson,
            width: 24,
            color: _selectedIndex == 3 ? primaryApp : greyDark,
          ),
          label: profile),
    ];

    var navBody = [
      const HomeScreen(),
      const NewsScreen(
        category: '',
      ),
      const MatchScreen(),
      ProfileScreen(),
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
        body: Column(
          children: [
            Expanded(
              child: navBody[_selectedIndex],
            ),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: greyDark.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(0, -1), 
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            selectedItemColor: primaryApp,
            selectedLabelStyle: const TextStyle(fontFamily: regular),
            type: BottomNavigationBarType.fixed,
            backgroundColor: whiteColor,
            items: navbarItem,
            onTap: (value) {
              setState(() {
                _selectedIndex = value;
              });
            },
          ),
        ),
      ),
    );
  }
}
