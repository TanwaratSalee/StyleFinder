import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/store_screen/store_screen.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/product_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  int? selectedIndex;

  void selectItem(int index) {
    setState(() {
      selectedIndex = index;
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
    List<String> sizeOrder = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
    List<String> sizes = widget.data['p_productsize'].cast<String>().toList();
    sizes.sort((a, b) => sizeOrder.indexOf(a).compareTo(sizeOrder.indexOf(b)));
    return WillPopScope(
      onWillPop: () async {
        controller.resetValues();
        return true;
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          // title: widget.title!.text
          //     .color(greyDark2)
          //     .fontFamily(medium)
          //     .size(18)
          //     .make(),
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
                          width: 300,
                          child: Text(
                            widget.title ?? '',
                            style: const TextStyle(
                              color: blackColor,
                              fontFamily: medium,
                              fontSize: 22,
                            ),
                            softWrap: true,
                          ).box.p4.make(),
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
                    VxRating(
                      isSelectable: false,
                      value: double.parse(widget.data["p_rating"]),
                      onRatingUpdate: (value) {},
                      normalColor: greyDark2,
                      selectionColor: golden,
                      count: 5,
                      size: 20,
                      maxRating: 5,
                    ).box.padding(EdgeInsets.symmetric(horizontal: 4)).make(),
                    5.heightBox,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "${widget.data['p_aboutProduct']}"
                            .text
                            .fontFamily(regular)
                            .color(greyDark1)
                            .size(14)
                            .make(),
                        "${NumberFormat('#,##0').format(double.parse(widget.data['p_price']).toInt())} Bath"
                            .text
                            .color(primaryApp)
                            .fontFamily(medium)
                            .size(20)
                            .make(),
                      ],
                    ).box.padding(EdgeInsets.symmetric(horizontal: 4)).make(),
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
                                        width: 60,
                                        height: 60,
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
                            child: const Text(
                              'See Store',
                              style: TextStyle(
                                  color: whiteColor, fontFamily: regular),
                            ),
                          )
                              .box
                              .padding(EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10))
                              .color(primaryApp)
                              .roundedLg
                              .make(),
                        )
                      ],
                    )
                        .box
                        .height(80)
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
                              .size(16)
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
                                      .size(14)
                                      .color(greyDark1)
                                      .fontFamily(medium)
                                      .make(),
                                )
                                    .box
                                    .color(thinPrimaryApp)
                                    .margin(EdgeInsets.symmetric(horizontal: 6))
                                    .roundedLg
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
                              .size(16)
                              .fontFamily(medium)
                              .make(),
                          SizedBox(height: 5),
                          Text(
                            widget.data['p_desc'],
                          )
                              .text
                              .color(blackColor)
                              .size(12)
                              .fontFamily(regular)
                              .make(),
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
                              fontFamily: regular,
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
                    height: 55,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: sizes.length,
                      itemBuilder: (context, index) {
                        bool isSelected = index == selectedIndex;
                        return GestureDetector(
                          onTap: () => selectItem(index),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: isSelected
                                  ? Border.all(color: primaryApp, width: 2)
                                  : Border.all(color: greyColor, width: 1),
                            ),
                            child: Text(
                              sizes[index],
                              style: TextStyle(
                                color: isSelected ? blackColor : blackColor,
                              ),
                            )
                                .box
                                .padding(EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6))
                                .make(),
                          )
                              .box
                              .padding(EdgeInsets.symmetric(horizontal: 4, vertical: 10))
                              .make(),
                        );
                      },
                    ),
                  ).box.padding(EdgeInsets.only(left: 10,)).make(),
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
                            icon: const Icon(Icons.remove, size: 20),
                          ),
                          Text(controller.quantity.value.toString())
                              .text
                              .size(20)
                              .color(greyDark2)
                              .fontFamily(regular)
                              .make(),
                          IconButton(
                            onPressed: () {
                              controller.increaseQuantity(
                                  int.parse(widget.data['p_quantity']));
                              controller.calculateTotalPrice(
                                  int.parse(widget.data['p_price']));
                            },
                            icon: const Icon(Icons.add, size: 20),
                          ),
                        ],
                      ).box.padding(const EdgeInsets.symmetric(horizontal: 8)).make(),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            "Price ".text.size(14).color(blackColor).make(),
                            5.widthBox,
                            Text(
                              NumberFormat("#,##0.00", "en_US")
                                  .format(controller.totalPrice.value),
                            )
                                .text
                                .color(blackColor)
                                .size(24)
                                .fontFamily(medium)
                                .make(),
                            5.widthBox,
                            " Baht".text.size(14).color(blackColor).make(),
                            5.widthBox,
                          ],
                        )
                            .box
                            .padding(const EdgeInsets.symmetric(horizontal: 18))
                            .make(),
                      ),
                    ],
                  ),
                  5.heightBox,
                  SizedBox(
                    width: double.infinity,
                    height: 85,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                      child: tapButton(
                          color: primaryApp,
                          onPress: () {
                            if (controller.quantity.value > 0 &&
                                selectedIndex != null) {
                              String selectedSize =
                                  widget.data['p_productsize'][selectedIndex!];
                              controller.addToCart(
                                context: context,
                                vendorID: widget.data['vendor_id'],
                                img: widget.data['p_imgs'][0],
                                qty: controller.quantity.value,
                                sellername: widget.data['p_seller'],
                                title: widget.data['p_name'],
                                tprice: controller.totalPrice.value,
                                productsize: selectedSize,
                              );
                              VxToast.show(context, msg: "Add to your cart");
                            } else {
                              VxToast.show(context,
                                  msg:
                                      "Please select the quantity and size of the products");
                            }
                          },
                          textColor: whiteColor,
                          title: "Add to your cart"),
                    ),
                  ),
                ],
              ).box.white.shadowSm.make(),
            ),
          ],
        ),
      ),
    );
  }
}
