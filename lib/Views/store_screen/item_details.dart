import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/cart_screen/cart_screen.dart';
import 'package:flutter_finalproject/Views/store_screen/reviews_screen.dart';
import 'package:flutter_finalproject/Views/store_screen/store_screen.dart';
import 'package:flutter_finalproject/Views/widgets_common/tapButton.dart';
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
  List<dynamic> reviews = [];
  int reviewCount = 0;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProductController());
    checkIsInWishlist(); // This will call fetchReviews internally
    WidgetsBinding.instance.addPostFrameCallback((_) {
      int productPrice = int.parse(widget.data['price']);
      controller.calculateTotalPrice(productPrice);
    });

    controller.fetchVendorInfo(widget.data['vendor_id']);
  }

  void checkIsInWishlist() async {
    FirebaseFirestore.instance
        .collection(productsCollection)
        .where('name', isEqualTo: widget.data['name'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        List<dynamic> wishlist = doc['favorite_uid'];
        controller.setDocumentId(doc.id); // Set the documentId here
        if (wishlist.contains(currentUser!.uid)) {
          controller.isFav(true);
        } else {
          controller.isFav(false);
        }
        fetchReviews(); // Fetch reviews after setting the documentId
      }
    });
  }

  void fetchReviews() {
    FirebaseFirestore.instance
        .collection('reviews')
        .where('product_id', isEqualTo: controller.documentId.value)
        .snapshots()
        .listen((QuerySnapshot querySnapshot) async {
      if (querySnapshot.docs.isNotEmpty) {
        List<dynamic> reviewsData = [];
        double totalRating = 0;
        int reviewCount = querySnapshot.docs.length;

        for (var doc in querySnapshot.docs) {
          var review = doc.data() as Map<String, dynamic>;
          var userDetails = await getUserDetails(review['user_id']);
          review['user_name'] = userDetails['name'] ?? 'Unknown User';
          review['user_img'] =
              userDetails['imageUrl'] ?? ''; // Add 'user_img' safely
          reviewsData.add(review);
          totalRating += review['rating'];
        }

        double averageRating = reviewCount > 0 ? totalRating / reviewCount : 0;
        setState(() {
          reviews = reviewsData;
          controller.updateAverageRating(averageRating);
          controller.updateReviewCount(reviewCount);
          controller.updateTotalRating(totalRating.toInt());
          this.reviewCount = reviewCount;
        });
      } else {
        setState(() {
          reviews = [];
          controller.updateAverageRating(0);
          controller.updateReviewCount(0);
          controller.updateTotalRating(0);
          this.reviewCount = 0;
        });
      }
    });
  }

  void selectItem(int index) {
    setState(() {
      selectedSizeIndex = index;
      print("Selected size index: $selectedSizeIndex");
    });
  }

  void updateIsFav(bool isFav) {
    setState(() {
      controller.isFav.value = isFav;
    });
  }

  Future<String> fetchVendorName(String vendorId) async {
    DocumentSnapshot vendorSnapshot = await FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorId)
        .get();

    if (vendorSnapshot.exists) {
      var vendorData = vendorSnapshot.data() as Map<String, dynamic>;
      return vendorData['name'] ?? 'Unknown Seller';
    } else {
      return 'Unknown Seller';
    }
  }

  Future<Map<String, String>> getUserDetails(String userId) async {
    if (userId.isEmpty) {
      debugPrint('Error: userId is empty.');
      return {'name': 'Unknown User', 'id': userId, 'imageUrl': ''};
    }

    try {
      var userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userSnapshot.exists) {
        var userData = userSnapshot.data() as Map<String, dynamic>?;
        debugPrint('User data: $userData'); // Debug log
        return {
          'name': userData?['name'] ?? 'Unknown User',
          'id': userId,
          'imageUrl': userData?['imageUrl'] ?? ''
        };
      } else {
        debugPrint('User not found for ID: $userId'); // Debug log
        return {'name': 'Unknown User', 'id': userId, 'imageUrl': ''};
      }
    } catch (e) {
      debugPrint('Error getting user details: $e');
      return {'name': 'Unknown User', 'id': userId, 'imageUrl': ''};
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> sizeOrder = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
    List<String> sizes =
        (widget.data['selectsize'] ?? []).cast<String>().toList();
    sizes.sort((a, b) => sizeOrder.indexOf(a).compareTo(sizeOrder.indexOf(b)));

    return WillPopScope(
      onWillPop: () async {
        controller.resetValues();
        return true;
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Image.asset(icCart, width: 21),
              onPressed: () {
                Get.to(() => CartScreen());
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VxSwiper.builder(
                      autoPlay: true,
                      height: 420,
                      itemCount: widget.data['imgs'] != null
                          ? widget.data['imgs'].length
                          : 0,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1.0,
                      itemBuilder: (context, index) {
                        return widget.data['imgs'] != null &&
                                widget.data['imgs'].isNotEmpty
                            ? Image.network(
                                widget.data['imgs'][index],
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: double.infinity,
                                height: 420,
                                color: greyColor,
                                child:
                                    Center(child: Text('No image available')),
                              );
                      },
                    ).box.white.make(),
                    10.heightBox,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 290,
                              child: Text(
                                widget.title ?? '',
                                style: const TextStyle(
                                  color: blackColor,
                                  fontFamily: semiBold,
                                  fontSize: 22,
                                ),
                                softWrap: true,
                              ),
                            ),
                            const Spacer(),
                            Obx(
                              () => IconButton(
                                onPressed: () {
                                  if (controller.isFav.value) {
                                    controller.removeFavoriteDetail(
                                        widget.data, updateIsFav, context);
                                  } else {
                                    controller.addFavoriteDetail(
                                        widget.data, updateIsFav, context);
                                  }
                                },
                                icon: controller.isFav.value
                                    ? Image.asset(icTapFavoriteButton,
                                        width: 23)
                                    : Image.asset(icFavoriteButton, width: 23),
                                iconSize: 28,
                              ),
                            )
                          ],
                        ),
                        "${widget.data['aboutProduct']}"
                            .text
                            .fontFamily(regular)
                            .color(greyDark)
                            .size(14)
                            .make(),
                        "${NumberFormat('#,##0').format(double.parse(widget.data['price']).toInt())} Bath"
                            .text
                            .color(primaryApp)
                            .fontFamily(medium)
                            .size(20)
                            .make()
                      ],
                    )
                        .box
                        .white
                        .padding(EdgeInsets.fromLTRB(16, 10, 16, 6))
                        .make(),
                    5.heightBox,
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
                                    ? ClipOval(
                                        child: Image.network(
                                          imageUrl,
                                          width: 45,
                                          height: 45,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                        .box
                                        .border(color: greyLine)
                                        .roundedFull
                                        .make()
                                    : Icon(
                                        Icons.person,
                                        color: whiteColor,
                                        size: 22,
                                      );
                              }),
                              10.widthBox,
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Obx(() {
                                    return controller.vendorName.isNotEmpty
                                        ? controller.vendorName.value
                                            .toUpperCase()
                                            .text
                                            .fontFamily(medium)
                                            .color(blackColor)
                                            .size(18)
                                            .make()
                                        : Container();
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                        10.widthBox,
                        GestureDetector(
                          onTap: () async {
                            String vendorName =
                                await fetchVendorName(widget.data['vendor_id']);
                            Get.to(() => StoreScreen(
                                  vendorId: widget.data['vendor_id'],
                                  title: vendorName,
                                ));
                          },
                          child: Container(
                            child: const Text(
                              'See Store',
                              style: TextStyle(
                                  color: whiteColor, fontFamily: regular),
                            ),
                          )
                              .box
                              .white
                              .padding(EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10))
                              .roundedLg
                              .color(primaryApp)
                              .make(),
                        )
                      ],
                    )
                        .box
                        .white
                        .padding(const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8))
                        .margin(const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7))
                        .outerShadow
                        .roundedSM
                        .make(),
                    5.heightBox,
                    Column(
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
                            itemCount: widget.data['collection'] != null
                                ? widget.data['collection'].length
                                : 0,
                            itemBuilder: (context, index) {
                              return Container(
                                child: Text(
                                  "${widget.data['collection'][index].toString()[0].toUpperCase()}${widget.data['collection'][index].toString().substring(1)}",
                                )
                                    .text
                                    .size(26)
                                    .color(blackColor)
                                    .fontFamily(medium)
                                    .make(),
                              )
                                  .box
                                  .white
                                  .color(thinPrimaryApp)
                                  .margin(EdgeInsets.symmetric(horizontal: 3))
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
                          widget.data['description'] ?? 'No description',
                        )
                            .text
                            .color(blackColor)
                            .size(12)
                            .fontFamily(regular)
                            .make(),
                        SizedBox(height: 15),
                        "Size & Fit"
                            .text
                            .color(blackColor)
                            .size(16)
                            .fontFamily(medium)
                            .make(),
                        SizedBox(height: 5),
                        Text(
                          widget.data['sizedes'] ?? 'No size information',
                        )
                            .text
                            .color(blackColor)
                            .size(12)
                            .fontFamily(regular)
                            .make(),
                      ],
                    )
                        .box
                        .white
                        .padding(const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 18))
                        .margin(const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7))
                        .outerShadow
                        .roundedSM
                        .make(),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Product rating')
                                      .text
                                      .fontFamily(medium)
                                      .size(18)
                                      .color(blackColor)
                                      .make(),
                                  Obx(() {
                                    double rating =
                                        controller.averageRating.value;
                                    int reviewCount =
                                        controller.reviewCount.value;
                                    return Row(
                                      children: [
                                        buildCustomRating(rating, 20),
                                        SizedBox(width: 8),
                                        Text(
                                          '${rating.toStringAsFixed(1)}/5.0 ($reviewCount reviews)',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: blackColor,
                                            fontFamily: medium,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => ReviewScreen(
                                    productId: controller.documentId.value));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('See All')
                                      .text
                                      .fontFamily(medium)
                                      .size(14)
                                      .color(blackColor)
                                      .make(),
                                  10.widthBox,
                                  Image.asset(
                                    icSeeAll,
                                    width: 12,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ).box.padding(EdgeInsets.symmetric(vertical: 5)).make(),
                        Divider(color: greyThin),
                        Column(
                          children: [
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('reviews')
                                  .where('product_id',
                                      isEqualTo: controller.documentId.value)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                                var reviews = snapshot.data!.docs;
                                if (reviews.isEmpty) {
                                  return Center(
                                    child: Text(
                                            'The product has not been reviewed yet.')
                                        .text
                                        .size(16)
                                        .color(greyColor)
                                        .make(),
                                  );
                                }
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount:
                                      reviews.length > 3 ? 3 : reviews.length,
                                  itemBuilder: (context, index) {
                                    var review = reviews[index];
                                    var reviewData =
                                        review.data() as Map<String, dynamic>;
                                    var timestamp =
                                        reviewData['created_at'] as Timestamp;
                                    var date = DateFormat('yyyy-MM-dd')
                                        .format(timestamp.toDate());
                                    var rating = reviewData['rating'] is double
                                        ? (reviewData['rating'] as double)
                                            .toInt()
                                        : reviewData['rating'] as int;

                                    return FutureBuilder<Map<String, String>>(
                                      future:
                                          getUserDetails(reviewData['user_id']),
                                      builder: (context, userSnapshot) {
                                        if (!userSnapshot.hasData) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        var userDetails = userSnapshot.data!;
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    userDetails['imageUrl'] ??
                                                        'https://via.placeholder.com/150', // Placeholder image
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                            width: 150,
                                                            child: Text(
                                                              userDetails[
                                                                      'name'] ??
                                                                  'Not Found',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      semiBold,
                                                                  fontSize: 16),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          Text(
                                                            date,
                                                            style: TextStyle(
                                                                color:
                                                                    greyColor,
                                                                fontSize: 12),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          buildStars(
                                                              rating ?? 0),
                                                          5.widthBox,
                                                          Text(
                                                              '${rating.toString()}/5.0'),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        reviewData[
                                                                'review_text'] ??
                                                            'No review text',
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                                .box
                                                .padding(
                                                    EdgeInsets.only(left: 55))
                                                .make(),
                                          ],
                                        )
                                            .box
                                            .padding(EdgeInsets.symmetric(
                                                vertical: 14, horizontal: 8))
                                            .make();
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    )
                        .box
                        .padding(EdgeInsets.all(12))
                        .margin(const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7))
                        .white
                        .outerShadow
                        .roundedSM
                        .make(),
                  ],
                ),
              ),
            ),
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
                        bool isSelected = index == selectedSizeIndex;
                        return GestureDetector(
                          onTap: () => selectItem(index),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: isSelected
                                  ? Border.all(color: primaryApp, width: 2)
                                  : Border.all(color: greyLine, width: 1),
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
                              .padding(EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 10))
                              .make(),
                        );
                      },
                    ),
                  ).box.padding(EdgeInsets.only(left: 10)).make(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              controller.decreaseQuantity();
                              controller.calculateTotalPrice(
                                  int.parse(widget.data['price']));
                            },
                            icon: const Icon(Icons.remove, size: 20),
                          ),
                          Text(controller.quantity.value.toString())
                              .text
                              .size(20)
                              .color(greyDark)
                              .fontFamily(regular)
                              .make(),
                          IconButton(
                            onPressed: () {
                              controller.increaseQuantity(
                                  int.parse(widget.data['quantity']));
                              controller.calculateTotalPrice(
                                  int.parse(widget.data['price']));
                            },
                            icon: const Icon(Icons.add, size: 20),
                          ),
                        ],
                      )
                          .box
                          .padding(const EdgeInsets.symmetric(horizontal: 8))
                          .make(),
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
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 35),
                        child: tapButton(
                          color: primaryApp,
                          onPress: () {
                            if (controller.quantity.value > 0 &&
                                selectedSizeIndex != null &&
                                widget.data['selectsize'] != null &&
                                widget.data['selectsize'].isNotEmpty) {
                              String selectedSize =
                                  widget.data['selectsize'][selectedSizeIndex!];
                              controller.addToCart(
                                context: context,
                                vendorID: widget.data['vendor_id'],
                                qty: controller.quantity.value,
                                tprice: controller.totalPrice.value,
                                productsize: selectedSize,
                                documentId: controller.documentId.value,
                              );
                              VxToast.show(context, msg: "Add to your cart");
                            } else {
                              VxToast.show(context,
                                  msg:
                                      "Please select the quantity and size of the products");
                            }
                          },
                          textColor: whiteColor,
                          title: "Add to your cart",
                        )),
                  ),
                ],
              ).box.white.outerShadow.make(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.yellow,
          size: 16,
        );
      }),
    );
  }

  Widget buildCustomRating(double rating, double size) {
    int filledStars = rating.floor();
    bool hasHalfStar = rating - filledStars > 0;

    return Row(
      children: List.generate(5, (index) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.star_border,
              color: Colors.yellow,
              size: size,
            ),
            Icon(
              Icons.star,
              color: index < filledStars ? Colors.yellow : Colors.transparent,
              size: size - 2,
            ),
          ],
        ).marginOnly(right: 4);
      }),
    );
  }
}
