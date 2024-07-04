import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/cart_screen/cart_screen.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/match_screen/matchpost_details.dart';
import 'package:flutter_finalproject/Views/search_screen/recent_search_screen.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:flutter_finalproject/Views/store_screen/matchstore_detail.dart';
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
                MaterialPageRoute(builder: (context) => SearchScreenPage()),
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
                Icon(Icons.search, color: greyDark),
              ],
            )
                .box
                .padding(EdgeInsets.symmetric(horizontal: 16, vertical: 10))
                .margin(EdgeInsets.symmetric(horizontal: 28, vertical: 8))
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
                buildMatchTab(),
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
            length: 6,
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
                    Tab(text: 'T-shirts'),
                    Tab(text: 'Skirts'),
                    Tab(text: 'Pants'),
                    Tab(text: 'Dresses'),
                    Tab(text: 'Jackets'),
                  ],
                ).box.color(thinPrimaryApp).make(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: TabBarView(
                      children: [
                        buildProductGrid('All'),
                        buildProductGrid('t-shirts'),
                        buildProductGrid('skirts'),
                        buildProductGrid('pants'),
                        buildProductGrid('dresses'),
                        buildProductGrid('jackets'),
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
      query = query.where('subcollection', isEqualTo: category);
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
            String productName = product.get('name');
            String price = product.get('price');
            String productImage = product.get('imgs')[0];

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

  Widget buildMatchTab() {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('storemixandmatchs')
                .orderBy('views', descending: true)
                .snapshots(),
            builder: (context, storeSnapshot) {
              if (!storeSnapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              var storeDocs = storeSnapshot.data!.docs;

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('usermixandmatch')
                    .orderBy('views', descending: true)
                    .snapshots(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var userDocs = userSnapshot.data!.docs;
                  var combinedData = List.from(storeDocs)..addAll(userDocs);
                  combinedData.shuffle(Random());

                  if (combinedData.isEmpty) {
                    return Center(
                      child: Text("No posts available!",
                          style: TextStyle(color: greyDark)),
                    );
                  }

                  return GridView.builder(
                    padding: EdgeInsets.all(12),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 7.3 / 9,
                    ),
                    itemCount: combinedData.length,
                    itemBuilder: (context, index) {
                      var doc = combinedData[index];
                      var docData = doc.data() as Map<String, dynamic>;
                      var productIdTop = docData['product_id_top'] ?? '';
                      var productIdLower = docData['product_id_lower'] ?? '';

                      return FutureBuilder<List<DocumentSnapshot>>(
                        future: Future.wait([
                          FirebaseFirestore.instance
                              .collection('products')
                              .doc(productIdTop)
                              .get(),
                          FirebaseFirestore.instance
                              .collection('products')
                              .doc(productIdLower)
                              .get()
                        ]),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }

                          var snapshotTop = snapshot.data![0];
                          var snapshotLower = snapshot.data![1];

                          if (!snapshotTop.exists || !snapshotLower.exists) {
                            return Center(
                                child: Text("One or more products not found"));
                          }

                          var productDataTop =
                              snapshotTop.data() as Map<String, dynamic>;
                          var productDataLower =
                              snapshotLower.data() as Map<String, dynamic>;

                          var topImage =
                              (productDataTop['imgs'] as List<dynamic>?)
                                      ?.first ??
                                  '';
                          var lowerImage =
                              (productDataLower['imgs'] as List<dynamic>?)
                                      ?.first ??
                                  '';
                          var productNameTop = productDataTop['name'] ?? '';
                          var productNameLower = productDataLower['name'] ?? '';
                          var priceTop =
                              productDataTop['price']?.toString() ?? '0';
                          var priceLower =
                              productDataLower['price']?.toString() ?? '0';
                          var collections = docData['collection'] != null
                              ? List<String>.from(docData['collection'])
                              : [];
                          var situations = docData['situations'] != null
                              ? List<String>.from(docData['situations'])
                              : [];
                          var description = docData['description'] ?? '';
                          var views = docData['views'] ?? 0;
                          var gender = docData['gender'] ?? '';
                          var postedBy =
                              docData['vendor_id'] ?? docData['user_id'] ?? '';

                          return GestureDetector(
                            onTap: () {
                              if (doc.reference.parent.id ==
                                  'storemixandmatchs') {
                                Get.to(() => MatchStoreDetailScreen(
                                      documentId: doc.id,
                                    ));
                              } else {
                                Get.to(() => MatchPostsDetails(
                                      docId: doc.id,
                                      productName1: productNameTop,
                                      productName2: productNameLower,
                                      price1: priceTop,
                                      price2: priceLower,
                                      productImage1: topImage,
                                      productImage2: lowerImage,
                                      totalPrice: (int.parse(priceTop) +
                                              int.parse(priceLower))
                                          .toString(),
                                      vendorName1: 'Vendor Name 1',
                                      vendorName2: 'Vendor Name 2',
                                      vendor_id: doc.id,
                                      collection: collections,
                                      description: description,
                                      gender: gender,
                                      posted_by: postedBy,
                                      situations: situations,
                                    ));
                              }
                            },
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 75,
                                        height: 80,
                                        child: Image.network(
                                          topImage,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              productNameTop,
                                              style: const TextStyle(
                                                fontFamily: medium,
                                                fontSize: 14,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            Text(
                                              "${NumberFormat('#,##0').format(double.parse(priceTop).toInt())} Bath",
                                              style: const TextStyle(
                                                  color: greyColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 75,
                                        height: 80,
                                        child: Image.network(
                                          lowerImage,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              productNameLower,
                                              style: const TextStyle(
                                                fontFamily: medium,
                                                fontSize: 14,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            Text(
                                              "${NumberFormat('#,##0').format(double.parse(priceLower).toInt())} Bath",
                                              style: const TextStyle(
                                                  color: greyColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Total ${NumberFormat('#,##0').format(int.parse(priceTop) + int.parse(priceLower))} Bath",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: medium,
                                          color: blackColor,
                                        ),
                                      ),
                                    ],
                                  ).paddingSymmetric(horizontal: 8),
                                ],
                              )
                                  .box
                                  .border(color: greyLine)
                                  .rounded
                                  .padding(EdgeInsets.all(8))
                                  .make(),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
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
      barrierColor: greyDark,
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
