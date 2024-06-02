import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/cart_screen/cart_screen.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/news_screen/component/search_screen.dart';
import 'package:flutter_finalproject/Views/search_screen/recent_search_screen.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:flutter_finalproject/Views/store_screen/mixandmatch_detail.dart';
import 'package:flutter_finalproject/Views/widgets_common/filterDrawer.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProductScreen extends StatefulWidget {
  final int initialTabIndex;

  ProductScreen({Key? key, this.initialTabIndex = 0}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 20),
            Image.asset(icLogoOnTop, height: 40),
            IconButton(
              icon: Image.asset(icCart, width: 21),
              onPressed: () {
                Get.to(() => const CartScreen());
              },
            ),
          ],
        ),
      ),
      body: ProductMatchTabs(context, widget.initialTabIndex),
    );
  }

  Widget ProductMatchTabs(BuildContext context, int initialTabIndex) {
    return DefaultTabController(
      length: 2,
      initialIndex: initialTabIndex,
      child: Column(
        children: <Widget>[
          GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchScreenPage()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Search')
                              .text
                              .fontFamily(medium)
                              .color(greyDark)
                              .size(16)
                              .make(),
                          // 200.widthBox,
                          Icon(Icons.search, color: greyDark),
                        ],
                      )
                          .box
                          .padding(EdgeInsets.symmetric(horizontal: 16, vertical: 10))
                          .margin(EdgeInsets.symmetric(horizontal: 28,vertical: 8))
                          .border(color: greyLine)
                          .roundedLg
                          .make(),
                    ),
          TabBar(
            labelStyle: const TextStyle(
                fontSize: 15, fontFamily: regular, color: greyDark),
            unselectedLabelStyle: const TextStyle(
                fontSize: 14, fontFamily: regular, color: greyDark),
            tabs: [
              const Tab(text: 'Product'),
              const Tab(text: 'Match'),
            ],
            indicatorColor: Theme.of(context).primaryColor,
          ),
          Divider(
            color: greyThin,
            thickness: 1,
            height: 2,
          ),
          Expanded(
            child: TabBarView(
              children: [
                buildProductTab(context),
                buildMatchTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProductTab(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: DefaultTabController(
            length: 12,
            child: Column(
              children: <Widget>[
                const TabBar(
                  isScrollable: true,
                  indicatorColor: primaryApp,
                  labelStyle: TextStyle(
                      fontSize: 13, fontFamily: regular, color: greyDark),
                  unselectedLabelStyle: TextStyle(
                      fontSize: 12, fontFamily: regular, color: greyDark),
                  tabs: [
                    Tab(text: 'All'),
                    Tab(text: 'Dresses'),
                    Tab(text: 'Outerwear & Costs'),
                    Tab(text: 'Blazers'),
                    Tab(text: 'Suits'),
                    Tab(text: 'Blouses & Tops'),
                    Tab(text: 'Knitwear'),
                    Tab(text: 'T-shirts'),
                    Tab(text: 'Skirts'),
                    Tab(text: 'Pants'),
                    Tab(text: 'Denim'),
                    Tab(text: 'Activewear'),
                  ],
                ).box.color(thinPrimaryApp).make(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: TabBarView(
                      children: [
                        buildProductGrid('All'),
                        buildProductGrid('dresses'),
                        buildProductGrid('outerwear & Costs'),
                        buildProductGrid('blazers'),
                        buildProductGrid('suits'),
                        buildProductGrid('blouses & Tops'),
                        buildProductGrid('knitwear'),
                        buildProductGrid('t-shirts'),
                        buildProductGrid('skirts'),
                        buildProductGrid('pants'),
                        buildProductGrid('denim'),
                        buildProductGrid('activewear'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildProductGrid(String category) {
    Query query = FirebaseFirestore.instance.collection(productsCollection);

    if (category != 'All') {
      query = query.where('p_subcollection', isEqualTo: category);
    }

    return FutureBuilder<QuerySnapshot>(
      future: query.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: loadingIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: const Text('No Items'));
        }

        return GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
                crossAxisSpacing: 15,
              mainAxisExtent: 260),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            if (index >= snapshot.data!.docs.length) {
              return Container();
            }
            var product = snapshot.data!.docs[index];
            String productName = product.get('p_name');
            String price = product.get('p_price');
            String productImage = product.get('p_imgs')[0];

            return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemDetails(
                        title: productName,
                        data: product.data() as Map<String, dynamic>,
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      child: Image.network(
                        productImage,
                        width: 195,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    10.heightBox,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productName,
                            style: const TextStyle(
                              fontFamily: medium,
                              fontSize: 16,
                              color: blackColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          "${NumberFormat('#,##0').format(double.parse(price).toInt())} Bath"
                              .text
                              .color(greyDark)
                              .fontFamily(regular)
                              .size(14)
                              .make(),
                        ],
                      ),
                    ),
                  ],
                )
                    .box
                    .white
                    .margin(const EdgeInsets.symmetric(horizontal: 3))
                    .rounded
                    .border(color: greyLine)
                    .make()
                    .onTap(() {
                  Get.to(() => ItemDetails(
                        title: productName,
                        data: product,
                      ));
                }));
          },
        );
      },
    );
  }

Widget buildMatchTab(BuildContext context) {
  Query query = FirebaseFirestore.instance
      .collection(productsCollection)
      .where('p_mixmatch', isNotEqualTo: null);

  return StreamBuilder<QuerySnapshot>(
    stream: query.snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (!snapshot.hasData) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      Map<String, List<DocumentSnapshot>> mixMatchMap = {};

      for (var doc in snapshot.data!.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String mixMatchKey = data['p_mixmatch'];
        if (!mixMatchMap.containsKey(mixMatchKey)) {
          mixMatchMap[mixMatchKey] = [];
        }
        mixMatchMap[mixMatchKey]!.add(doc);
      }

      var validPairs = mixMatchMap.entries
          .where((entry) => entry.value.length == 2)
          .toList();

      // Sort pairs to ensure 'top' appears before 'lower'
      for (var entry in validPairs) {
        entry.value.sort((a, b) {
          var dataA = a.data() as Map<String, dynamic>;
          var dataB = b.data() as Map<String, dynamic>;
          if (dataA['p_part'] == 'top' && dataB['p_part'] == 'lower') {
            return -1;
          } else if (dataA['p_part'] == 'lower' && dataB['p_part'] == 'top') {
            return 1;
          }
          return 0;
        });
      }

      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 1.25,
        ),
        itemCount: validPairs.length,
        itemBuilder: (BuildContext context, int index) {
          if (index >= validPairs.length) {
            return Container();
          }
          var pair = validPairs[index].value;
          if (pair.length < 2) {
            return Container();
          }
            var data1 = pair[0].data() as Map<String, dynamic>;
            var data2 = pair[1].data() as Map<String, dynamic>;

            String vendorName1 = data1['p_seller'];
            String vendorName2 = data2['p_seller'];

<<<<<<< HEAD
            String vendor_id = data1['vendor_id'];
=======
          List<dynamic> collectionList = data1['p_mixmatch_collection'];
          String description = data1['p_mixmatch_desc'];
          String genderMatch = data1['p_mixmatch_sex'];
>>>>>>> d0e99ee (MatchDetailScreen gender)

            List<dynamic> collectionList = data1['p_mixmatch_collection'];
            String description = data1['p_mixmatch_desc'];

            String price1 = data1['p_price'].toString();
            String price2 = data2['p_price'].toString();
            String totalPrice =
                (int.parse(price1) + int.parse(price2)).toString();

            String productName1 = data1['p_name'];
            String productName2 = data2['p_name'];

            String productImage1 = data1['p_imgs'][0];
            String productImage2 = data2['p_imgs'][0];

            String gender = data1['p_mixmatch_sex'];

            bool isTop1 = data1['p_part'] == 'top';
            bool isTop2 = data2['p_part'] == 'top';

            // Ensure top items are displayed at the top
            var topProductData = isTop1 ? data1 : data2;
            var lowerProductData = isTop1 ? data2 : data1;

            var topProductImage = isTop1 ? productImage1 : productImage2;
            var lowerProductImage = isTop1 ? productImage2 : productImage1;

            var topProductName = isTop1 ? productName1 : productName2;
            var lowerProductName = isTop1 ? productName2 : productName1;

            var topPrice = isTop1 ? price1 : price2;
            var lowerPrice = isTop1 ? price2 : price1;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MatchDetailScreen(
                      price1: price1,
                      price2: price2,
                      productName1: productName1,
                      productName2: productName2,
                      productImage1: productImage1,
                      productImage2: productImage2,
                      totalPrice: totalPrice,
                      vendorName1: vendorName1,
                      vendorName2: vendorName2,
                      vendor_id: vendor_id,
                      collection: collectionList,
                      description: description,
<<<<<<< HEAD
                      gender: gender,
=======
                      genderMatch: genderMatch,
>>>>>>> d0e99ee (MatchDetailScreen gender)
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: [
                      Row(
                        children: [
                          Image.network(
                            productImage1.isNotEmpty
                                ? productImage1
                                : imgError,
                            width: 80,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Image.asset(imgError,
                                  width: 80, height: 90, fit: BoxFit.cover);
                            },
                          ),
                          5.widthBox,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 200,
                                  child: Text(
                                    productName1,
                                    style: const TextStyle(
                                      fontFamily: medium,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                Text(
                                  "${NumberFormat('#,##0').format(double.parse(price1).toInt())} Bath",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      5.heightBox,
                      Row(
                        children: [
                          Image.network(
                            productImage2,
                            width: 80,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                          5.widthBox,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 200,
                                  child: Text(
                                    productName2,
                                    style: const TextStyle(
                                      fontFamily: medium,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                Text(
                                  "${NumberFormat('#,##0').format(double.parse(price2).toInt())} Bath",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      children: [
                        Text(
                          "Price: ",
                          style: TextStyle(
                              color: blackColor,
                              fontFamily: regular,
                              fontSize: 14),
                        ),
                        Text(
                          "${NumberFormat('#,##0').format(double.parse(totalPrice).toInt())} ",
                          style: TextStyle(
                              color: blackColor,
                              fontFamily: medium,
                              fontSize: 16),
                        ),
                        Text(
                          "Bath",
                          style: TextStyle(
                              color: blackColor,
                              fontFamily: regular,
                              fontSize: 14),
                        ),
                      ],
                    ),
                  )
                ],
              )
                  .box
                  .padding(EdgeInsets.all(6))
                  .margin(EdgeInsets.symmetric(horizontal: 4, vertical: 6))
                  .roundedSM
                  .border(color: greyLine)
                  .make());
        },
      );
    },
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
      barrierColor: blackColor,
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
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
      transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
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



void showModalRightSheet({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: blackColor,
    transitionDuration: Duration(milliseconds: 200),
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
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
    transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
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
