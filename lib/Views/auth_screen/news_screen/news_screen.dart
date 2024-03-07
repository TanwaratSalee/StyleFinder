import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/news_screen/component/featured_button.dart';
import 'package:flutter_finalproject/Views/widgets_common/home_buttons.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/consts/images.dart';
import 'package:flutter_finalproject/consts/lists.dart';
import 'package:flutter_finalproject/consts/strings.dart';
import 'package:flutter_finalproject/consts/styles.dart';
import 'package:velocity_x/velocity_x.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            color: fontGrey,
            child: TextFormField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                suffixIcon: Icon(Icons.search),
                filled: true,
                fillColor: whiteColor,
                hintText: searchanything,
                hintStyle: TextStyle(color: fontGrey),
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
                          child: Row(
                            children: List.generate( 6,
                                (index) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          product1,
                                          width: 150,
                                          fit: BoxFit.cover,
                                        ),
                                        10.heightBox,
                                        "Dress"
                                            .text
                                            .fontFamily(semibold)
                                            .color(fontBlack)
                                            .make(),
                                        10.heightBox,
                                        "\$600"
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
                                        .make()),
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

                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 6,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing:8, mainAxisExtent: 300),
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          product2,
                                          width: 170,
                                          height: 210,
                                          fit: BoxFit.cover,
                                        ),
                                        const Spacer(),
                                        "Dress"
                                            .text
                                            .fontFamily(semibold)
                                            .color(fontBlack)
                                            .make(),
                                        "\$600"
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
                                        .make();
                      })
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
