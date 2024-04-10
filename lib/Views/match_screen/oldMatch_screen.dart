import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/search_screen/search_screen.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/consts/images.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../cart_screen/cart_screen.dart';
import '../widgets_common/appbar_ontop.dart';

class OldMatchScreen extends StatefulWidget {
  const OldMatchScreen({Key? key}) : super(key: key);

  @override
  _OldMatchScreenState createState() => _OldMatchScreenState();
}

class _OldMatchScreenState extends State<OldMatchScreen> {
  int selectedCardIndex = 0; 
  double initialX = 0.0;
  double updatedX = 0.0;
  bool isFirstCardActive =
      true; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: appbarField(context: context),
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
                isFirstCardActive = true; 
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
                      padding: EdgeInsets.zero, 
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
                isFirstCardActive = false; 
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
                      padding: EdgeInsets.zero, 
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
