import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/cart_screen/cart_screen.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:flutter_finalproject/Views/store_screen/mixandmatch_detail.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StoreScreen extends StatelessWidget {
  final String vendorId;
  const StoreScreen({super.key, required this.vendorId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchSellerName(vendorId),
      builder: (context, snapshot) {
        String title = snapshot.hasData ? snapshot.data! : 'Loading...';
        return Scaffold(
          backgroundColor: whiteColor,
          appBar: AppBar(
            title: Text(title)
                .text
                .size(26)
                .fontFamily(semiBold)
                .color(blackColor)
                .make(),
            centerTitle: true,
            elevation: 0,
            actions: [
              IconButton(
                icon: Image.asset(icCart, width: 21),
                onPressed: () {
                  Get.to(() => const CartScreen());
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ShopProfile(context),
                ProductMatchTabs(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget ShopProfile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: FutureBuilder<String>(
                    future: fetchSellerImgs(vendorId),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: greyColor, width: 3),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              imgProfile,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        return Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: greyColor, width: 3),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              snapshot.data!,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: greyColor, width: 3),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              imgProfile,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget ProductMatchTabs(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: [
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
                  thickness: 2,
                  height: 3,
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.67,
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMatchTab(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(5),
          child: DefaultTabController(
            length: 1,
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.656,
                  child: TabBarView(
                    children: [
                      buildProductMathGrids('All'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(),
        ),
      ],
    );
  }

  Widget buildProductGridAll() {
    CollectionReference productsCollection =
        FirebaseFirestore.instance.collection('products');

    Query query = productsCollection.where('vendor_id', isEqualTo: vendorId);

    return FutureBuilder<QuerySnapshot>(
      future: query.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No Items'));
        }

        List<QueryDocumentSnapshot> products = snapshot.data!.docs;

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 1 / 1.35),
          itemCount: products.length,
          itemBuilder: (BuildContext context, int index) {
            var product = products[index].data() as Map<String, dynamic>;
            String productName = product['p_name'];
            String price = product['p_price'];
            String productImage = product['p_imgs'][0];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemDetails(
                      title: productName,
                      data: product,
                    ),
                  ),
                );
              },
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.network(productImage,
                        fit: BoxFit.cover, width: double.infinity, height: 190),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(productName,
                              style:
                                  TextStyle(fontFamily: medium, fontSize: 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          Text(
                              "${NumberFormat('#,##0').format(double.parse(price).toInt())} Bath",
                              style: TextStyle(
                                  color: greyColor, fontFamily: regular)),
                        ],
                      ),
                    ),
                  ],
                ),
              )
                  .box
                  .color(whiteColor)
                  .border(color: greyLine)
                  .margin(EdgeInsets.all(6))
                  .rounded
                  .make(),
            );
          },
        );
      },
    );
  }

  Widget buildProductGrid(String category, String subcollection) {
    Query query = FirebaseFirestore.instance
        .collection(productsCollection)
        .where('vendor_id', isEqualTo: vendorId);

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
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 1 / 1.35),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
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
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.network(
                      productImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 190,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          3.heightBox,
                          Text(
                            productName,
                            style: const TextStyle(
                              fontFamily: medium,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${NumberFormat('#,##0').format(double.parse(
                              '$price',
                            ).toInt())} Bath",
                            style: const TextStyle(
                                color: greyDark, fontFamily: regular),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).box.color(whiteColor).make(),
              ),
            );
          },
        );
      },
    );
  }

  Future<String> fetchSellerName(String vendorId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(productsCollection)
        .where('vendor_id', isEqualTo: vendorId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      return data['p_seller'] ?? 'Unknow Seller';
    } else {
      return 'Unknown Seller';
    }
  }

  Future<String> fetchSellerImgs(String vendorId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(vendorsCollection)
          .where('vendor_id', isEqualTo: vendorId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> data =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        return data['imageUrl'] ?? 'Error product image';
      } else {
        return 'Error product image';
      }
    } catch (e) {
      print('An error occurred fetching data: $e');
      return 'Error product image';
    }
  }

  Widget buildProductMathGrids(String category) {
    Query query = FirebaseFirestore.instance
        .collection(productsCollection)
        .where('vendor_id', isEqualTo: vendorId)
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

          if (data['vendor_id'] == vendorId && data['p_mixmatch'] != null) {
            String mixMatchKey = data['p_mixmatch'];
            if (!mixMatchMap.containsKey(mixMatchKey)) {
              mixMatchMap[mixMatchKey] = [];
            }
            mixMatchMap[mixMatchKey]!.add(doc);
          }
        }

        var validPairs = mixMatchMap.entries
            .where((entry) => entry.value.length == 2)
            .toList();

        int itemCount = validPairs.length;

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1 / 1.22,
          ),
          itemCount: itemCount,
          itemBuilder: (BuildContext context, int index) {
            var pair = validPairs[index].value;

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
                      gender: gender,
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
                            topProductImage.isNotEmpty
                                ? topProductImage
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
                                    topProductName,
                                    style: const TextStyle(
                                      fontFamily: medium,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                Text(
                                  "${NumberFormat('#,##0').format(double.parse(topPrice).toInt())} Bath",
                                  style: const TextStyle(color: greyDark),
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
                            lowerProductImage,
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
                                    lowerProductName,
                                    style: const TextStyle(
                                      fontFamily: medium,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                Text(
                                  "${NumberFormat('#,##0').format(double.parse(lowerPrice).toInt())} Bath",
                                  style: const TextStyle(color: greyDark),
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
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      children: [
                        Text(
                          "Total  ",
                          style: TextStyle(
                              color: greyDark,
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
                          " Bath",
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
                  .make(),
            );
          },
        );
      },
    );
  }
}
