import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/orders_screen/orders_details.dart';
import 'package:flutter_finalproject/Views/orders_screen/writeReview_screen.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
    _tabController = TabController(length: 3, vsync: this);
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
            .size(24)
            .fontFamily(semiBold)
            .color(greyDark2)
            .make(),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Orders'),
            Tab(text: 'Delivery'),
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
              child: Text("No orders yet!", style: TextStyle(color: greyDark2)));
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
                          style: const TextStyle(
                              color: greyDark2, fontFamily: medium, fontSize: 18),
                        ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('x${product['qty']}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: greyDark2,
                                    fontFamily: regular)),
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
                                      style: const TextStyle(color: greyDark2)),
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
                    .shadowSm
                    .margin(const EdgeInsets.symmetric(vertical: 8, horizontal: 18))
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
              child: Text("No orders yet!", style: TextStyle(color: greyDark2)));
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
                          style: const TextStyle(
                              color: greyDark2, fontFamily: medium, fontSize: 18),
                        ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('x${product['qty']}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: greyDark2,
                                    fontFamily: regular)),
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
                                      style: const TextStyle(color: greyDark2)),
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
                    .shadowSm
                    .margin(const EdgeInsets.symmetric(vertical: 8, horizontal: 18))
                    .p12
                    .make(),
              );
            },
          );
        }
      },
    );
  }

  Widget buildHistory(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getOrderHistory(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: loadingIndicator());
        } else if (snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text("No orders yet!", style: TextStyle(color: greyDark2)));
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
                          style: const TextStyle(
                              color: greyDark2, fontFamily: medium, fontSize: 18),
                        ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('x${product['qty']}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: greyDark2,
                                    fontFamily: regular)),
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
                                      style: const TextStyle(color: greyDark2)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: tapButton(
                        title: 'Write product review',
                        color: primaryApp,
                        textColor: whiteColor,
                        onPress: () {
                          Get.to(() => WriteReviewScreen(products: products));
                        },
                      ),
                    ),
                  ],
                )
                    .box
                    .color(whiteColor)
                    .roundedSM
                    .shadowSm
                    .margin(const EdgeInsets.symmetric(vertical: 8, horizontal: 18))
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
    return firestore
        .collection(ordersCollection)
        .where('order_delivered', isEqualTo: true)
        .where('order_by', isEqualTo: currentUser!.uid)
        .snapshots();
  }
}
