import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/cart_screen/cart_screen.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/news_screen/component/search_screen.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:flutter_finalproject/Views/store_screen/mixandmatch_detail.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/news_controller.dart';
import 'package:flutter_finalproject/services/firestore_services.dart'
    as MyFirestoreServices;
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProductScreen extends StatelessWidget {
  final int initialTabIndex;
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ProductScreen({Key? key, this.initialTabIndex = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
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
      body: ProductMatchTabs(context, initialTabIndex),
    );
  }

   Widget ProductMatchTabs(BuildContext context, int initialTabIndex) {
    return DefaultTabController(
      length: 2,
      initialIndex: initialTabIndex,
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: TextFormField(
                    controller: searchController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      suffixIcon: Icon(Icons.search, color: greyDark).onTap(() {
                        if (searchController.text.isNotEmpty) {
                          Get.to(() => SearchScreen(
                                title: searchController.text,
                              ));
                        }
                      }),
                      filled: true,
                      fillColor: whiteColor,
                      hintText: 'Search',
                      hintStyle: TextStyle(color: greyColor),
                      contentPadding: EdgeInsets.symmetric(horizontal: 25),
                    ),
                  ),
                ).box.border(color: greyColor, width: 0.5).roundedLg.make(),
              ),
              10.widthBox,
              IconButton(
                icon: Icon(
                  Icons.filter_list_rounded,
                  color: greyDark,
                  size: 30,
                ),
                onPressed: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
              ).box.border(color: greyColor, width: 0.5).roundedLg.make(),
            ],
          ).box.margin(EdgeInsets.fromLTRB(18, 0, 18, 10)).make(),
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
                        buildProductGridAll(),
                        buildProductGrid('dresses', 'dresses'),
                        buildProductGrid(
                            'outerwear & Costs', 'outerwear & Costs'),
                        buildProductGrid('blazers', 'blazers'),
                        buildProductGrid('suits', 'suits'),
                        buildProductGrid('blouses & Tops', 'blouses & Tops'),
                        buildProductGrid('knitwear', 'knitwear'),
                        buildProductGrid('t-shirts', 't-shirts'),
                        buildProductGrid('skirts', 'skirts'),
                        buildProductGrid('pants', 'pants'),
                        buildProductGrid('denim', 'denim'),
                        buildProductGrid('activewear', 'activewear'),
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

  Widget buildMatchTab(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5),
            child: DefaultTabController(
              length: 1,
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: TabBarView(
                      children: [
                        _buildProductMathGrids('All'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProductGridAll() {
    var controller = Get.find<NewsController>();

    return StreamBuilder(
      stream: MyFirestoreServices.FirestoreServices.allproducts(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: loadingIndicator(),
          );
        } else {
          var allproductsdata = snapshot.data!.docs;
          return GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: allproductsdata.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 8,
              mainAxisExtent: 260,
            ),
            itemBuilder: (context, index) {
              if (index >= allproductsdata.length) {
                return Container();
              }
              var product = allproductsdata[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Image.network(
                      product['p_imgs'][0],
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
                          product['p_name'],
                          style: TextStyle(
                            fontFamily: medium,
                            fontSize: 16,
                            color: blackColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        "${NumberFormat('#,##0').format(double.parse(product['p_price']).toInt())} Bath"
                            .text
                            .color(greyDark)
                            .fontFamily(regular)
                            .size(14)
                            .make(),
                      ],
                    ),
                  )
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
                      title: product['p_name'],
                      data: product,
                    ));
              });
            },
          );
        }
      },
    );
  }

  Widget buildProductGrid(String category, String subcollection) {
    Query query = FirebaseFirestore.instance.collection(productsCollection);

    if (subcollection != 'All') {
      query = query.where('p_subcollection', isEqualTo: subcollection);
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
              mainAxisSpacing: 20,
              crossAxisSpacing: 8,
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

  Widget _buildProductMathGrids(String category) {
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

            String vendor_id = data1['vendor_id'];

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
}
