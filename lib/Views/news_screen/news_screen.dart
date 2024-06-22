import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/match_screen/matchpost_details.dart';
import 'package:flutter_finalproject/Views/news_screen/allstore_screen.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/store_screen/matchstore_detail.dart';
import 'package:flutter_finalproject/Views/news_screen/product_screen.dart';
import 'package:flutter_finalproject/Views/store_screen/store_screen.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/consts/lists.dart';
import 'package:flutter_finalproject/controllers/news_controller.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../widgets_common/appbar_ontop.dart';

class NewsScreen extends StatelessWidget {
  final String category;

  const NewsScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var allproducts = '';
    var controller = Get.find<NewsController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        title: appbarField(context: context),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        color: whiteColor,
        width: context.screenWidth,
        height: context.screenHeight,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      VxSwiper.builder(
                        aspectRatio: 16 / 15,
                        autoPlay: true,
                        height: 180,
                        enlargeCenterPage: true,
                        itemCount: sliderslist.length,
                        itemBuilder: (context, index) {
                          return Image.asset(
                            secondSlidersList[index],
                            fit: BoxFit.fill,
                          ).box.rounded.make();
                        },
                      ),
                      30.heightBox,
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              'OFFICIAL STORE'
                                  .text
                                  .fontFamily(bold)
                                  .color(blackColor)
                                  .size(20)
                                  .make(),
                              InkWell(
                                onTap: () {
                                  Get.to(() => AllStoreScreen());
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('See All')
                                        .text
                                        .fontFamily(medium)
                                        .size(16)
                                        .color(blackColor)
                                        .make(),
                                    10.widthBox,
                                    Image.asset(
                                      icSeeAll,
                                      width: 14,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          15.heightBox,
                          StreamBuilder(
                            stream: FirestoreServices.allmatchbystore(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: loadingIndicator(),
                                );
                              } else {
                                var allproductsdata = snapshot.data!.docs;
                                allproductsdata.shuffle(math.Random());

                                int itemCount =
                                    math.min(allproductsdata.length, 4);

                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(itemCount, (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          var vendorId = allproductsdata[index]['vendor_id'];
                                          var vendorName = allproductsdata[index]['name']; 
                                          var vendorImg = allproductsdata[index]['imageUrl']; 
                                          print(
                                              "Navigating to StoreScreen with vendor_id: $vendorId");
                                          Get.to(() => StoreScreen(
                                                vendorId: vendorId,
                                                title:
                                                    vendorName, 
                                              ));
                                        },
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${allproductsdata[index]['name']}",
                                                style: const TextStyle(
                                                  fontFamily: medium,
                                                  fontSize: 17,
                                                  color: blackColor,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        )
                                            .box
                                            .white
                                            .roundedSM
                                            .border(color: greyLine)
                                            .margin(const EdgeInsets.symmetric(
                                                horizontal: 5))
                                            .padding(const EdgeInsets.symmetric(
                                                horizontal: 22, vertical: 8))
                                            .make(),
                                      );
                                    }),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      30.heightBox,
                      
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              'POPULAR PRODUCT'
                                  .text
                                  .fontFamily(bold)
                                  .color(blackColor)
                                  .size(20)
                                  .make(),
                              15.heightBox,
                              Column(
                                children: [
                                  StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection(productsCollection)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(
                                            child: loadingIndicator());
                                      } else {
                                        var allProductsData =
                                            snapshot.data!.docs;

                                        
                                        allProductsData.sort((a, b) {
                                          int aWishlistCount =
                                              a['favorite_uid'] != null
                                                  ? a['favorite_uid'].length
                                                  : 0;
                                          int bWishlistCount =
                                              b['favorite_uid'] != null
                                                  ? b['favorite_uid'].length
                                                  : 0;
                                          return bWishlistCount
                                              .compareTo(aWishlistCount);
                                        });

                                        
                                        var topProductsData =
                                            allProductsData.take(10).toList();

                                        return GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 9 / 4,
                                            mainAxisSpacing: 8,
                                            crossAxisSpacing: 10,
                                          ),
                                          itemCount: topProductsData.length,
                                          itemBuilder: (context, index) {
                                            var product =
                                                topProductsData[index];
                                            return GestureDetector(
                                              onTap: () {
                                                Get.to(() => ItemDetails(
                                                      title: product['name'],
                                                      data: product.data()
                                                          as Map<String,
                                                              dynamic>,
                                                    ));
                                              },
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ProductCard(
                                                    rank: index + 1,
                                                    image: product['imgs'][0],
                                                    price: product['price']
                                                        .toString(),
                                                    wishlist: product[
                                                                'favorite_uid'] !=
                                                            null
                                                        ? product['favorite_uid']
                                                            .length
                                                            .toString()
                                                        : '0',
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),

                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          'PRODUCT'
                              .text
                              .fontFamily(bold)
                              .color(blackColor)
                              .size(20)
                              .make(),
                          InkWell(
                            onTap: () {
                              Get.to(() => ProductScreen(initialTabIndex: 0));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('See All')
                                    .text
                                    .fontFamily(medium)
                                    .size(16)
                                    .color(blackColor)
                                    .make(),
                                10.widthBox,
                                Image.asset(
                                  icSeeAll,
                                  width: 14,
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                          .box
                          .padding(const EdgeInsets.fromLTRB(10, 45, 10, 0))
                          .roundedLg
                          .make(),
                      15.heightBox,
                      StreamBuilder(
                        stream: FirestoreServices.allproducts(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: loadingIndicator(),
                            );
                          } else {
                            var allproductsdata = snapshot.data!.docs;
                            allproductsdata.shuffle(math.Random());

                            int itemCount = math.min(allproductsdata.length, 4);

                            return GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: itemCount,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 8,
                                mainAxisExtent: 270,
                              ),
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(15.0),
                                            topRight: Radius.circular(15.0),
                                          ),
                                          child: Image.network(
                                            allproductsdata[index]['imgs'][0],
                                            width: 195,
                                            height: 205,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${allproductsdata[index]['name']}",
                                            style: const TextStyle(
                                              fontFamily: medium,
                                              fontSize: 17,
                                              color: greyDark,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            "${NumberFormat('#,##0').format(double.parse(allproductsdata[index]['price']).toInt())} Bath",
                                            style: const TextStyle(
                                              fontFamily: regular,
                                              fontSize: 14,
                                              color: greyDark,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                                    .box
                                    .white
                                    .rounded
                                    .border(color: greyLine)
                                    .margin(const EdgeInsets.symmetric(
                                        horizontal: 2))
                                    .make()
                                    .onTap(() {
                                  Get.to(() => ItemDetails(
                                        title:
                                            "${allproductsdata[index]['name']}",
                                        data: allproductsdata[index].data()
                                            as Map<String, dynamic>,
                                      ));
                                });
                              },
                            );
                          }
                        },
                      ),
                      20.heightBox,
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            'MATCHING'
                                .text
                                .fontFamily(bold)
                                .color(blackColor)
                                .size(20)
                                .make(),
                            InkWell(
                              onTap: () {
                                Get.to(() => ProductScreen(initialTabIndex: 1));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('See All')
                                      .text
                                      .fontFamily(medium)
                                      .size(16)
                                      .color(blackColor)
                                      .make(),
                                  10.widthBox,
                                  Image.asset(
                                    icSeeAll,
                                    width: 14,
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                            .box
                            .padding(const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10))
                            .roundedLg
                            .make(),
                      ),
                      Container(
                        width: double.infinity,
                        height: 570,
                        decoration: BoxDecoration(
                          color: whiteColor,
                        ),
                        child: DefaultTabController(
                          length: 2,
                          child: Builder(builder: (context) {
                            var tabController =
                                DefaultTabController.of(context)!;
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                  ),
                                  child: TabBar(
                                    controller: tabController,
                                    labelColor: primaryApp,
                                    unselectedLabelColor: Colors.black,
                                    indicator: UnderlineTabIndicator(
                                      borderSide: BorderSide(
                                        width: 3.0,
                                        color: primaryApp,
                                      ),
                                      insets: EdgeInsets.symmetric(
                                          horizontal:
                                              0), 
                                    ),
                                    tabs: [
                                      Tab(text: 'STORE'),
                                      Tab(text: 'GENERAL'),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: TabBarView(
                                      controller: tabController,
                                      children: [
                                        buildStoreMatch(),
                                        buildGeneralMatch(),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                AnimatedBuilder(
                                  animation: tabController,
                                  builder: (context, _) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 4,
                                          backgroundColor:
                                              tabController.index == 0
                                                  ? primaryApp
                                                  : Colors.grey,
                                        ),
                                        SizedBox(width: 10),
                                        CircleAvatar(
                                          radius: 4,
                                          backgroundColor:
                                              tabController.index == 1
                                                  ? primaryApp
                                                  : Colors.grey,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStoreMatch() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('storemixandmatchs')
          .orderBy('views', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        var data = snapshot.data!.docs;

        if (data.isEmpty) {
          return Center(
            child:
                Text("No posts available!", style: TextStyle(color: greyDark)),
          );
        }

        
        data.shuffle(Random());

        
        var limitedData = data.take(4).toList();

        return GridView.builder(
          
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 8.8 / 11,
          ),
          itemCount: limitedData.length,
          physics: const NeverScrollableScrollPhysics(), 
          itemBuilder: (context, index) {
            var doc = limitedData[index];
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
                        )
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

  Widget buildGeneralMatch() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('usermixandmatch')
          .orderBy('views', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        var data = snapshot.data!.docs;

        if (data.isEmpty) {
          return Center(
            child:
                Text("No posts available!", style: TextStyle(color: greyDark)),
          );
        }

        
        data.shuffle(Random());

        
        var limitedData = data.take(4).toList();

        return GridView.builder(
          
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 8.8 / 11,
          ),
          itemCount: limitedData.length,
          physics: const NeverScrollableScrollPhysics(), 
          itemBuilder: (context, index) {
            var doc = limitedData[index];
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
                var collections = docData['collection'] != null
                    ? List<String>.from(docData['collection'])
                    : [];
                var description = docData['description'] ?? '';
                var views = docData['views'] ?? 0;
                var gender = docData['gender'] ?? '';
                var postedBy = docData['user_id'] ?? '';

                return GestureDetector(
                  onTap: () {
                    Get.to(() => MatchPostsDetails(
                          docId: doc.id,
                          productName1: productNameTop,
                          productName2: productNameLower,
                          price1: priceTop,
                          price2: priceLower,
                          productImage1: topImage,
                          productImage2: lowerImage,
                          totalPrice:
                              (int.parse(priceTop) + int.parse(priceLower))
                                  .toString(),
                          vendorName1: 'Vendor Name 1',
                          vendorName2: 'Vendor Name 2',
                          vendor_id: doc.id,
                          collection: collections,
                          description: description,
                          gender: gender,
                          posted_by: postedBy,
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
                        )
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
}

class GridCardExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: 4,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        );
      },
    );
  }
}

class ButtonsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(10),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: List.generate(4, (index) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: () {
              print("Button $index pressed");
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(whiteColor),
              foregroundColor: MaterialStateProperty.all<Color>(greyDark),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              ),
            ),
            child: Text("Button ${index + 1}"),
          ),
        );
      }),
    );
  }
}

class ProductCard extends StatelessWidget {
  final int rank;
  final String image;
  final String price;
  final String wishlist;
  // final int likes;

  const ProductCard({
    Key? key,
    required this.rank,
    required this.image,
    required this.price,
    required this.wishlist,
    // required this.likes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: greyLine),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircleAvatar(
              backgroundColor: greyThin,
              child:
                  Text(rank.toString()).text.size(10).color(blackColor).make(),
            ),
          ),
          SizedBox(width: 5),
          Image.network(
            image,
            width: 55,
            height: 65,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    NumberFormat('#,##0', 'th').format(double.parse(price)),
                  ).text.fontFamily(medium).size(12).make(),
                  3.widthBox,
                  Text(
                    ('Bath'),
                  ).text.fontFamily(medium).size(12).make(),
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    icTapFavoriteButton,
                    width: 14,
                  ),
                  SizedBox(width: 5),
                  Text(
                    wishlist, // Display the wishlist count here
                    style: TextStyle(
                      fontFamily: regular,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ).box.padding(EdgeInsets.symmetric(horizontal: 6, vertical: 3)).make(),
    );
  }
}
