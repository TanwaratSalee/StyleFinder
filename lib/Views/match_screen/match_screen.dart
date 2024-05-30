import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/match_screen/postmathscreen.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:flutter_finalproject/Views/widgets_common/appbar_ontop.dart';
import 'package:flutter_finalproject/Views/widgets_common/filterDrawer.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/home_controller.dart';
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

  late Future<List<Map<String, dynamic>>> _topProductsFuture;
  late Future<List<Map<String, dynamic>>> _lowerProductsFuture;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProductController());
    _pageControllerTop = PageController(viewportFraction: 0.8);
    _pageControllerLower = PageController(viewportFraction: 0.8);
    _currentPageIndexTop = 0;
    _currentPageIndexLower = 0;

    _pageControllerTop.addListener(() {
      final newPageIndex = _pageControllerTop.page!.round();
      if (_currentPageIndexTop != newPageIndex) {
        setState(() {
          _currentPageIndexTop = newPageIndex;
        });
      }
    });

    _pageControllerLower.addListener(() {
      final newPageIndex = _pageControllerLower.page!.round();
      if (_currentPageIndexLower != newPageIndex) {
        setState(() {
          _currentPageIndexLower = newPageIndex;
        });
      }
    });

    _topProductsFuture = fetchProductstop();
    _lowerProductsFuture = fetchProductslower();
  }

  @override
  void dispose() {
    _pageControllerTop.dispose();
    _pageControllerLower.dispose();
    super.dispose();
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
                            return FilterDrawer();
                          },
                        );
                      },
                    ).box.border(color: greyThin).roundedFull.make(),
                  ],
                ),
              ),
              5.heightBox,
              buildCardSetTop(),
              10.heightBox,
              buildCardSetLower(),
              15.heightBox,
              matchWithYouContainer(),
            ],
          )),
        ],
      ),
    );
  }

  Widget matchWithYouContainer() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
              .padding(EdgeInsets.symmetric(vertical: 12))
              .margin(EdgeInsets.only(bottom: 12))
              .make(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () async {
                  final topProducts = await _topProductsFuture;
                  final lowerProducts = await _lowerProductsFuture;
                  if (topProducts.isNotEmpty && lowerProducts.isNotEmpty) {
                    final topProduct = topProducts[_currentPageIndexTop];
                    final lowerProduct = lowerProducts[_currentPageIndexLower];
                    controller.addToWishlistPostUserMatch(
                      topProduct['p_name'],
                      lowerProduct['p_name'],
                      context,
                    );
                    Get.to(() => PostMatchScreen());
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
                    Image.asset(icPost, width: 22, height: 22),
                    SizedBox(width: 8),
                    Text('Post')
                        .text
                        .fontFamily(semiBold)
                        .color(Color.fromARGB(255, 28, 73, 45))
                        .size(14)
                        .make(),
                  ],
                ),
              )
                  .box
                  .color(const Color.fromRGBO(177, 234, 199, 1))
                  .padding(EdgeInsets.symmetric(vertical: 12, horizontal: 58))
                  .border(color: (const Color.fromRGBO(35, 101, 60, 1)))
                  .rounded
                  .make(),
              InkWell(
                onTap: () async {
                  final topProducts = await _topProductsFuture;
                  final lowerProducts = await _lowerProductsFuture;
                  if (topProducts.isNotEmpty && lowerProducts.isNotEmpty) {
                    final topProduct = topProducts[_currentPageIndexTop];
                    final lowerProduct = lowerProducts[_currentPageIndexLower];
                    controller.addToWishlistUserMatch(
                      topProduct['p_name'],
                      lowerProduct['p_name'],
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
                    SizedBox(width: 8),
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
                    .padding(EdgeInsets.symmetric(vertical: 12, horizontal: 18))
                    .border(color: (const Color.fromRGBO(160, 84, 84, 1)))
                    .rounded
                    .make(),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchProductstop() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('p_part', isEqualTo: 'top')
        .get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> fetchProductslower() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('p_part', isEqualTo: 'lower')
        .get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Widget buildCardSetTop() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _topProductsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.error != null) {
          return Center(child: Text('An error occurred: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        }
        final topProducts = snapshot.data!;
        return Container(
          height: 240,
          child: PageView.builder(
            controller: _pageControllerTop,
            itemCount: topProducts.length,
            itemBuilder: (context, index) {
              final product = topProducts[index];
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
                      child: Image.network(product['p_imgs'][0],
                          fit: BoxFit.cover),
                    ),
                    Positioned(
                      left: -10,
                      child: IconButton(
                        icon: Icon(Icons.chevron_left,
                            size: 32, color: whiteColor),
                        onPressed: () {
                          if (_currentPageIndexTop > 0) {
                            _pageControllerTop.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                      ),
                    ),
                    Positioned(
                      right: -10,
                      child: IconButton(
                        icon: Icon(Icons.chevron_right,
                            size: 32, color: whiteColor),
                        onPressed: () {
                          if (_currentPageIndexTop < topProducts.length - 1) {
                            _pageControllerTop.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
                  .box
                  .color(primaryDark)
                  .margin(EdgeInsets.symmetric(horizontal: 10))
                  .rounded
                  .make();
            },
          ),
        );
      },
    );
  }

  Widget buildCardSetLower() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _lowerProductsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.error != null) {
          return Center(child: Text('An error occurred: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        }
        final lowerProducts = snapshot.data!;
        return Container(
          height: 240,
          child: PageView.builder(
            controller: _pageControllerLower,
            itemCount: lowerProducts.length,
            itemBuilder: (context, index) {
              final product = lowerProducts[index];
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
                      child: Image.network(product['p_imgs'][0],
                          fit: BoxFit.cover),
                    ),
                    Positioned(
                      left: -10,
                      child: IconButton(
                        icon: Icon(Icons.chevron_left,
                            size: 32, color: whiteColor),
                        onPressed: () {
                          if (_currentPageIndexLower > 0) {
                            _pageControllerLower.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                      ),
                    ),
                    Positioned(
                      right: -10,
                      child: IconButton(
                        icon: Icon(Icons.chevron_right,
                            size: 32, color: whiteColor),
                        onPressed: () {
                          if (_currentPageIndexLower <
                              lowerProducts.length - 1) {
                            _pageControllerLower.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
                  .box
                  .color(primaryDark)
                  .margin(EdgeInsets.symmetric(horizontal: 10))
                  .rounded
                  .make();
            },
          ),
        );
      },
    );
  }
}

void showModalRightSheet({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
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
