// ignore_for_file: unused_local_variable, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/store_screen/match_detail_screen.dart';
import 'package:flutter_finalproject/Views/widgets_common/home_buttons.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/consts/lists.dart';
import 'package:flutter_finalproject/controllers/news_controller.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:get/get.dart';

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
        // actions: <Widget>[
        //   Padding(
        //     padding: const EdgeInsets.only(right: 15.0),
        //     child: IconButton(
        //       icon: Image.asset(
        //         icCart,
        //         width: 21,
        //       ),
        //       onPressed: () {
        //         Get.to(() => const CartScreen());
        //       },
        //     ),
        //   ),
        // ],
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        color: whiteColor,
        width: context.screenWidth,
        height: context.screenHeight,
        child: SafeArea(
            child: Column(
          children: [
            // Container(
            //   alignment: Alignment.center,
            //   height: 60,
            //   color: whiteColor,
            //   child: TextFormField(
            //     controller: controller.searchController,
            //     decoration: InputDecoration(
            //       border: InputBorder.none,
            //       suffixIcon: const Icon(Icons.search).onTap(() {
            //         if (controller.searchController.text.isNotEmptyAndNotNull){
            //           Get.to(() => SearchScreen(
            //             title: controller.searchController.text,
            //         ));
            //         }
            //       }),
            //       filled: true,
            //       fillColor: greyDark1,
            //       hintText: searchanything,
            //       // hintStyle: const TextStyle(color: greyDark1),
            //     ),
            //   ),
            // ),

            // 1nd swiper
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    VxSwiper.builder(
                        aspectRatio: 16 / 9,
                        autoPlay: true,
                        height: 170,
                        enlargeCenterPage: true,
                        itemCount: sliderslist.length,
                        itemBuilder: (context, index) {
                          return Image.asset(
                            sliderslist[index],
                            fit: BoxFit.fill,
                          )
                              .box
                              .rounded
                              .clip(Clip.antiAlias)
                              .margin(const EdgeInsets.symmetric(horizontal: 8))
                              .make();
                        }),

                    10.heightBox,

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: List.generate(
                    //     2,
                    //     (index) => homeButtons(
                    //       height: context.screenHeight * 0.1,
                    //       width: context.screenWidth / 2.3,
                    //       icon: index == 0 ? icTodaysDeal : icFlashDeal,
                    //       title: index == 0 ? todayDeal : flashsale,
                    //     ),
                    //   ),
                    // ),

                    // 10.heightBox,

                    // 2nd swiper
                    // VxSwiper.builder(
                    //     aspectRatio: 16 / 9,
                    //     autoPlay: true,
                    //     height: 170,
                    //     enlargeCenterPage: true,
                    //     itemCount: secondSlidersList.length,
                    //     itemBuilder: (context, index) {
                    //       return Image.asset(
                    //         secondSlidersList[index],
                    //         fit: BoxFit.fill,
                    //       )
                    //           .box
                    //           .rounded
                    //           .clip(Clip.antiAlias)
                    //           .margin(const EdgeInsets.symmetric(horizontal: 8))
                    //           .make();
                    //     }),

                    10.heightBox,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        3,
                        (index) => homeButtons(
                          height: context.screenHeight * 0.1,
                          width: context.screenWidth / 3.5,
                          icon: index == 0
                              ? icTopCategories
                              : index == 1
                                  ? icBrand
                                  : icTopCategories,
                          title: index == 0
                              ? topCategories
                              : index == 1
                                  ? brand
                                  : topSellers,
                        ),
                      ),
                    ),

                    // 20.heightBox,
                    // Align(
                    //     alignment: Alignment.centerLeft,
                    //     child: featuredCategories.text
                    //         .color(blackColor)
                    //         .size(18)
                    //         .fontFamily(regular)
                    //         .make()),
                    // 20.heightBox,

                    // SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     children: List.generate(
                    //         3,
                    //         (index) => Column(
                    //               children: [
                    //                 featuredButton(
                    //                     icon: featuredImages1[index],
                    //                     title: freaturedTitles1[index]),
                    //                 10.heightBox,
                    //                 featuredButton(
                    //                     icon: featuredImages2[index],
                    //                     title: freaturedTitles2[index]),
                    //               ],
                    //             )),
                    //   ),
                    // ),

                    // 20.heightBox,

                    // Container(
                    //   padding: const EdgeInsets.all(12),
                    //   width: double.infinity,
                    //   color: primaryApp,
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       featuredProduct.text.white
                    //           .fontFamily(bold)
                    //           .size(18)
                    //           .make(),
                    //       10.heightBox,
                    //       SingleChildScrollView(
                    //         scrollDirection: Axis.horizontal,
                    //         child: FutureBuilder(
                    //           future: FirestoreServices.getFeaturedProducts(),
                    //           builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {

                    //             if(!snapshot.hasData) {
                    //               return Center(
                    //                 child: loadingIndcator(),
                    //               );
                    //             } else if (snapshot.data!.docs.isEmpty) {
                    //               return "No featured products".text.white.makeCentered();
                    //             } else {

                    //               var featuredData = snapshot.data!.docs;

                    //               return Row(
                    //               children: List.generate(
                    //                 featuredData.length,
                    //                 (index) => Column(
                    //                   crossAxisAlignment: CrossAxisAlignment.start,
                    //                       children: [
                    //                         Image.network(
                    //                           featuredData[index]['p_imgs'][0],
                    //                           width: 140,
                    //                           height: 195,
                    //                           fit: BoxFit.cover,
                    //                         ),
                    //                         10.heightBox,
                    //                         "${ featuredData[index]['p_name']}"
                    //                             .text
                    //                             .fontFamily(regular)
                    //                             .color(blackColor)
                    //                             .make(),
                    //                         5.heightBox,
                    //                         "${featuredData[index]['p_price']}"
                    //                             .numCurrency
                    //                             .text
                    //                             .color(primaryApp)
                    //                             .fontFamily(bold)
                    //                             .size(16)
                    //                             .make()
                    //                       ],
                    //                     )
                    //                         .box
                    //                         .white
                    //                         .margin(
                    //                             const EdgeInsets.symmetric(horizontal: 4))
                    //                         .rounded
                    //                         .padding(const EdgeInsets.all(8))
                    //                         .make()
                    //                         .onTap(() {
                    //                           Get.to(() => ItemDetails(title: "${featuredData[index]['p_name']}",
                    //                           data: featuredData[index],));
                    //                         })),
                    //               );
                    //             }
                    //           },
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),

                    // 20.heightBox,

                    // 3nd swiper
                    // VxSwiper.builder(
                    //     aspectRatio: 16 / 9,
                    //     autoPlay: true,
                    //     height: 170,
                    //     enlargeCenterPage: true,
                    //     itemCount: secondSlidersList.length,
                    //     itemBuilder: (context, index) {
                    //       return Image.asset(
                    //         secondSlidersList[index],
                    //         fit: BoxFit.fill,
                    //       )
                    //           .box
                    //           .rounded
                    //           .clip(Clip.antiAlias)
                    //           .margin(const EdgeInsets.symmetric(horizontal: 8))
                    //           .make();
                    //     }),

                    // 20.heightBox,

                    // Align(
                    //     alignment: Alignment.centerLeft,
                    //     child: allproducts.text
                    //         .fontFamily(regular)
                    //         .color(redColor)
                    //         .size(18)
                    //         .make()),
                    30.heightBox,

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        'MATCH'
                            .text
                            .fontFamily(medium)
                            .color(greyDark2)
                            .size(22)
                            .make(),
                        SizedBox(height: 6),
                        Image.asset(
                          icUndertext,
                          width: 170,
                        ),
                        SizedBox(height: 6),
                      ],
                    ),

                    10.heightBox,

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // Ensure alignment if needed
                      children: [
                        'PRODUCT'
                            .text
                            .fontFamily(medium)
                            .color(greyDark2)
                            .size(22)
                            .make(),
                        Container(
                          child: GestureDetector(
                            child: Image.asset(
                              icUndertext,
                              width: 170,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 10,
                    ),

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
                          allproductsdata.shuffle(math
                              .Random()); // Shuffle the list using Dart's Random

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
                                  Image.network(
                                    allproductsdata[index]['p_imgs'][0],
                                    width: 180,
                                    height: 210,
                                    fit: BoxFit.cover,
                                  ),
                                  // const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0), 
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${allproductsdata[index]['p_name']}",
                                          style: TextStyle(
                                            fontFamily: medium,
                                            fontSize: 17,
                                            color: blackColor,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow
                                              .ellipsis, // ใช้ ellipsis สำหรับข้อความที่เกิน
                                        ),
                                           Text(
                                            "${allproductsdata[index]['p_price']} Bath",
                                            style: TextStyle(
                                              fontFamily: regular,
                                              fontSize: 14,
                                              color:greyDark1, 
                                            ),
                                          ),
                                        SizedBox(height: 10), // ให้ระยะห่างด้านล่าง
                                      ],
                                    ),
                                  )
                                ],
                              )
                                  .box
                                  .white
                                  .rounded
                                  .shadowSm
                                  .margin(
                                      const EdgeInsets.symmetric(horizontal: 2))
                                  .rounded
                                  // .padding(const EdgeInsets.all(12))
                                  .make()
                                  .onTap(() {
                                Get.to(() => ItemDetails(
                                      title:
                                          "${allproductsdata[index]['p_name']}",
                                      data: allproductsdata[index].data() as Map<String, dynamic>,
                                    ));
                              });
                            },
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
