// ignore_for_file: unused_local_variable, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/news_screen/allStore_screen.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/store_screen/mixandmatch_detail.dart';
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
                        height: 195,
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
                                      icSeeall,
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
                                          var vendorId = allproductsdata[index]
                                              ['vendor_id'];
                                          print(
                                              "Navigating to StoreScreen with vendor_id: $vendorId");
                                          Get.to(() =>
                                              StoreScreen(vendorId: vendorId));
                                        },
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${allproductsdata[index]['vendor_name']}",
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
                                                horizontal: 24, vertical: 12))
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
                      //popular product
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

                                        // Sort the products by the length of p_wishlist in descending order
                                        allProductsData.sort((a, b) {
                                          int aWishlistCount =
                                              a['p_wishlist'] != null
                                                  ? a['p_wishlist'].length
                                                  : 0;
                                          int bWishlistCount =
                                              b['p_wishlist'] != null
                                                  ? b['p_wishlist'].length
                                                  : 0;
                                          return bWishlistCount
                                              .compareTo(aWishlistCount);
                                        });

                                        // Limit to top 10 products
                                        var topProductsData =
                                            allProductsData.take(10).toList();

                                        return GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 10 / 4,
                                            mainAxisSpacing: 3,
                                            crossAxisSpacing: 10,
                                          ),
                                          itemCount: topProductsData.length,
                                          itemBuilder: (context, index) {
                                            var product =
                                                topProductsData[index];
                                            return GestureDetector(
                                              onTap: () {
                                                Get.to(() => ItemDetails(
                                                      title: product['p_name'],
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
                                                    image: product['p_imgs'][0],
                                                    price: product['p_price']
                                                        .toString(),
                                                    wishlist: product[
                                                                'p_wishlist'] !=
                                                            null
                                                        ? product['p_wishlist']
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
                      30.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          'MATCH BY STORE '
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
                                  icSeeall,
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
                      buildProductMathGrids(category),

                      //Product
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
                                  icSeeall,
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
                                mainAxisExtent: 280,
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
                                            allproductsdata[index]['p_imgs'][0],
                                            width: 200,
                                            height: 210,
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
                                            "${allproductsdata[index]['p_name']}",
                                            style: const TextStyle(
                                              fontFamily: medium,
                                              fontSize: 17,
                                              color: greyDark,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            "${NumberFormat('#,##0').format(double.parse(allproductsdata[index]['p_price']).toInt())} Bath",
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
                                            "${allproductsdata[index]['p_name']}",
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

  Widget buildProductMathGrids(String category) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        Map<String, List<DocumentSnapshot>> mixMatchMap = {};

        for (var doc in snapshot.data!.docs) {
          var data = doc.data() as Map<String, dynamic>;
          if (data['p_mixmatch'] != null) {
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
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 7,
            crossAxisSpacing: 7,
            mainAxisExtent: 240,
          ),
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
                  children: [
                    Row(
                      children: [
                        Image.network(
                          productImage1,
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
                                style: const TextStyle(color: greyColor),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    3.heightBox,
                    Row(
                      children: [
                        Image.network(
                          productImage2,
                          width: 80,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                        3.widthBox,
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
                                style: const TextStyle(color: greyColor),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        children: [
                          Text(
                            "Tatal: ",
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
                    .border(color: greyLine)
                    .p8
                    .margin(EdgeInsets.all(2))
                    .roundedSM
                    .make());
          },
          itemCount: 4,
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
            width: 60,
            height: 65,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                NumberFormat('#,##0 Bath', 'th').format(double.parse(price)),
              ).text.fontFamily(medium).size(13).make(),
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
