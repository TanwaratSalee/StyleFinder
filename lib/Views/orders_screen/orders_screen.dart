import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/orders_screen/orders_details.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:get/get.dart';

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
    _tabController = TabController(
        length: 4,
        vsync: this); // Adjusted length to 4 to match the number of tabs
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
        title: const Text(
          "My Orders",
          style: TextStyle(
              color: fontGreyDark), // Adjusted for direct TextStyle use
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Orders'),
            Tab(text: 'Delivery'),
            Tab(text: 'History'),
          ],
          indicatorColor: primaryApp,
          labelColor: fontBlack,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildOrdersList(FirestoreServices.getOrders()),
          buildOrdersList(FirestoreServices.getDeliveryOrders()),
          buildOrdersList(FirestoreServices.getOrderHistory()),
        ],
      ),
    );
  }

  Widget buildOrdersList(Stream<QuerySnapshot> stream) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: loadingIndicator(),
          );
        } else if (snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text("No orders yet!",
                  style: TextStyle(color: fontGreyDark)));
        } else {
          var data = snapshot.data!.docs;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var orderData = data[index].data() as Map<String, dynamic>;
              var products = orderData['orders'] as List<dynamic>;

              List<Widget> productDetailWidgets = products.map((product) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'x${product['qty']}',
                          style: const TextStyle(
                              fontSize: 12,
                              color: fontGreyDark,
                              fontFamily: regular),
                        ),
                      ),
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
                                    fontFamily: regular, fontSize: 14)),
                            Text('${product['price']} Bath',
                                style: const TextStyle(color: fontGreyDark)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList();

              return InkWell(
                onTap: () {
                  Get.to(() => OrdersDetails(data: orderData));
                },
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Order code ${orderData['order_code']}",
                          style: const TextStyle(
                              color: fontGreyDark,
                              fontFamily: medium,
                              fontSize: 16)),
                      const SizedBox(height: 10),
                      ...productDetailWidgets,
                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black),
                          children: [
                            const TextSpan(
                                text: 'Total   ',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: regular,
                                    color: fontGreyDark)),
                            TextSpan(
                                text: '${orderData['total_amount']}',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: regular,
                                    color: fontGreyDark)),
                            const TextSpan(
                                text: '   Bath',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: regular,
                                    color: fontGreyDark)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  .box
                  .color(whiteColor)
                  .roundedSM
                  .shadowSm
                  .margin(const EdgeInsets.all(12))
                  .p12
                  .make();
            },
          );
        }
      },
    );
  }
}
