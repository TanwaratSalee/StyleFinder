import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/search_screen/search_screen.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/consts/images.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../cart_screen/cart_screen.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({Key? key}) : super(key: key);

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  int selectedCardIndex = 0; // เก็บ index ของการ์ดที่ถูกเลือก
  double initialX = 0.0;
  double updatedX = 0.0;
  bool isFirstCardActive =
      true; // ตัวแปรเพื่อตรวจสอบว่าชุดการ์ดที่หนึ่งเปิดใช้งานหรือไม่

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        leading: Padding(
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
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onHorizontalDragStart: (details) {
                initialX = details.globalPosition.dx;
                isFirstCardActive = true; // เปิดใช้งานชุดการ์ดที่หนึ่ง
              },
              onHorizontalDragUpdate: (details) {
                updatedX = details.globalPosition.dx;
              },
              onHorizontalDragEnd: (details) {
                if (initialX < updatedX) {
                  if (selectedCardIndex > 0) {
                    setState(() {
                      selectedCardIndex -= 1;
                    });
                  }
                } else if (initialX > updatedX) {
                  if (selectedCardIndex < 9) {
                    setState(() {
                      selectedCardIndex += 1;
                    });
                  }
                }
              },
              child: Stack(
                children: List.generate(10, (index) {
                  return Positioned(
                    left: MediaQuery.of(context).size.width / 2 -
                        135 +
                        (selectedCardIndex - index) * 300,
                    child: Padding(
                      padding: EdgeInsets.zero, // ลดช่องว่างรอบการ์ดเป็นศูนย์
                      child: Card(
                        elevation:
                            selectedCardIndex == index && isFirstCardActive
                                ? 5
                                : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          width: 300.0,
                          height: 230.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/images/product${index % 3 + 1}.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onHorizontalDragStart: (details) {
                initialX = details.globalPosition.dx;
                isFirstCardActive = false; // ปิดใช้งานชุดการ์ดที่หนึ่ง
              },
              onHorizontalDragUpdate: (details) {
                updatedX = details.globalPosition.dx;
              },
              onHorizontalDragEnd: (details) {
                if (initialX < updatedX) {
                  if (selectedCardIndex > 0) {
                    setState(() {
                      selectedCardIndex -= 1;
                    });
                  }
                } else if (initialX > updatedX) {
                  if (selectedCardIndex < 9) {
                    setState(() {
                      selectedCardIndex += 1;
                    });
                  }
                }
              },
              child: Stack(
                children: List.generate(10, (index) {
                  return Positioned(
                    left: MediaQuery.of(context).size.width / 2 +
                        135 +
                        (index - selectedCardIndex) * 300,
                    child: Padding(
                      padding: EdgeInsets.zero, // ลดช่องว่างรอบการ์ดเป็นศูนย์
                      child: Card(
                        elevation:
                            selectedCardIndex == index && !isFirstCardActive
                                ? 5
                                : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          width: 290.0,
                          height: 230.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/images/product${index % 3 + 1}.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
