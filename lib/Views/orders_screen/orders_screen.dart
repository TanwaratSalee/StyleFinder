import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/orders_screen/orders_details.dart';
import 'package:flutter_finalproject/Views/widgets_common/tapButton.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text("My Orders")
            .text
            .size(26)
            .fontFamily(semiBold)
            .color(blackColor)
            .make(),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Orders'),
            Tab(text: 'Delivery'),
            Tab(text: 'Review'),
            Tab(text: 'History'),
          ],
          indicatorColor: primaryApp,
          labelColor: blackColor,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildOrders(context),
          buildDelivery(context),
          buildReview(context),
          buildHistory(context),
        ],
      ),
    );
  }

  Widget buildOrders(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getOrders(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: loadingIndicator());
        } else if (snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text("No orders yet!", style: TextStyle(color: greyDark)));
        } else {
          var data = snapshot.data!.docs;

          // Sort data by order_date in descending order
          data.sort((a, b) {
            var dateA =
                (a.data() as Map<String, dynamic>)['order_date'].toDate();
            var dateB =
                (b.data() as Map<String, dynamic>)['order_date'].toDate();
            return dateB.compareTo(dateA);
          });

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var orderData = data[index].data() as Map<String, dynamic>;
              var products = orderData['orders'] as List<dynamic>;

              return InkWell(
                onTap: () {
                  Get.to(() => OrdersDetails(data: orderData));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Order code ${orderData['order_code']}",
                        )
                            .text
                            .fontFamily(medium)
                            .color(blackColor)
                            .size(18)
                            .make(),
                        Text(intl.DateFormat()
                            .add_yMd()
                            .format((orderData['order_date'].toDate()))),
                        Text(
                          orderData['order_confirmed'] ? "Confirm" : "Pending",
                          style: TextStyle(
                              color: orderData['order_confirmed']
                                  ? Colors.green
                                  : Colors.orange,
                              fontFamily: regular,
                              fontSize: 16),
                        ),
                      ],
                    ).box.padding(EdgeInsets.symmetric(horizontal: 12)).make(),
                    5.heightBox,
                    ...products.map((product) {
                      var productName = product['name'] ?? 'Unknown';
                      var productImage = product['img'] ?? '';
                      var productPrice = product['total_price'] != null
                          ? NumberFormat('#,##0').format(product['total_price'])
                          : '0';

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('x${product['qty']}')
                                .text
                                .fontFamily(regular)
                                .color(greyColor)
                                .size(12)
                                .make(),
                            const SizedBox(width: 5),
                            Image.network(productImage,
                                width: 70, height: 60, fit: BoxFit.cover),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(productName,
                                          style: const TextStyle(
                                              fontFamily: medium, fontSize: 14),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis)
                                      .text
                                      .fontFamily(medium)
                                      .color(blackColor)
                                      .size(14)
                                      .make(),
                                  Text('${productPrice} Bath')
                                      .text
                                      .fontFamily(regular)
                                      .color(greyColor)
                                      .size(14)
                                      .make(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                )
                    .box
                    .color(whiteColor)
                    .roundedSM
                    .border(color: greyLine)
                    .margin(
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 18))
                    .p12
                    .make(),
              );
            },
          );
        }
      },
    );
  }

  Widget buildDelivery(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getDeliveryOrders(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: loadingIndicator());
        } else if (snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text("No orders yet!", style: TextStyle(color: greyDark)));
        } else {
          var data = snapshot.data!.docs;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var orderData = data[index].data() as Map<String, dynamic>;
              var products = orderData['orders'] as List<dynamic>;

              return InkWell(
                onTap: () {
                  Get.to(() => OrdersDetails(data: orderData));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Order code ${orderData['order_code']}",
                        )
                            .text
                            .fontFamily(medium)
                            .color(blackColor)
                            .size(18)
                            .make(),
                        Text(
                          orderData['order_confirmed'] ? "Confirm" : "Pending",
                          style: TextStyle(
                              color: orderData['order_confirmed']
                                  ? Colors.green
                                  : Colors.orange,
                              fontFamily: regular,
                              fontSize: 16),
                        ),
                      ],
                    ).box.padding(EdgeInsets.symmetric(horizontal: 12)).make(),
                    5.heightBox,
                    ...products.map((product) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'x${product['qty']}',
                            )
                                .text
                                .fontFamily(regular)
                                .color(greyColor)
                                .size(12)
                                .make(),
                            const SizedBox(width: 5),
                            Image.network(product['img'],
                                width: 70, height: 60, fit: BoxFit.cover),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['title'],
                                    style: const TextStyle(
                                      fontFamily: medium,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${NumberFormat('#,##0').format(product['price'])} Bath',
                                  )
                                      .text
                                      .fontFamily(regular)
                                      .color(greyColor)
                                      .size(14)
                                      .make(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                )
                    .box
                    .color(whiteColor)
                    .roundedSM
                    .border(color: greyLine)
                    .margin(
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 18))
                    .p12
                    .make(),
              );
            },
          );
        }
      },
    );
  }

  Widget buildReview(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getOrderHistory(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: loadingIndicator());
        } else if (snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text("No orders yet!", style: TextStyle(color: greyDark)));
        } else {
          var data = snapshot.data!.docs;

          // Filter orders that have at least one product with 'reviews' set to false
          var ordersWithProductsToReview = data.where((orderDoc) {
            var orderData = orderDoc.data() as Map<String, dynamic>;
            var products = orderData['orders'] as List<dynamic>;
            return products.any((product) => product['reviews'] == false);
          }).toList();

          if (ordersWithProductsToReview.isEmpty) {
            return const Center(
                child:
                    Text("No orders yet!", style: TextStyle(color: greyDark)));
          }

          return ListView.builder(
            itemCount: ordersWithProductsToReview.length,
            itemBuilder: (context, index) {
              var orderDoc = ordersWithProductsToReview[index];
              var orderData = orderDoc.data() as Map<String, dynamic>;
              var products = orderData['orders'] as List<dynamic>;

              // Filter products that have 'reviews' set to false
              var productsToReview = products
                  .where((product) => product['reviews'] == false)
                  .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (productsToReview.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Order code ${orderData['order_code']}",
                        )
                            .text
                            .fontFamily(medium)
                            .color(blackColor)
                            .size(18)
                            .make(),
                      ],
                    ).box.padding(EdgeInsets.symmetric(horizontal: 12)).make(),
                  5.heightBox,
                  ...productsToReview.asMap().entries.map((entry) {
                    int productIndex = entry.key;
                    var product = entry.value;
                    var reviewController = TextEditingController();
                    var rating = 0.0;

                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Image.network(
                                        product['img'],
                                        width: 85,
                                        height: 85,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product['title'],
                                              style: TextStyle(
                                                fontFamily: medium,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              '${NumberFormat('#,##0').format(product['price'])} Bath',
                                            )
                                                .text
                                                .fontFamily(regular)
                                                .color(greyColor)
                                                .size(14)
                                                .make(),
                                            RatingBar.builder(
                                              initialRating: 0,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 20.0, // Smaller stars
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (ratingValue) {
                                                setState(() {
                                                  rating = ratingValue;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    controller: reviewController,
                                    maxLines: 2,
                                    decoration: InputDecoration(
                                      hintText: 'Write your review here',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: BorderSide(color: greyLine),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: BorderSide(
                                          color: greyLine,
                                          width: 2.0,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: BorderSide(
                                          color: greyThin,
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  tapButton(
                                    onPress: rating > 0
                                        ? () async {
                                            var currentUser = FirebaseAuth
                                                .instance.currentUser;
                                            if (currentUser != null) {
                                              var reviewData = {
                                                'product_id':
                                                    product['product_id'],
                                                'product_title':
                                                    product['title'],
                                                'product_img': product['img'],
                                                'rating': rating,
                                                'review_text':
                                                    reviewController.text,
                                                'review_date': DateTime.now(),
                                                'user_id': currentUser.uid,
                                                'user_name':
                                                    currentUser.displayName ??
                                                        'Anonymous',
                                                'user_img': currentUser
                                                        .photoURL ??
                                                    'default_user_image_url',
                                              };

                                              await FirebaseFirestore.instance
                                                  .collection('reviews')
                                                  .add(reviewData);

                                              // Update the product's review status in Firestore
                                              var updatedProducts =
                                                  products.map((p) {
                                                if (p['product_id'] ==
                                                    product['product_id']) {
                                                  p['reviews'] = true;
                                                }
                                                return p;
                                              }).toList();

                                              await orderDoc.reference.update(
                                                  {'orders': updatedProducts});

                                              VxToast.show(context,
                                                  msg:
                                                      'Review Submitted: Thank you for your feedback!',
                                                  position:
                                                      VxToastPosition.bottom);

                                              setState(() {
                                                productsToReview
                                                    .removeAt(productIndex);
                                                if (productsToReview.isEmpty) {
                                                  ordersWithProductsToReview
                                                      .removeAt(index);
                                                }
                                              });
                                            } else {
                                              VxToast.show(context,
                                                  msg:
                                                      'Error: You need to be logged in to submit a review',
                                                  position:
                                                      VxToastPosition.bottom);
                                            }
                                          }
                                        : null,
                                    color: primaryApp,
                                    textColor: whiteColor,
                                    title: "Submit",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                            .box
                            .border(color: greyLine)
                            .roundedSM
                            .margin(const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12))
                            .make();
                      },
                    );
                  }).toList(),
                ],
              );
            },
          );
        }
      },
    );
  }

  Widget buildHistory(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getHistoryOrders(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: loadingIndicator());
        } else if (snapshot.data!.docs.isEmpty) {
          return const Center(
              child:
                  Text("No history yet!", style: TextStyle(color: greyDark)));
        } else {
          var data = snapshot.data!.docs;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var orderData = data[index].data() as Map<String, dynamic>;
              var products = orderData['orders'] as List<dynamic>;

              return InkWell(
                onTap: () {
                  Get.to(() => OrdersDetails(data: orderData));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Order code ${orderData['order_code']}",
                        )
                            .text
                            .fontFamily(medium)
                            .color(blackColor)
                            .size(18)
                            .make(),
                        Text(intl.DateFormat()
                            .add_yMd()
                            .format((orderData['order_date'].toDate())))
                      ],
                    ).box.padding(EdgeInsets.symmetric(horizontal: 12)).make(),
                    Divider(
                      color: greyLine,
                    ),
                    5.heightBox,
                    ...products.map((product) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'x${product['qty']}',
                            )
                                .text
                                .fontFamily(regular)
                                .color(greyColor)
                                .size(12)
                                .make(),
                            const SizedBox(width: 5),
                            Image.network(product['img'],
                                width: 70, height: 60, fit: BoxFit.cover),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['title'],
                                    style: const TextStyle(
                                      fontFamily: medium,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                      .text
                                      .fontFamily(medium)
                                      .color(blackColor)
                                      .size(14)
                                      .make(),
                                  Text(
                                    '${NumberFormat('#,##0').format(product['price'])} Bath',
                                  )
                                      .text
                                      .fontFamily(regular)
                                      .color(greyColor)
                                      .size(14)
                                      .make(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                )
                    .box
                    .color(whiteColor)
                    .roundedSM
                    .border(color: greyLine)
                    .margin(
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 18))
                    .p12
                    .make(),
              );
            },
          );
        }
      },
    );
  }

  static Stream<QuerySnapshot> getOrders() {
    return firestore
        .collection(ordersCollection)
        .where('order_on_delivery', isEqualTo: false)
        .where('order_delivered', isEqualTo: false)
        .where('order_by', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static Stream<QuerySnapshot> getDeliveryOrders() {
    return firestore
        .collection(ordersCollection)
        .where('order_on_delivery', isEqualTo: true)
        .where('order_delivered', isEqualTo: false)
        .where('order_by', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static Stream<QuerySnapshot> getOrderHistory() {
    return FirebaseFirestore.instance
        .collection(ordersCollection)
        .where('order_delivered', isEqualTo: true)
        .where('order_by', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  static Stream<QuerySnapshot> getHistoryOrders() {
    return firestore
        .collection(ordersCollection)
        .where('order_delivered', isEqualTo: true)
        .where('order_by', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static Stream<QuerySnapshot> getReviewOrders() {
    return firestore
        .collection(ordersCollection)
        .where('order_delivered', isEqualTo: true)
        .where('reviews', isEqualTo: false)
        .where('order_by', isEqualTo: currentUser!.uid)
        .snapshots();
  }
}
