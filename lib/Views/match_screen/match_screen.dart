import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/match_screen/matchpost_screen.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:flutter_finalproject/Views/widgets_common/appbar_ontop.dart';
import 'package:flutter_finalproject/Views/widgets_common/filterDrawerMatch.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/product_controller.dart';
import 'package:get/get.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({Key? key}) : super(key: key);

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  late final ProductController controller;
  late final PageController _pageControllerTop, _pageControllerLower;
  late int _currentPageIndexTop, _currentPageIndexLower;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fetchAndPrintUserSkinTone();
    controller = Get.put(ProductController());
    _pageControllerTop = PageController(viewportFraction: 0.8, initialPage: 1);
    _pageControllerLower =
        PageController(viewportFraction: 0.8, initialPage: 1);
    _currentPageIndexTop = 1;
    _currentPageIndexLower = 1;

    controller.fetchFilteredTopProducts();
    controller.fetchFilteredLowerProducts();
    controller.fetchVendors();
  }

  @override
  void dispose() {
    _pageControllerTop.dispose();
    _pageControllerLower.dispose();
    super.dispose();
  }

  void handlePageChangeTop(int index, int itemCount) {
    if (index == 0) {
      _pageControllerTop.jumpToPage(itemCount);
    } else if (index == itemCount + 1) {
      _pageControllerTop.jumpToPage(1);
    }
  }

  void handlePageChangeLower(int index, int itemCount) {
    if (index == 0) {
      _pageControllerLower.jumpToPage(itemCount);
    } else if (index == itemCount + 1) {
      _pageControllerLower.jumpToPage(1);
    }
  }

  int getActualIndex(int index, int itemCount) {
    if (index == 0) {
      return itemCount - 1;
    } else if (index == itemCount + 1) {
      return 0;
    } else {
      return index - 1;
    }
  }

  final List<Map<String, dynamic>> allColors = [
    {'name': 'Black', 'color': blackColor, 'value': 0xFF000000},
    {'name': 'Grey', 'color': greyColor, 'value': 0xFF808080},
    {'name': 'White', 'color': whiteColor, 'value': 0xFFFFFFFF},
    {
      'name': 'Purple',
      'color': const Color.fromRGBO(98, 28, 141, 1),
      'value': 0xFF621C8D
    },
    {
      'name': 'Deep Purple',
      'color': const Color.fromRGBO(202, 147, 235, 1),
      'value': 0xFFCA93EB
    },
    {
      'name': 'Blue',
      'color': Color.fromRGBO(32, 47, 179, 1),
      'value': 0xFF202FB3
    },
    {
      'name': 'Light blue',
      'color': const Color.fromRGBO(48, 176, 232, 1),
      'value': 0xFF30B0E8
    },
    {
      'name': 'Blue Grey',
      'color': const Color.fromRGBO(83, 205, 191, 1),
      'value': 0xFF53CDBF
    },
    {
      'name': 'Green',
      'color': const Color.fromRGBO(23, 119, 15, 1),
      'value': 0xFF17770F
    },
    {
      'name': 'Lime Green',
      'color': Color.fromRGBO(98, 207, 47, 1),
      'value': 0xFF62CF2F
    },
    {'name': 'Yellow', 'color': Colors.yellow, 'value': 0xFFFFFF00},
    {'name': 'Orange', 'color': Colors.orange, 'value': 0xFFFFA500},
    {'name': 'Pink', 'color': Colors.pinkAccent, 'value': 0xFFFF4081},
    {'name': 'Red', 'color': Colors.red, 'value': 0xFFFF0000},
    {
      'name': 'Brown',
      'color': Color.fromARGB(255, 121, 58, 31),
      'value': 0xFF793A1F
    },
  ];

  final Map<int, List<int>> colorMatchMap = {
    0xFF000000: [0xFFFFFFFF, 0xFF000000], // Black matches with White
    0xFFFFFFFF: [0xFF000000, 0xFFFFFFFF],
    0xFF202FB3: [
      0xFF000000,
      0xFFFFFFFF,
      0xFFFF4081,
      0xFFFFFF00,
      0xFF53CDBF,
      0xFFFF0000,
      0xFF621C8D,
      0xFF202FB3
    ], // Blue matches with several colors
    0xFF808080: [
      0xFFFF4081,
      0xFFFFFFFF,
      0xFFFF4081,
      0xFFFF0000,
      0xFF17770F,
      0xFF202FB3,
      0xFF000000,
      0xFFFFFF00
    ], // Grey matches with several colors
    0xFFFFE4C4: [
      0xFFFFFFFF,
      0xFF808080,
      0xFF793A1F,
      0xFF000000,
      0xFFFFFF00,
      0xFF202FB3,
      0xFF17770F,
      0xFFFF4081,
      0xFFFF0000
    ], // Cream matches with several colors
    0xFF793A1F: [
      0xFFFFFFFF,
      0xFF808080,
      0xFF202FB3,
      0xFF000000,
      0xFF17770F,
      0xFFFFFF00
    ], // Brown matches with several colors
    0xFFFF0000: [
      0xFFFFFFFF,
      0xFF621C8D,
      0xFF793A1F,
      0xFF000000,
      0xFFFF4081,
      0xFF17770F,
      0xFFFFFF00
    ], // Red matches with several colors
    0xFF621C8D: [
      0xFFFFFFFF,
      0xFF793A1F,
      0xFF000000,
      0xFF17770F,
      0xFFFFFF00
    ], // Purple matches with several colors
    0xFFFFFF00: [
      0xFF793A1F,
      0xFF621C8D,
      0xFF000000,
      0xFFFF4081,
      0xFF808080,
      0xFF17770F
    ], // Yellow matches with several colors
  };

  int findClosestColor(int colorValue) {
    int closestColorValue = allColors[0]['value'];
    double minDistance = double.infinity;

    for (var color in allColors) {
      double distance = calculateColorDistance(colorValue, color['value']);
      if (distance < minDistance) {
        minDistance = distance;
        closestColorValue = color['value'];
      }
    }

    return closestColorValue;
  }

  double calculateColorDistance(int color1, int color2) {
    int r1 = (color1 >> 16) & 0xFF;
    int g1 = (color1 >> 8) & 0xFF;
    int b1 = color1 & 0xFF;

    int r2 = (color2 >> 16) & 0xFF;
    int g2 = (color2 >> 8) & 0xFF;
    int b2 = color2 & 0xFF;

    return sqrt((r1 - r2) * (r1 - r2) +
            (g1 - g2) * (g1 - g2) +
            (b1 - b2) * (b1 - b2))
        .toDouble();
  }

  Map<String, dynamic> checkMatch(
      List<dynamic> topColors, List<dynamic> lowerColors) {
    if (topColors.isEmpty || lowerColors.isEmpty) {
      return {
        'isGreatMatch': false,
        'topClosestColor': null,
        'lowerClosestColor': null,
      };
    }

    // Ensure that topColors and lowerColors are lists of integers
    final List<int> topColorsList = List<int>.from(topColors);
    final List<int> lowerColorsList = List<int>.from(lowerColors);

    final topPrimaryColor = findClosestColor(topColorsList[0]);
    final lowerPrimaryColor = findClosestColor(lowerColorsList[0]);

    bool isGreatMatch =
        colorMatchMap[topPrimaryColor]?.contains(lowerPrimaryColor) ?? false;

    return {
      'isGreatMatch': isGreatMatch,
      'topClosestColor': topPrimaryColor,
      'lowerClosestColor': lowerPrimaryColor,
    };
  }

  String getColorName(int colorValue) {
    final color = allColors.firstWhere(
      (element) => element['value'] == colorValue,
      orElse: () => {'name': 'Unknown'},
    );
    return color['name'];
  }

  void showMatchReasonModal(
      BuildContext context, Map<String, dynamic> matchResult) {
    final bool isGreatMatch = matchResult['isGreatMatch'];
    final int? topPrimaryColor = matchResult['topClosestColor'];
    final int? lowerPrimaryColor = matchResult['lowerClosestColor'];

    print('Top Colors: ${matchResult['topClosestColor']}'); // Debug
    print('Lower Colors: ${matchResult['lowerClosestColor']}'); // Debug

    String reason;
    if (topPrimaryColor == null || lowerPrimaryColor == null) {
      reason = 'Unknown colors selected';
    } else if (isGreatMatch) {
      reason =
          '${getColorName(topPrimaryColor)} matches with ${getColorName(lowerPrimaryColor)}';
    } else {
      reason =
          '${getColorName(topPrimaryColor)} does not match with ${getColorName(lowerPrimaryColor)}';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isGreatMatch ? 'Great Match!' : 'Not a Match'),
          content: Text(reason),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchAndPrintUserSkinTone() async {
    // Get the current user
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Get the user's document from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        // Get the skin tone field
        final skinTone = userDoc.data()?['skinTone'];

        // Print the skin tone
        if (skinTone != null) {
          String skinDescription;

          switch (skinTone) {
            case 4294961114:
              skinDescription = 'Fair Skin';
              break;
            case 4289672092:
              skinDescription = 'Medium Skin';
              break;
            case 4280391411:
              skinDescription = 'Tan Skin';
              break;
            case 4278215680:
              skinDescription = 'Dark Skin';
              break;
            default:
              skinDescription = 'Unknown Skin Tone';
          }

          print('User has $skinDescription');
        } else {
          print('Skin tone not found for the current user.');
        }
      } else {
        print('User document does not exist.');
      }
    } else {
      print('No user is currently signed in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
        title: appbarField(context: context),
      ),
      body: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
              child: Column(
            children: <Widget>[
              const Divider(
                color: greyThin,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 38),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Match Your Outfit',
                      style: TextStyle(
                        fontFamily: medium,
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.filter_list_rounded,
                          color: greyDark, size: 25),
                      onPressed: () {
                        showModalRightSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return FilterDrawerMatch();
                          },
                        );
                      },
                    ).box.border(color: greyThin).roundedFull.make(),
                  ],
                ),
              ),
              5.heightBox,
              Obx(() => buildCardSetTop(controller.topFilteredProducts)),
              10.heightBox,
              Obx(() => buildCardSetLower(controller.lowerFilteredProducts)),
              15.heightBox,
              matchWithYouContainer(),
            ],
          )),
        ],
      ),
    );
  }

  Widget buildCardSetTop(List<Map<String, dynamic>> topProducts) {
    if (topProducts.isEmpty) {
      return const Center(child: Text('No Top available'));
    }

    final itemCount = topProducts.length;

    double containerHeight = MediaQuery.of(context).size.height < 855
        ? MediaQuery.of(context).size.height * 0.23
        : MediaQuery.of(context).size.height * 0.25;

    return Container(
      height: containerHeight,
      child: PageView.builder(
        controller: _pageControllerTop,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndexTop = index;
          });
          handlePageChangeTop(index, itemCount);
        },
        itemCount: itemCount + 2,
        itemBuilder: (context, index) {
          if (itemCount == 0) {
            return const Center(child: Text('No Top available'));
          }
          final actualIndex = getActualIndex(index, itemCount);
          return buildCardItem(topProducts[actualIndex]);
        },
      ),
    );
  }

  Widget buildCardSetLower(List<Map<String, dynamic>> lowerProducts) {
    if (lowerProducts.isEmpty) {
      return const Center(child: Text('No Lower available'));
    }

    final itemCount = lowerProducts.length;

    double containerHeight = MediaQuery.of(context).size.height < 855
        ? MediaQuery.of(context).size.height * 0.23
        : MediaQuery.of(context).size.height * 0.25;

    return Container(
      height: containerHeight,
      child: PageView.builder(
        controller: _pageControllerLower,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndexLower = index;
          });
          handlePageChangeLower(index, itemCount);
        },
        itemCount: itemCount + 2,
        itemBuilder: (context, index) {
          if (itemCount == 0) {
            return const Center(child: Text('No Lower available'));
          }
          final actualIndex = getActualIndex(index, itemCount);
          return buildCardItem(lowerProducts[actualIndex]);
        },
      ),
    );
  }

  Widget buildCardItem(Map<String, dynamic> product) {
    final productName = product['name'] ?? 'No Name';
    final productImages = product['imgs'] ?? [''];
    final productColors = product['colors'] ?? []; // Ensure colors is a list

    return GestureDetector(
      onTap: () {
        Get.to(() => ItemDetails(
              title: productName,
              data: product,
            ));
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 250,
            child: Image.network(productImages[0], fit: BoxFit.cover),
          ).box.color(const Color.fromARGB(255, 244, 244, 245)).make(),
          Positioned(
            left: -10,
            child: IconButton(
              icon: const Icon(Icons.chevron_left, size: 32, color: whiteColor),
              onPressed: () {
                if (_currentPageIndexTop > 0) {
                  _pageControllerTop.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                } else {
                  _pageControllerTop.jumpToPage(product.length - 1);
                }
              },
            ),
          ),
          Positioned(
            right: -10,
            child: IconButton(
              icon:
                  const Icon(Icons.chevron_right, size: 32, color: whiteColor),
              onPressed: () {
                if (_currentPageIndexTop < product.length - 1) {
                  _pageControllerTop.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                } else {
                  _pageControllerTop.jumpToPage(0);
                }
              },
            ),
          ),
        ],
      ),
    )
        .box
        .color(primaryDark)
        .margin(const EdgeInsets.symmetric(horizontal: 10))
        .rounded
        .make();
  }

  Widget matchWithYouContainer() {
    return Obx(() {
      if (controller.isFetchingTopProducts.value ||
          controller.isFetchingLowerProducts.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      if (controller.topFilteredProducts.isEmpty ||
          controller.lowerFilteredProducts.isEmpty) {
        return const Center(child: Text('No matching products available'));
      }

      final topProductIndex = getActualIndex(
          _currentPageIndexTop, controller.topFilteredProducts.length);
      final lowerProductIndex = getActualIndex(
          _currentPageIndexLower, controller.lowerFilteredProducts.length);

      if (topProductIndex < 0 ||
          lowerProductIndex < 0 ||
          topProductIndex >= controller.topFilteredProducts.length ||
          lowerProductIndex >= controller.lowerFilteredProducts.length) {
        return const Center(child: Text('No matching products available'));
      }

      final topProduct = controller.topFilteredProducts[topProductIndex];
      final lowerProduct = controller.lowerFilteredProducts[lowerProductIndex];
      final matchResult =
          checkMatch(topProduct['colors'], lowerProduct['colors']);

      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Feedback:',
                ).text.fontFamily(regular).color(blackColor).size(14).make(),
                8.widthBox,
                InkWell(
                  onTap: () {
                    showMatchReasonModal(context, matchResult);
                  },
                  child: Text(
                    matchResult['isGreatMatch']
                        ? 'Great Match!'
                        : 'Not a Match',
                  )
                      .text
                      .fontFamily(semiBold)
                      .color(
                          matchResult['isGreatMatch'] ? Colors.green : redColor)
                      .size(20)
                      .make(),
                ),
              ],
            )
                .box
                .border(color: greyLine, width: 1)
                .padding(
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 32))
                .margin(const EdgeInsets.only(bottom: 12))
                .make(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    debugPrints(topProduct, lowerProduct);
                    Get.to(() => MatchPostProduct(
                          topProduct: topProduct,
                          lowerProduct: lowerProduct,
                        ));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset(icPost, width: 22, height: 22),
                      const SizedBox(width: 8),
                      Text('Post')
                          .text
                          .fontFamily(semiBold)
                          .color(const Color.fromARGB(255, 28, 73, 45))
                          .size(14)
                          .make(),
                    ],
                  )
                      .box
                      .color(const Color.fromRGBO(177, 234, 199, 1))
                      .padding(const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 58))
                      .border(color: const Color.fromRGBO(35, 101, 60, 1))
                      .rounded
                      .make(),
                ),
                InkWell(
                  onTap: () async {
                    if (topProduct != null && lowerProduct != null) {
                      print(
                          'Top Product: ${getColorName(topProduct['colors'][0])}, Lower Product: ${getColorName(lowerProduct['colors'][0])}');
                      controller.addToWishlistUserMatch(
                        topProduct['name'],
                        lowerProduct['name'],
                        context,
                      );
                    } else {
                      VxToast.show(
                        context,
                        msg:
                            'Unable to add to favorites, Because the information is not available',
                      );
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset(icLikematch, width: 22, height: 22),
                      const SizedBox(width: 8),
                      Text('Add to favorite')
                          .text
                          .fontFamily(semiBold)
                          .color(const Color.fromRGBO(87, 12, 12, 1))
                          .size(14)
                          .make(),
                    ],
                  )
                      .box
                      .color(const Color.fromRGBO(255, 203, 203, 1))
                      .padding(const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 18))
                      .border(color: const Color.fromRGBO(160, 84, 84, 1))
                      .rounded
                      .make(),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

void debugPrints(
    Map<String, dynamic> topProduct, Map<String, dynamic> lowerProduct) {
  List<int> topColors = List<int>.from(topProduct['colors']);
  List<int> lowerColors = List<int>.from(lowerProduct['colors']);

  print('Top Product ID: ${topProduct['product_id']}'); // Debug print
  print('Lower Product ID: ${lowerProduct['product_id']}'); // Debug print
  print('Top Colors: $topColors'); // Debug print
  print('Lower Colors: $lowerColors'); // Debug print
}

void showModalRightSheet({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: blackColor.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return Align(
        alignment: Alignment.centerRight,
        child: Material(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: builder(context),
          ),
        ),
      );
    },
    transitionBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}
