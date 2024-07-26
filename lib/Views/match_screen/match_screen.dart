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
    setState(() {
      _currentPageIndexTop = index;
    });
  }

  void handlePageChangeLower(int index, int itemCount) {
    if (index == 0) {
      _pageControllerLower.jumpToPage(itemCount);
    } else if (index == itemCount + 1) {
      _pageControllerLower.jumpToPage(1);
    }
    setState(() {
      _currentPageIndexLower = index;
    });
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
              checkMatch(topColors, lowerColors, skinTone: skinTone);

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
                            ? 'Perfect Match!'
                            : 'Not a Match',
                      )
                          .text
                          .fontFamily(semiBold)
                          .color(matchResult['isGreatMatch']
                              ? greenColor
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
  final int? topPrimaryColor = matchResult['topClosestColor'];
  final int? lowerPrimaryColor = matchResult['lowerClosestColor'];

  // Debug prints (Consider using a logging mechanism if this is for production)
  print('Top Colors: $topPrimaryColor');
  print('Lower Colors: $lowerPrimaryColor');

  // Color Names
  final String topColorName =
      topPrimaryColor != null ? getColorName(topPrimaryColor) : 'Unknown';
  final String lowerColorName =
      lowerPrimaryColor != null ? getColorName(lowerPrimaryColor) : 'Unknown';

  // --- Data Preparation ---
  int nonMatchingConditions = 0;
  List<Widget> reasonWidgets = [];
  List<Widget> colorReasonsWidgets = [];
  bool dayOfWeekTextAdded = false;
  final String additionalReason =
      (topPrimaryColor != null && lowerPrimaryColor != null)
          ? getAdditionalReason(topPrimaryColor, lowerPrimaryColor)
          : '';

  Map<int, String> recommendedColors = getRecommendedColors(dayOfWeek.value);
  Map<int, String> nonMatchingColors = getNonMatchingColors(dayOfWeek.value);

  // --- Evaluation Logic ---
  if (topPrimaryColor == null || lowerPrimaryColor == null) {
    reasonWidgets
        .add(Text('Unknown colors selected', style: TextStyle(fontSize: 14)));
    nonMatchingConditions++; // Increment if any color is unknown
  } else {
    // Increment non-matching conditions if the colors do not match
    if (colorMatchMap[topPrimaryColor]?.contains(lowerPrimaryColor) != true) {
      nonMatchingConditions++;
    }

    // Check skin tone matching
    final topMatchesSkinTone =
        isColorMatchingSkinTone(topPrimaryColor, skinTone);
    final lowerMatchesSkinTone =
        isColorMatchingSkinTone(lowerPrimaryColor, skinTone);

    reasonWidgets.add(
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            topMatchesSkinTone ? Icons.check : Icons.close,
            size: 20,
            color: topMatchesSkinTone ? greenColor : redColor,
          ),
          SizedBox(width: 5),
          Expanded(
            child: Text(
              '${topColorName} ${topMatchesSkinTone ? "suits" : "does not suit"} your skin tone.',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );

    // Increment non-matching conditions if the top color does not match skin tone
    if (!topMatchesSkinTone) {
      nonMatchingConditions++;
    }

    reasonWidgets.add(
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            lowerMatchesSkinTone ? Icons.check : Icons.close,
            size: 20,
            color: lowerMatchesSkinTone ? greenColor : redColor,
          ),
          SizedBox(width: 5),
          Expanded(
            child: Text(
              '${lowerColorName} ${lowerMatchesSkinTone ? "suits" : "does not suit"} your skin tone.',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );

    // Increment non-matching conditions if the lower color does not match skin tone
    if (!lowerMatchesSkinTone) {
      nonMatchingConditions++;
    }

    if (recommendedColors.containsKey(topPrimaryColor)) {
      if (!dayOfWeekTextAdded) {
        colorReasonsWidgets.add(
          Row(
            children: [
              Text(
                'You were born on :',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: medium,
                ),
              ),
              Text(
                ' ${dayOfWeek.value}',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: regular,
                ),
              ),
            ],
          ),
        );
        dayOfWeekTextAdded = true;
      }
      colorReasonsWidgets.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.check,
              size: 20,
              color: greenColor,
            ),
            SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'The top color is: ',
                  style: TextStyle(fontSize: 14, fontFamily: regular),
                ),
                SizedBox(
                  width: 200,
                  child: Text(
                    recommendedColors[topPrimaryColor]!,
                    style: TextStyle(fontSize: 14, fontFamily: regular),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }

    if (recommendedColors.containsKey(lowerPrimaryColor)) {
      if (!dayOfWeekTextAdded) {
        colorReasonsWidgets.add(
          Text(
            'You were born on : ${dayOfWeek.value}',
            style: TextStyle(fontSize: 14, fontFamily: bold),
          ),
        );
        dayOfWeekTextAdded = true;
      }
      colorReasonsWidgets.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.check,
              size: 20,
              color: greenColor,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'The lower color is: ',
                  style: TextStyle(fontSize: 14, fontFamily: regular),
                ),
                SizedBox(width: 5),
                SizedBox(
                  width: 200,
                  child: Text(
                    recommendedColors[lowerPrimaryColor]!,
                    style: TextStyle(fontSize: 14, fontFamily: regular),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }

    // Check non-matching colors based on the day of the week
    if (nonMatchingColors.containsKey(topPrimaryColor) ||
        nonMatchingColors.containsKey(lowerPrimaryColor)) {
      if (!dayOfWeekTextAdded) {
        colorReasonsWidgets.add(
          Row(
            children: [
              Text(
                'You were born on :',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: bold,
                ),
              ),
              Text(
                ' ${dayOfWeek.value}',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: regular,
                ),
              ),
            ],
          ),
        );
        dayOfWeekTextAdded = true;
      }
    }

    if (nonMatchingColors.containsKey(topPrimaryColor)) {
      colorReasonsWidgets.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.close,
              size: 20,
              color: redColor,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'The top color is: ',
                  style: TextStyle(fontSize: 14, fontFamily: regular),
                ),
                SizedBox(width: 5),
                SizedBox(
                  width: 200,
                  child: Text(
                    nonMatchingColors[topPrimaryColor]!,
                    style: TextStyle(fontSize: 14, fontFamily: regular),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }

    if (nonMatchingColors.containsKey(lowerPrimaryColor)) {
      colorReasonsWidgets.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.close,
              size: 20,
              color: redColor,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'The lower color is: ',
                  style: TextStyle(fontSize: 14, fontFamily: regular),
                ),
                SizedBox(width: 5),
                SizedBox(
                  width: 200,
                  child: Text(
                    nonMatchingColors[lowerPrimaryColor]!,
                    style: TextStyle(fontSize: 14, fontFamily: regular),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: whiteColor,
        contentPadding: EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  nonMatchingConditions == 0
                      ? 'Perfect Match!'
                      : '$nonMatchingConditions Conditions Not Matching',
                  style: TextStyle(
                    color: nonMatchingConditions == 0 ? greenColor : redColor,
                    fontSize: 24,
                    fontFamily: bold,
                  ),
                ),
              ),
                Divider(color: greyLine,),
              // --- เหตุผลเกี่ยวกับโทนสีผิว ---
              buildReasonSection(
                '',
                Icons.person,
                [
                  Row(
                    children: [
                      Text(
                        'Your skin tone :',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: medium,
                        ),
                      ),
                      Text(
                        ' ${getSkinToneDescription(skinTone!)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: regular,
                        ),
                      ),
                    ],
                  ),
                  ...reasonWidgets,
                ],
              ),

              // --- เหตุผลเกี่ยวกับสีที่แนะนำ/ไม่แนะนำตามวัน ---
              if (colorReasonsWidgets.isNotEmpty)
                buildReasonSection(
                  '',
                  Icons.calendar_today,
                  colorReasonsWidgets,
                ),
              SizedBox(height: 15),

              // --- เหตุผลเกี่ยวกับการจับคู่สีเสื้อ ---
              buildReasonSection(
                'The color of the top and bottoms match',
                Icons.color_lens,
                [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        colorMatchMap[topPrimaryColor]
                                    ?.contains(lowerPrimaryColor) ==
                                true
                            ? Icons.check
                            : Icons.close,
                        size: 20,
                        color: colorMatchMap[topPrimaryColor]
                                    ?.contains(lowerPrimaryColor) ==
                                true
                            ? greenColor
                            : redColor,
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '${topColorName} ${colorMatchMap[topPrimaryColor]?.contains(lowerPrimaryColor) == true ? "matches" : "does not match"} with ${lowerColorName}.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (additionalReason.isNotEmpty) ...[
                SizedBox(height: 15),
                Row(
                  children: [
                    Icon(Icons.info, size: 20, color: primaryApp),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        additionalReason,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}

// สร้าง Widget สำหรับส่วนของเหตุผล
Widget buildReasonSection(String title, IconData icon, List<Widget> children) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          /* Icon(icon, size: 24, color: primaryApp), */
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontFamily: medium,
            ),
          ),
        ],
      ),
      ...children,
    ],
  );
}

Widget buildSkinToneRow(int? skinTone, List<Widget> reasonWidgets,
    List<Widget> colorReasonsWidgets) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            'Your Skin Tone : ',
            style: const TextStyle(
              fontSize: 16,
              fontFamily: medium,
            ),
          ),
          Text(
            skinTone == null ? 'Error' : '${getSkinToneDescription(skinTone)}',
            style: const TextStyle(
              fontSize: 14,
              fontFamily: regular,
            ),
          ),
        ],
      ),
      ...reasonWidgets,
      if (colorReasonsWidgets.isNotEmpty) ...[
        ...colorReasonsWidgets.map((widget) => Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: widget,
            )),
      ],
    ],
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
        alignment: Alignment.bottomCenter,
        child: Material(
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width,
              color: whiteColor,
              child: builder(context),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}
