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
    controller = Get.put(ProductController());
    _pageControllerTop = PageController(viewportFraction: 0.8, initialPage: 1);
    _pageControllerLower = PageController(viewportFraction: 0.8, initialPage: 1);
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
              Divider(
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
      return Center(child: Text('No Top available'));
    }

    final itemCount = topProducts.length;

    return Container(
      height: 240,
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
          final actualIndex = getActualIndex(index, itemCount);
          return buildCardItem(topProducts[actualIndex]);
        },
      ),
    );
  }

  Widget buildCardSetLower(List<Map<String, dynamic>> lowerProducts) {
    if (lowerProducts.isEmpty) {
      return Center(child: Text('No Lower available'));
    }

    final itemCount = lowerProducts.length;

    return Container(
      height: 240,
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
          final actualIndex = getActualIndex(index, itemCount);
          return buildCardItem(lowerProducts[actualIndex]);
        },
      ),
    );
  }

  Widget buildCardItem(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ItemDetails(
              title: product['p_name'],
              data: product,
            ));
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 250,
            child: Image.network(product['p_imgs'][0], fit: BoxFit.cover),
          ).box.color(Color.fromARGB(255, 244, 244, 245)).make(),
          Positioned(
            left: -10,
            child: IconButton(
              icon: Icon(Icons.chevron_left, size: 32, color: whiteColor),
              onPressed: () {
                if (_currentPageIndexTop > 0) {
                  _pageControllerTop.previousPage(
                    duration: Duration(milliseconds: 300),
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
              icon: Icon(Icons.chevron_right, size: 32, color: whiteColor),
              onPressed: () {
                if (_currentPageIndexTop < product.length - 1) {
                  _pageControllerTop.nextPage(
                    duration: Duration(milliseconds: 300),
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
    ).box.color(primaryDark).margin(EdgeInsets.symmetric(horizontal: 10)).rounded.make();
  }

  Widget matchWithYouContainer() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Feedback:',
              ).text.fontFamily(regular).color(blackColor).size(14).make(),
              8.widthBox,
              Text(
                'Great Match!',
              ).text.fontFamily(semiBold).color(Colors.green).size(22).make(),
            ],
          )
              .box
              .border(color: greyLine, width: 1)
              .padding(EdgeInsets.symmetric(vertical: 12,horizontal: 32))
              .margin(EdgeInsets.only(bottom: 12))
              .make(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  final topProductIndex = getActualIndex(_currentPageIndexTop, controller.topFilteredProducts.length);
                  final lowerProductIndex = getActualIndex(_currentPageIndexLower, controller.lowerFilteredProducts.length);
                  final topProduct = controller.topFilteredProducts[topProductIndex];
                  final lowerProduct = controller.lowerFilteredProducts[lowerProductIndex];
                  Get.to(() => MatchPostProduct(
                    topProduct: topProduct,
                    lowerProduct: lowerProduct,
                  ));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(icPost, width: 22, height: 22),
                    SizedBox(width: 8),
                    Text('Post')
                        .text
                        .fontFamily(semiBold)
                        .color(Color.fromARGB(255, 28, 73, 45))
                        .size(14)
                        .make(),
                  ],
                ).box
                  .color(const Color.fromRGBO(177, 234, 199, 1))
                  .padding(EdgeInsets.symmetric(vertical: 12, horizontal: 58))
                  .border(color: (const Color.fromRGBO(35, 101, 60, 1)))
                  .rounded
                  .make(),
              ),
                  
              InkWell(
                onTap: () async {
                  final topProducts = controller.topFilteredProducts;
                  final lowerProducts = controller.lowerFilteredProducts;
                  if (topProducts.isNotEmpty && lowerProducts.isNotEmpty) {
                    final topProductIndex = getActualIndex(_currentPageIndexTop, topProducts.length);
                    final lowerProductIndex = getActualIndex(_currentPageIndexLower, lowerProducts.length);
                    final topProduct = topProducts[topProductIndex];
                    final lowerProduct = lowerProducts[lowerProductIndex];
                    print('Top Product: $topProduct, Lower Product: $lowerProduct');  // Debug print
                    if (topProduct != null && lowerProduct != null) {
                      controller.addToWishlistUserMatch(
                        topProduct['p_name'],
                        lowerProduct['p_name'],
                        context,
                      );
                    } else {
                      VxToast.show(
                        context,
                        msg: 'Unable to add to favorites, Because the information is not available',
                      );
                    }
                  } else {
                    VxToast.show(
                      context,
                      msg: 'Unable to add to favorites, Because the information is not available',
                    );
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(icLikematch, width: 22, height: 22),
                    SizedBox(width: 8),
                    Text('Add to favorite')
                        .text
                        .fontFamily(semiBold)
                        .color(const Color.fromRGBO(87, 12, 12, 1))
                        .size(14)
                        .make(),
                  ],
                ).box.color(const Color.fromRGBO(255, 203, 203, 1))
                  .padding(EdgeInsets.symmetric(vertical: 12, horizontal: 18))
                  .border(color: const Color.fromRGBO(160, 84, 84, 1))
                  .rounded
                  .make(),
              )
            ],
          ),
        ],
      ),
    );
  }

  void showModalRightSheet({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 200),
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
}
