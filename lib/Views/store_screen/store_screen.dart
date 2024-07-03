import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/cart_screen/cart_screen.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:flutter_finalproject/Views/store_screen/matchstore_detail.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StoreScreen extends StatelessWidget {
  final String vendorId;
  final String title;

  const StoreScreen({Key? key, required this.vendorId, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                            border: Border.all(color: greyLine, width: 3),
                          ),
                          child: ClipOval(
                              child:
                                  loadingIndicator() /* Image.asset(
                              imgProfile,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ), */
                              ),
                        );
                      } else if (snapshot.hasData) {
                        return Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: greyLine, width: 3),
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
                            border: Border.all(color: greyLine, width: 3),
                          ),
                          child: ClipOval(
                              child:
                                  loadingIndicator() /* Image.asset(
                              imgProfile,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ), */
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
                  child: TabBarView(
                    children: [
                      buildProductGridAll(),
                      buildProductGrid('t-shirts', 't-shirts'),
                      buildProductGrid('skirts', 'skirts'),
                      buildProductGrid('pants', 'pants'),
                      buildProductGrid('dresses', 'dresses'),
                      buildProductGrid('jackets', 'jackets'),
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

  Widget buildMatchTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('storemixandmatchs')
          .where('vendor_id', isEqualTo: vendorId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          print(snapshot.error);
          return Center(
            child: Text(
              "An error occurred: ${snapshot.error}",
              style: TextStyle(color: greyDark),
            ),
          );
        }

        var data = snapshot.data!.docs;

        if (data.isEmpty) {
          return Center(
            child:
                Text("No posts available!", style: TextStyle(color: greyDark)),
          );
        }

        // Shuffle data to randomize
        data.shuffle(Random());

        return GridView.builder(
          padding: EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 5.3 / 6,
          ),
          itemCount: data.length,
          itemBuilder: (context, index) {
            var doc = data[index];
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(
                    child: Text(
                      "An error occurred: ${snapshot.error}",
                      style: TextStyle(color: greyDark),
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var snapshotTop = snapshot.data![0];
                var snapshotLower = snapshot.data![1];

                if (!snapshotTop.exists || !snapshotLower.exists) {
                  return Center(child: Text("One or more products not found"));
                }

                var productDataTop = snapshotTop.data() as Map<String, dynamic>;
                var productDataLower =
                    snapshotLower.data() as Map<String, dynamic>;

                var topImage =
                    (productDataTop['imgs'] as List<dynamic>?)?.first ?? '';
                var lowerImage =
                    (productDataLower['imgs'] as List<dynamic>?)?.first ?? '';
                var productNameTop = productDataTop['name'] ?? '';
                var productNameLower = productDataLower['name'] ?? '';
                var priceTop = productDataTop['price']?.toString() ?? '0';
                var priceLower = productDataLower['price']?.toString() ?? '0';

                return GestureDetector(
                  onTap: () {
                    Get.to(() => MatchStoreDetailScreen(
                          documentId: doc.id,
                        ));
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                    style: const TextStyle(color: greyColor),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                    style: const TextStyle(color: greyColor),
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
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 8.5,
            childAspectRatio: 5.7 / 7,
          ),
          itemCount: products.length,
          itemBuilder: (BuildContext context, int index) {
            var product = products[index].data() as Map<String, dynamic>;
            String productName = product['name'];
            String price = product['price'];
            String productImage = product['imgs'][0];

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
                // clipBehavior: Clip.antiAlias,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(4),
                // ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(14),
                        topLeft: Radius.circular(14),
                      ),
                      child: Image.network(productImage,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 180),
                    ),
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
              ).box.color(whiteColor).border(color: greyLine).rounded.make(),
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
      query = query.where('subcollection', isEqualTo: subcollection);
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
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 0,
            childAspectRatio: 5.5 / 7,
          ),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
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
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(14),
                          topLeft: Radius.circular(14),
                        ),
                        child: Image.network(
                          productImage,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 180,
                        ),
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
                  )
                      .box
                      .border(color: greyLine)
                      .rounded
                      .color(whiteColor)
                      .make(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<String> fetchSellerImgs(String vendorId) async {
    try {
      DocumentSnapshot vendorSnapshot = await FirebaseFirestore.instance
          .collection('vendors')
          .doc(vendorId)
          .get();

      if (vendorSnapshot.exists) {
        var vendorData = vendorSnapshot.data() as Map<String, dynamic>;
        return vendorData['imageUrl'] ?? 'Error product image';
      } else {
        return 'Error product image';
      }
    } catch (e) {
      print('An error occurred fetching data: $e');
      return 'Error product image';
    }
  }
}
