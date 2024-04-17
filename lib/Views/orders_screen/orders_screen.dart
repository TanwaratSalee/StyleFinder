import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/orders_screen/orders_details.dart';
import 'package:flutter_finalproject/Views/orders_screen/writeReview_screen.dart';
import 'package:flutter_finalproject/Views/store_screen/reviews_screen.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:get/get.dart';
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
        title: const Text("My Orders", style: TextStyle(color: greyDark2, fontFamily: medium, fontSize: 22)),
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
          buildOrdersList(FirestoreServices.getOrders()),
          buildOrdersList(FirestoreServices.getDeliveryOrders()),
          buildOrdersList(FirestoreServices.getOrderHistory(), showReviewButton: true),
        ],
      ),
    );
  }

  Widget buildOrdersList(Stream<QuerySnapshot> stream, {bool showReviewButton = false}) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
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

              List<Widget> productDetailWidgets = [];

              // Add the widgets for order code and status
              productDetailWidgets.addAll([
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order code ${orderData['order_code']}",
                        style: const TextStyle(
                            color: greyDark2,
                            fontFamily: 'Medium',
                            fontSize: 20),
                      ),
                      Text(
                        orderData['order_confirmed'] ? "Confirm" : "Pending",
                        style: TextStyle(
                            color: orderData['order_confirmed']
                                ? Colors.green
                                : Colors.orange,
                            fontFamily: 'Regular',
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ]);

              // Add product details
              productDetailWidgets.addAll(products.map((product) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('x${product['qty']}',
                          style: const TextStyle(
                              fontSize: 12,
                              color: greyDark2,
                              fontFamily: 'Regular')),
                      const SizedBox(width: 5),
                      Image.network(product['img'],
                          width: 70, height: 60, fit: BoxFit.cover),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product['title'],
                                style: const TextStyle(
                                    fontFamily: 'Medium', fontSize: 14)),
                            Text('${product['price']} Bath',
                                style: const TextStyle(color: greyDark2)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList());

              // Add review button if necessary
              if (showReviewButton) {
                productDetailWidgets.add(Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ourButton(
                    title: 'Write product review',
                    color: primaryApp,
                    textColor: whiteColor,
                    onPress: () {
                      Get.to(() => const WriteReviewScreen());
                    },
                  ),
                ));
              }

              return InkWell(
                onTap: () {
                  Get.to(() => OrdersDetails(data: orderData)); 
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: productDetailWidgets,
                )
                    .box
                    .color(whiteColor)
                    .roundedSM
                    .shadowSm
                    .margin(const EdgeInsets.all(12))
                    .p12
                    .make(),
              );
            },
          );
        }
      },
    );
  }
}
