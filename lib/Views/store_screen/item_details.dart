import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/store_screen/store_screen.dart';
import 'package:flutter_finalproject/Views/widgets_common/marqueeWidget.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/consts/firebase_consts.dart';
import 'package:flutter_finalproject/consts/styles.dart';
import 'package:flutter_finalproject/controllers/product_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
  int? selectedSizeIndex;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProductController());
    checkIsInWishlist();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      int productPrice = int.parse(widget.data['p_price']);
      controller.calculateTotalPrice(productPrice);
    });
  }

  void checkIsInWishlist() async {
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

    fetchVendorImageUrl(widget.data['vendor_id']);
  }

  int? selectedIndex; // This holds the index of the currently selected item

  void selectItem(int index) {
    setState(() {
      selectedIndex = index; // Update the selectedIndex on tap
    });
  }

  void fetchVendorImageUrl(String vendorId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(vendorsCollection)
          .where('vendor_id', isEqualTo: vendorId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> data =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        String imageUrl = data['imageUrl'] ?? '';
        controller.updateVendorImageUrl(imageUrl);
      }
    } catch (e) {
      print('Error fetching vendor image: $e');
    }
  }

  void _updateIsFav(bool isFav) {
    setState(() {
      controller.isFav.value = isFav;
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
          title: widget.title!.text
              .color(greyDark2)
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
                        Container(
                          width: 360, 
                          child: Text(
                            widget.title ?? '',
                            style: const TextStyle(
                              color: blackColor,
                              fontFamily: medium,
                              fontSize: 22,
                            ),
                            softWrap:
                                true, 
                          ),
                        ),
                        const Spacer(),
                        Obx(
                          () => IconButton(
                            onPressed: () {
                              if (controller.isFav.value) {
                                controller.removeToWishlistDetail(
                                    widget.data, _updateIsFav, context);
                              } else {
                                controller.addToWishlistDetail(
                                    widget.data, _updateIsFav, context);
                              }
                            },
                            icon: Icon(
                              controller.isFav.value
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: controller.isFav.value ? redColor : null,
                            ),
                            iconSize: 28,
                          ),
                        )
                      ],
                    ),
                    2.heightBox,
                    VxRating(
                      isSelectable: false,
                      value: double.parse(widget.data["p_rating"]),
                      onRatingUpdate: (value) {},
                      normalColor: greyDark2,
                      selectionColor: golden,
                      count: 5,
                      size: 20,
                      maxRating: 5,
                    ),
                    5.heightBox,
                    "${widget.data['p_aboutProduct']}"
                        .text
                        .fontFamily(regular)
                        .color(greyDark1)
                        .size(14)
                        .make(),
                    "${NumberFormat('#,##0').format(double.parse(widget.data['p_price']).toInt())} Bath"
                        .text
                        .color(Theme.of(context).primaryColor)
                        .fontFamily(regular)
                        .size(20)
                        .make(),
                    20.heightBox,
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              5.widthBox,
                              Obx(() {
                                String imageUrl =
                                    controller.vendorImageUrl.value;
                                return imageUrl.isNotEmpty
                                    ? Image.network(
                                        imageUrl,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : SizedBox.shrink();
                              }),
                              10.widthBox,
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: "${widget.data['p_seller']}"
                                      .toUpperCase()
                                      .text
                                      .fontFamily(medium)
                                      .color(blackColor)
                                      .size(18)
                                      .make(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        10.widthBox,
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              () => StoreScreen(
                                  vendorId: widget.data['vendor_id']),
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
                                  color: whiteColor, fontFamily: regular),
                            ),
                          ),
                        )
                      ],
                    )
                        .box
                        .height(60)
                        .padding(const EdgeInsets.symmetric(horizontal: 16))
                        .color(thinGrey0)
                        .make(),
                    20.heightBox,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          "Collection"
                              .text
                              .color(blackColor)
                              .size(15)
                              .fontFamily(medium)
                              .make(),
                          SizedBox(height: 5),
                          Container(
                            height: 40,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.data['p_collection'].length,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: Text(
                                    "${widget.data['p_collection'][index].toString()[0].toUpperCase()}${widget.data['p_collection'][index].toString().substring(1)}",
                                  )
                                      .text
                                      .color(greyDark1)
                                      .fontFamily(medium)
                                      .size(14)
                                      .make(),
                                )
                                    .box
                                    .color(thinPrimaryApp)
                                    .margin(EdgeInsets.symmetric(horizontal: 6))
                                    .rounded
                                    .padding(EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12))
                                    .make();
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          "Description"
                              .text
                              .color(blackColor)
                              .size(15)
                              .fontFamily(medium)
                              .make(),
                          SizedBox(height: 5),
                          Text(
                            widget.data['p_desc'],
                            style: TextStyle(
                              color: blackColor,
                              fontFamily: light,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 10),
                          "Size & Fit"
                              .text
                              .color(blackColor)
                              .size(15)
                              .fontFamily(medium)
                              .make(),
                          SizedBox(height: 5),
                          Text(
                            widget.data['p_size'],
                            style: TextStyle(
                              color: blackColor,
                              fontFamily: light,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    10.heightBox,
                  ],
                ),
              ),
            )),
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 70, // Set a fixed height
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.data['p_productsize'].length,
                      itemBuilder: (context, index) {
                        bool isSelected = index == selectedIndex;
                        return GestureDetector(
                          onTap: () => selectItem(index),
                          child: Container(
                            decoration: BoxDecoration(
                              // color: isSelected ? whiteColor : whiteColor,
                              borderRadius: BorderRadius.circular(10),
                              border: isSelected
                                  ? Border.all(color: primaryApp, width: 2)
                                  : Border.all(color: greyColor, width: 1),
                            ),
                            child: Text(
                              widget.data['p_productsize'][index],
                              style: TextStyle(
                                color: isSelected ? blackColor : blackColor,
                              ),
                            )
                                .box
                                .padding(EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8))
                                .make(),
                          )
                              .box
                              .padding(EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 15))
                              .make(),
                        );
                      },
                    ),
                  ),

                  // Row for Quantity Adjustment
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              controller.decreaseQuantity();
                              controller.calculateTotalPrice(
                                  int.parse(widget.data['p_price']));
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          Text(controller.quantity.value.toString())
                              .text
                              .size(16)
                              .color(greyDark2)
                              .fontFamily(bold)
                              .make(),
                          IconButton(
                            onPressed: () {
                              controller.increaseQuantity(
                                  int.parse(widget.data['p_quantity']));
                              controller.calculateTotalPrice(
                                  int.parse(widget.data['p_price']));
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ).box.padding(const EdgeInsets.all(8)).make(),

                      // Displaying Total Price
                      Row(
                        children: [
                          "Total price ".text.color(blackColor).make(),
                          5.widthBox,
                          Text(
                            NumberFormat("#,##0.00", "en_US")
                                .format(controller.totalPrice.value),
                          )
                              .text
                              .color(blackColor)
                              .size(20)
                              .fontFamily(medium)
                              .make(),
                          5.widthBox,
                          " Baht".text.color(blackColor).make(),
                          5.widthBox,
                        ],
                      ).box.padding(const EdgeInsets.all(8)).make(),
                    ],
                  ),
                ],
              ).box.white.shadowSm.make(),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ourButton(
                  color: primaryApp,
                  onPress: () {
                    if (controller.quantity.value > 0 &&
                        selectedIndex != null) {
                      // Check if a size is selected
                      String selectedSize = widget.data['p_productsize'][
                          selectedIndex!]; // Use the selected index to fetch the size
                      controller.addToCart(
                        context: context,
                        vendorID: widget.data['vendor_id'],
                        img: widget.data['p_imgs'][0],
                        qty: controller.quantity.value,
                        sellername: widget.data['p_seller'],
                        title: widget.data['p_name'],
                        tprice: controller.totalPrice.value,
                        productsize: selectedSize, // Pass the selected size
                      );
                      VxToast.show(context, msg: "Added to cart");
                    } else {
                      VxToast.show(context,
                          msg:
                              "Please select the quantity and size of the products");
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
