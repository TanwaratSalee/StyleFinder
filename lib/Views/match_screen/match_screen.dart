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
import 'package:intl/intl.dart';

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
  late String dayOfWeek = '';

  @override
  void initState() {
    super.initState();
    fetchUserBirthday();
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
    final productColors = product['colors'] ?? [];

    // Find the closest color
    final colorValue = productColors.isNotEmpty
        ? findClosestColor(productColors[0])
        : 0xFF000000;
    final colorName = getColorName(colorValue);

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
          Positioned(
            bottom: 10,
            child: Text(colorName,
                    style: TextStyle(color: whiteColor, fontSize: 16))
                .box
                .color(blackColor.withOpacity(0.7))
                .padding(EdgeInsets.symmetric(horizontal: 8, vertical: 4))
                .rounded
                .make(),
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
      final topColors = topProduct['colors'] ?? [];
      final lowerColors = lowerProduct['colors'] ?? [];

      return FutureBuilder<int?>(
        future: fetchUserSkinTone(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final skinTone = snapshot.data;
          final matchResult =
              checkMatchWithSkinTone(topColors, lowerColors, skinTone);

          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Feedback:',
                    )
                        .text
                        .fontFamily(regular)
                        .color(blackColor)
                        .size(14)
                        .make(),
                    8.widthBox,
                    InkWell(
                      onTap: () {
                        showMatchReasonModal(context, matchResult, skinTone);
                      },
                      child: Text(
                        matchResult['isGreatMatch']
                            ? 'Great Match!'
                            : 'Not a Match',
                      )
                          .text
                          .fontFamily(semiBold)
                          .color(matchResult['isGreatMatch']
                              ? Colors.green
                              : redColor)
                          .size(20)
                          .make(),
                    ),
                  ],
                )
                    .box
                    .border(color: greyLine, width: 1)
                    .padding(const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 32))
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
        },
      );
    });
  }
}

void showMatchReasonModal(
    BuildContext context, Map<String, dynamic> matchResult, int? skinTone) {
  final bool isGreatMatch = matchResult['isGreatMatch'];
  final int? topPrimaryColor = matchResult['topClosestColor'];
  final int? lowerPrimaryColor = matchResult['lowerClosestColor'];

  print('Top Colors: ${matchResult['topClosestColor']}'); // Debug
  print('Lower Colors: ${matchResult['lowerClosestColor']}'); // Debug

  String reason;
  String additionalReason = '';
  List<Widget> colorReasonsWidgets = [];

  if (topPrimaryColor == null || lowerPrimaryColor == null) {
    reason = 'Unknown colors selected';
  } else {
    reason =
        '${getColorName(topPrimaryColor)} matches with ${getColorName(lowerPrimaryColor)} and suits your skin tone.';
    if (!isGreatMatch) {
      reason =
          '${getColorName(topPrimaryColor)} does not match with ${getColorName(lowerPrimaryColor)} or does not suit your skin tone.';
    }
    additionalReason = getAdditionalReason(topPrimaryColor, lowerPrimaryColor);

    Map<int, String> recommendedColors = getRecommendedColors(dayOfWeek.value);
    if (topPrimaryColor == lowerPrimaryColor &&
        recommendedColors.containsKey(topPrimaryColor)) {
      colorReasonsWidgets.add(
        Text(
          'สำหรับคนเกิดวัน ${dayOfWeek.value}: ${recommendedColors[topPrimaryColor]!}',
          style: TextStyle(fontSize: 14),
        ),
      );
    } else {
      if (recommendedColors.containsKey(topPrimaryColor)) {
        colorReasonsWidgets.add(
          Text(
            'People born on ${dayOfWeek.value}: ${recommendedColors[topPrimaryColor]!}',
            style: TextStyle(fontSize: 14),
          ),
        );
      }
      if (recommendedColors.containsKey(lowerPrimaryColor)) {
        colorReasonsWidgets.add(
          Text(
            'People born on ${dayOfWeek.value}: ${recommendedColors[lowerPrimaryColor]!}',
            style: TextStyle(fontSize: 14),
          ),
        );
      }
    }
  }

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isGreatMatch ? 'Great Match!' : 'Not a Match',
              style: TextStyle(
                color: isGreatMatch ? Colors.green : Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              skinTone == null
                  ? 'Skin Tone'
                  : 'Skin Tone ${getSkinToneDescription(skinTone)}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            Text(reason, style: TextStyle(fontSize: 14)),
            if (colorReasonsWidgets.isNotEmpty) ...[
              SizedBox(height: 10),
              ...colorReasonsWidgets.map((widget) => Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: widget,
                  )),
            ],
            if (additionalReason.isNotEmpty) ...[
              SizedBox(height: 10),
              Text(additionalReason, style: TextStyle(fontSize: 14)),
            ],
          ],
        ),
      );
    },
  );
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
