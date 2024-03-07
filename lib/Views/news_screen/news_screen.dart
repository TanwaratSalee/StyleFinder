import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/collection_screen/item_details.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/news_screen/component/featured_button.dart';
import 'package:flutter_finalproject/Views/news_screen/component/search_screen.dart';
import 'package:flutter_finalproject/Views/widgets_common/home_buttons.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/consts/images.dart';
import 'package:flutter_finalproject/consts/lists.dart';
import 'package:flutter_finalproject/consts/strings.dart';
import 'package:flutter_finalproject/consts/styles.dart';
import 'package:flutter_finalproject/controllers/news_controller.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    var allproducts = '';
    var controller = Get.find<NewsController>();

    return Container(
      padding: const EdgeInsets.all(12),
      color: bgGreylight,
      width: context.screenWidth,
      height: context.screenHeight,
      child: SafeArea(
          child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 60,
            color: bgGreylight,
            child: TextFormField(
              controller: controller.searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                suffixIcon: const Icon(Icons.search).onTap(() {
                  if (controller.searchController.text.isNotEmptyAndNotNull){
                    Get.to(() => SearchScreen(
                      title: controller.searchController.text,
                  ));
                  }
                }),
                filled: true,
                fillColor: whiteColor,
                hintText: searchanything,
                hintStyle: const TextStyle(color: fontGrey),
              ),
            ),
          ),

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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      2,
                      (index) => homeButtons(
                        height: context.screenHeight * 0.1,
                        width: context.screenWidth / 2.3,
                        icon: index == 0 ? icTodaysDeal : icFlashDeal,
                        title: index == 0 ? todayDeal : flashsale,
                      ),
                    ),
                  ),

                  10.heightBox,

                  // 2nd swiper
                  VxSwiper.builder(
                      aspectRatio: 16 / 9,
                      autoPlay: true,
                      height: 170,
                      enlargeCenterPage: true,
                      itemCount: secondSlidersList.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          secondSlidersList[index],
                          fit: BoxFit.fill,
                        )
                            .box
                            .rounded
                            .clip(Clip.antiAlias)
                            .margin(const EdgeInsets.symmetric(horizontal: 8))
                            .make();
                      }),

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

                  20.heightBox,
                  Align(
                      alignment: Alignment.centerLeft,
                      child: featuredCategories.text
                          .color(fontBlack)
                          .size(18)
                          .fontFamily(semibold)
                          .make()),
                  20.heightBox,

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                          3,
                          (index) => Column(
                                children: [
                                  featuredButton(
                                      icon: featuredImages1[index],
                                      title: freaturedTitles1[index]),
                                  10.heightBox,
                                  featuredButton(
                                      icon: featuredImages2[index],
                                      title: freaturedTitles2[index]),
                                ],
                              )),
                    ),
                  ),

                  20.heightBox,

                  Container(
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    color: primaryApp,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        featuredProduct.text.white
                            .fontFamily(bold)
                            .size(18)
                            .make(),
                        10.heightBox,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: FutureBuilder(
                            future: FirestoreServices.getFeaturedProducts(),
                            builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {

                              if(!snapshot.hasData) {
                                return Center(
                                  child: loadingIndcator(),
                                );
                              } else if (snapshot.data!.docs.isEmpty) {
                                return "No featured products".text.white.makeCentered();
                              } else {

                                var featuredData = snapshot.data!.docs;

                                return Row(
                                children: List.generate( 
                                  featuredData.length,
                                  (index) => Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Image.network(
                                            featuredData[index]['p_imgs'][0],
                                            width: 140,
                                            height: 195,
                                            fit: BoxFit.cover,
                                          ),
                                          10.heightBox,
                                          "${ featuredData[index]['p_name']}"
                                              .text
                                              .fontFamily(semibold)
                                              .color(fontBlack)
                                              .make(),
                                          5.heightBox,
                                          "${featuredData[index]['p_price']}"
                                              .numCurrency
                                              .text
                                              .color(primaryApp)
                                              .fontFamily(bold)
                                              .size(16)
                                              .make()
                                        ],
                                      )
                                          .box
                                          .white
                                          .margin(
                                              const EdgeInsets.symmetric(horizontal: 4))
                                          .rounded
                                          .padding(const EdgeInsets.all(8))
                                          .make()
                                          .onTap(() {
                                            Get.to(() => ItemDetails(title: "${featuredData[index]['p_name']}",
                                            data: featuredData[index],));
                                          })),
                                );
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),

                  20.heightBox,

                  // 3nd swiper
                  VxSwiper.builder(
                      aspectRatio: 16 / 9,
                      autoPlay: true,
                      height: 170,
                      enlargeCenterPage: true,
                      itemCount: secondSlidersList.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          secondSlidersList[index],
                          fit: BoxFit.fill,
                        )
                            .box
                            .rounded
                            .clip(Clip.antiAlias)
                            .margin(const EdgeInsets.symmetric(horizontal: 8))
                            .make();
                      }),

                  20.heightBox,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: allproducts.text.fontFamily(semibold).color(fontGreyDark).size(18).make()),
                  20.heightBox,

                  StreamBuilder(
                    stream: FirestoreServices.allproducts(), 
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                      if(!snapshot.hasData){
                        return loadingIndcator();
                      } else {
                        var allproductsdata = snapshot.data!.docs;
                        return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: allproductsdata.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing:8, mainAxisExtent: 300),
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          allproductsdata[index]['p_imgs'][0],
                                          width: 170,
                                          height: 210,
                                          fit: BoxFit.cover,
                                        ),
                                        const Spacer(),
                                        "${allproductsdata[index]['p_name']}"
                                            .text
                                            .fontFamily(semibold)
                                            .color(fontBlack)
                                            .make(),
                                        "${allproductsdata[index]['p_price']}"
                                            .text
                                            .color(primaryApp)
                                            .fontFamily(bold)
                                            .size(16)
                                            .make(),
                                            10.heightBox,
                                      ],
                                    )
                                        .box
                                        .white
                                        .margin(
                                            const EdgeInsets.symmetric(horizontal: 4))
                                        .rounded
                                        .padding(const EdgeInsets.all(12))
                                        .make().onTap(() {
                                          Get.to(( )=> ItemDetails(
                                            title: "${allproductsdata[index]['p_name']}",
                                            data: allproductsdata[index],
                                            ));
                                        });
                      });
                      }
                    }),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
