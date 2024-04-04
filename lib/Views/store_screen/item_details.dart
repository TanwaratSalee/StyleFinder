// ignore_for_file: deprecated_member_use, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/chat_screen/chat_screen.dart';
import 'package:flutter_finalproject/Views/store_screen/store_screen.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/consts/images.dart';
import 'package:flutter_finalproject/consts/strings.dart';
import 'package:flutter_finalproject/consts/styles.dart';
import 'package:flutter_finalproject/controllers/product_controller.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class ItemDetails extends StatelessWidget {
  final String? title;
  final dynamic data;
  const ItemDetails({Key? key, required this.title, this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());

    // print(Colors.black.value);

    return WillPopScope(
      onWillPop: () async {
        controller.resetValues();
        return true;
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                controller.resetValues();
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios)),
          title:
              title!.text.color(fontGreyDark).fontFamily(bold).size(18).make(),
        ),
        body: Column(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VxSwiper.builder(
                      autoPlay: true,
                      height: 420,
                      itemCount: data['p_imgs'].length ?? 0,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1.0,
                      itemBuilder: (context, index) {
                        return Image.network(
                          data['p_imgs'][index],
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                    ),

                    10.heightBox,
                    Row(
                      children: [
                        //
                        Text(
                          title ?? '',
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'regular',
                          ),
                        ),
                        const Spacer(),
                        Obx(
                          () => IconButton(
                            onPressed: () {
                              if (controller.isFav.value) {
                                controller.removeFromWishlist(data.id, context);
                              } else {
                                controller.addToWishlist(data.id, context);
                              }
                              controller.isFav.toggle();
                            },
                            icon: controller.isFav.value
                                ? Icon(Icons.favorite, color: redColor)
                                : Icon(Icons.favorite_outline),
                            iconSize: 20,
                          ),
                        )
                      ],
                    ),

                    2.heightBox,
                    VxRating(
                      isSelectable: false,
                      value: double.parse(data["p_rating"]),
                      onRatingUpdate: (value) {},
                      normalColor: fontGreyDark,
                      selectionColor: golden,
                      count: 5,
                      size: 25,
                      maxRating: 5,
                    ),
                    5.heightBox,
                    "${data['p_aboutProduct']}"
                        .text
                        .color(fontGrey)
                        .size(16)
                        .make(),
                    // 10.heightBox,
                    "${data['p_price']}"
                        .numCurrency
                        .text
                        .color(primaryApp)
                        .fontFamily(bold)
                        .size(22)
                        .make(),
                    20.heightBox,

                    Row(
                      children: [
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Seller".text.fontFamily(regular).make(),
                            5.heightBox,
                            "${data['p_seller']}"
                                .text
                                .fontFamily(regular)
                                .color(fontBlack)
                                .size(16)
                                .make(),
                          ],
                        )),
                        const CircleAvatar(
                          backgroundColor: primaryApp,
                          child: Icon(Icons.message_rounded, color: whiteColor),
                        ).onTap(() {
                          Get.to(
                            () => const ChatScreen(),
                            arguments: [data['p_seller'], data['vendor_id']],
                          );
                        }),
                        10.widthBox,
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              () => StoreScreen(),
                              // arguments: {
                              //   'seller': data['p_seller'],
                              //   'vendor_id': data['vendor_id']
                              // },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10), // ปรับค่าตามต้องการ
                            decoration: BoxDecoration(
                              color: primaryApp, // สีพื้นหลังของปุ่ม
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'See Store',
                              style: TextStyle(
                                  color: Colors.white, // สีข้อความในปุ่ม
                                  fontFamily: regular),
                            ),
                          ),
                        )
                      ],
                    )
                        .box
                        .height(60)
                        .padding(const EdgeInsets.symmetric(horizontal: 16))
                        .color(fontLightGrey)
                        .make(),
                    20.heightBox,

                    Obx(
                      () => Column(
                        children: [
                          // color rows
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child:
                                    "Color: ".text.color(fontGreyDark).make(),
                              ),
                              Row(
                                children: List.generate(
                                    data['p_colors'].length,
                                    (index) => Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            VxBox()
                                                .size(40, 40)
                                                .roundedFull
                                                .color(Color(
                                                        data['p_colors'][index])
                                                    .withOpacity(1.0))
                                                .margin(
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4))
                                                .make()
                                                .onTap(() {
                                              controller
                                                  .changeColorIndex(index);
                                            }),
                                            Visibility(
                                                visible: index ==
                                                    controller.colorIndex.value,
                                                child: const Icon(Icons.done,
                                                    color: Colors.white))
                                          ],
                                        )),
                              ),
                            ],
                          ).box.padding(const EdgeInsets.all(8)).make(),

                          //quantity row
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: "Quantity: "
                                    .text
                                    .color(fontGreyDark)
                                    .make(),
                              ),
                              Obx(
                                () => Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          controller.decreaseQuantity();
                                          controller.calculateTotalPrice(
                                              int.parse(data['p_price']));
                                        },
                                        icon: const Icon(Icons.remove)),
                                    controller.quantity.value.text
                                        .size(16)
                                        .color(fontGreyDark)
                                        .fontFamily(bold)
                                        .make(),
                                    IconButton(
                                        onPressed: () {
                                          controller.increaseQuantity(
                                              int.parse(data['p_quantity']));
                                          controller.calculateTotalPrice(
                                              int.parse(data['p_price']));
                                        },
                                        icon: const Icon(Icons.add)),
                                    10.heightBox,
                                    "(${data['p_quantity']} available)"
                                        .text
                                        .color(fontGreyDark)
                                        .make(),
                                  ],
                                ),
                              ),
                            ],
                          ).box.padding(const EdgeInsets.all(8)).make(),

                          // total row
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child:
                                    "Totle: ".text.color(fontGreyDark).make(),
                              ),
                              Row(
                                children: [
                                  "${controller.totalPrice.value}"
                                      .numCurrency
                                      .text
                                      .color(primaryApp)
                                      .size(16)
                                      .fontFamily(bold)
                                      .make(),
                                ],
                              ),
                            ],
                          ).box.padding(const EdgeInsets.all(8)).make(),
                        ],
                      ).box.white.shadowSm.make(),
                    ),

                    //Description section

                    10.heightBox,

                    "Description"
                        .text
                        .color(fontBlack)
                        .size(16)
                        .fontFamily(bold)
                        .make(),
                    5.heightBox,

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        data['p_desc'],
                        style: TextStyle(
                          color:
                              fontBlack, // สมมติว่า fontBlack คือตัวแปรที่เก็บค่าสี
                          fontSize: 14,
                        ),
                      ),
                    ),

                    //buttons sections
                    10.heightBox,

                    // ListView(
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   shrinkWrap: true,
                    //   children: List.generate(
                    //       itemDetailButtonsList.length,
                    //       (index) => ListTile(
                    //             title: itemDetailButtonsList[index]
                    //                 .text
                    //                 .fontFamily(regular)
                    //                 .color(fontBlack)
                    //                 .make(),
                    //             trailing: const Icon(Icons.arrow_forward),
                    //           )),
                    // ),
                    // 20.heightBox,

                    productsyoumaylike.text
                        .fontFamily(bold)
                        .size(16)
                        .color(fontBlack)
                        .make(),
                    10.heightBox,
                    //i copied this widget from home screen featured products
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                            6,
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
                                        .fontFamily(regular)
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
                                    .margin(const EdgeInsets.symmetric(
                                        horizontal: 4))
                                    .rounded
                                    .padding(const EdgeInsets.all(8))
                                    .make()),
                      ),
                    )
                  ],
                ),
              ),
            )),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ourButton(
                  color: primaryApp,
                  onPress: () {
                    if (controller.quantity.value > 0) {
                      controller.addToCart(
                          color: data['p_colors'][controller.colorIndex.value],
                          context: context,
                          vendorID: data['vendor_id'],
                          img: data['p_imgs'][0],
                          qty: controller.quantity.value,
                          sellername: data['p_seller'],
                          title: data['p_name'],
                          tprice: controller.totalPrice.value);
                      VxToast.show(context, msg: "Added to cart");
                    } else {
                      VxToast.show(context,
                          msg: "Please select the quantity of products ");
                    }
                  },
                  textColor: whiteColor,
                  title: "Add to cart"),
            ),
          ],
        ),
      ),
    );
  }
}
