import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/orders_screen/orders_details.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart'; // ต้องเพิ่ม dependency สำหรับ velocity_x ใน pubspec.yaml

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
        title: const Text("My Orders", style: TextStyle(color: fontGreyDark, fontFamily: medium)),
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
          buildOrdersList(FirestoreServices.getOrderHistory(),
              showReviewButton: true), // แสดงปุ่มในแท็บ History
        ],
      ),
    );
  }

  Widget buildOrdersList(Stream<QuerySnapshot> stream,
      {bool showReviewButton = false}) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: loadingIndicator());
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

              List<Widget> productDetailWidgets = [];

              // ส่วนของ "Order code" และสถานะ "Confirm"/"Pending" เป็นสิ่งแรก
              productDetailWidgets.addAll([
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order code ${orderData['order_code']}",
                        style: const TextStyle(
                            color: fontGreyDark,
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

              // ต่อด้วยรายละเอียดสินค้า
              productDetailWidgets.addAll(products.map((product) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('x${product['qty']}',
                          style: const TextStyle(
                              fontSize: 12,
                              color: fontGreyDark,
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
                                style: const TextStyle(color: fontGreyDark)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList());

              // ถ้าเป็นแท็บ "History", เพิ่มปุ่ม "Write product review"
              if (showReviewButton) {
                productDetailWidgets.add(Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ourButton(
                    title: 'Write product review',
                    color: primaryApp,
                    textColor: whiteColor,
                    onPress: () {},
                  ),
                ));
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: productDetailWidgets,
              )
                  .box
                  .color(Colors.white)
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
