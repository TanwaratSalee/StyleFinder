import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/store_screen/store_screen.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/consts/firebase_consts.dart';
import 'package:flutter_finalproject/consts/styles.dart';
import 'package:flutter_finalproject/controllers/product_controller.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class ItemDetails extends StatefulWidget {
  final String? title;
  final dynamic data;

  const ItemDetails({Key? key, required this.title, this.data})
      : super(key: key);

  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  late final ProductController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProductController());
    checkIsInWishlist();
  }

  Future<void> checkIsInWishlist() async {
    FirebaseFirestore.instance
        .collection(productsCollection)
        .where('p_name', isEqualTo: widget.data['p_name'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        List<dynamic> wishlist = doc['p_wishlist'];
        if (wishlist.contains(currentUser!.uid)) {
          controller.isFav(true);
        } else {
          controller.isFav(false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
          title: widget.title!.text
              .color(fontGreyDark)
              .fontFamily(bold)
              .size(18)
              .make(),
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
                      itemCount: widget.data['p_imgs'].length ?? 0,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1.0,
                      itemBuilder: (context, index) {
                        return Image.network(
                          widget.data['p_imgs'][index],
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                    10.heightBox,
                    Row(
                      children: [
                        Text(
                          widget.title ?? '',
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: medium,
                            fontSize: 24,
                          ),
                        ),
                        const Spacer(),
                        Obx(
                          () => IconButton(
                            onPressed: () {
                              if (controller.isFav.value) {
                                controller.RemoveToWishlistDetail(
                                    widget.data, context);
                              } else {
                                controller.addToWishlistDetail(
                                    widget.data, context);
                              }
                              controller.isFav.toggle();
                            },
                            icon: controller.isFav.value
                                ? const Icon(Icons.favorite, color: redColor, weight: 35,)
                                : const Icon(Icons.favorite_outline, weight: 35,),
                            iconSize: 20,
                          ),
                        )
                      ],
                    ),
                    2.heightBox,
                    VxRating(
                      isSelectable: false,
                      value: double.parse(widget.data["p_rating"]),
                      onRatingUpdate: (value) {},
                      normalColor: fontGreyDark,
                      selectionColor: golden,
                      count: 5,
                      size: 25,
                      maxRating: 5,
                    ),
                    5.heightBox,
                    "${widget.data['p_aboutProduct']}"
                        .text
                        .color(fontGrey)
                        .size(16)
                        .make(),
                    "${widget.data['p_price']}"
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            5.heightBox,
                            "${widget.data['p_seller']}"
                                .text
                                .fontFamily(regular)
                                .color(blackColor)
                                .size(16)
                                .make(),
                          ],
                        )),
                        10.widthBox,
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              () => const StoreScreen(),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: primaryApp,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'See Store',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: regular),
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
                    10.heightBox,
                    "Description"
                        .text
                        .color(blackColor)
                        .size(16)
                        .fontFamily(medium)
                        .make(),
                    5.heightBox,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        widget.data['p_desc'],
                        style: const TextStyle(
                          color: blackColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    10.heightBox,
                    "Siz & Fit"
                        .text
                        .color(blackColor)
                        .size(16)
                        .fontFamily(medium)
                        .make(),
                    5.heightBox,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        widget.data['p_size'],
                        style: const TextStyle(
                          color: blackColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    10.heightBox,
                  ],
                ),
              ),
            )),
            Obx(
              () => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Row(
                    children: [
                      Obx(
                        () => Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  controller.decreaseQuantity();
                                  controller.calculateTotalPrice(
                                      int.parse(widget.data['p_price']));
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
                                      int.parse(widget.data['p_quantity']));
                                  controller.calculateTotalPrice(
                                      int.parse(widget.data['p_price']));
                                },
                                icon: const Icon(Icons.add)),
                            10.heightBox,
                          ],
                        ),
                      ),
                    ],
                  ).box.padding(const EdgeInsets.all(8)).make(),
                  Row(
                    children: [
                      SizedBox(
                        child: "Totle price ".text.color(blackColor).make(),
                      ),
                      10.widthBox,
                      "${controller.totalPrice.value}"
                          .numCurrency
                          .text
                          .color(blackColor)
                          .size(20)
                          .fontFamily(medium)
                          .make(),
                      10.widthBox,
                      SizedBox(
                        child: "Bath: ".text.color(blackColor).make(),
                      ),
                    ],
                  ).box.padding(const EdgeInsets.all(8)).make(),
                ],
              ).box.white.shadowSm.make(),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ourButton(
                  color: primaryApp,
                  onPress: () {
                    if (controller.quantity.value > 0) {
                      controller.addToCart(
                          color: widget.data['p_colors']
                              [controller.colorIndex.value],
                          context: context,
                          vendorID: widget.data['vendor_id'],
                          img: widget.data['p_imgs'][0],
                          qty: controller.quantity.value,
                          sellername: widget.data['p_seller'],
                          title: widget.data['p_name'],
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
