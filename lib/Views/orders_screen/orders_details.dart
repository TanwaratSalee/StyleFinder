import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/orders_screen/component/order_place_details.dart';
import 'package:flutter_finalproject/Views/orders_screen/component/orders_status.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:intl/intl.dart' as intl;

class OrdersDetails extends StatelessWidget {
  final dynamic data;
  const OrdersDetails({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text(
          "Order Details",
          style: TextStyle(fontFamily: regular, color: greyDark2),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                        "Order Status",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: regular,
                          color: greyDark2,
                        ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 80,
                          child: orderStatus(
                            icon: icPlaced,
                            title: "Placed",
                            showDone: data['order_placed'],
                          ),
                        ),
                        Container(
                          width: 80,
                          child: orderStatus(
                            icon: icConfirm,
                            title: "Confirmed",
                            showDone: data['order_confirmed'],
                          ),
                        ),
                        Container(
                          width: 80,
                          child: orderStatus(
                            icon: icOnDelivery,
                            title: "On Delivery",
                            showDone: data['order_on_delivery'],
                          ),
                        ),
                        Container(
                          width: 80,
                          child: orderStatus(
                            icon: icDelivered,
                            title: "Delivered",
                            showDone: data['order_delivered'],
                          ),
                        ),
                      ],
                    ),
                  ],
                ).box.color(whiteColor).shadowSm.roundedSM.padding(const EdgeInsets.all(12)).make(),
              ),
              // const Divider(),
              const SizedBox(height: 10),
              Column(
                children: [
                  orderPlaceDetails(
                    d1: data['order_code'],
                    d2: data['shipping_method'],
                    title1: "Order Code",
                    title2: "Shipping Method",
                  ),
                  orderPlaceDetails(
                    d1: intl.DateFormat()
                        .add_yMd()
                        .format((data['order_date'].toDate())),
                    d2: data['payment_method'],
                    title1: "Order Date",
                    title2: "Payment Method",
                  ),
                  orderPlaceDetails(
                    d1: "Unpaid",
                    d2: "Order Placed",
                    title1: "Payment Status",
                    title2: "Delivery Status",
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Shipping Address",
                              style: TextStyle(fontFamily: regular),
                            ),
                            Text("${data['order_by_firstname']}"),
                            Text("${data['order_by_surname']}"),
                            Text("${data['order_by_email']}"),
                            Text("${data['order_by_address']}"),
                            Text("${data['order_by_city']}"),
                            Text("${data['order_by_state']}"),
                            Text("${data['order_by_phone']}"),
                            Text("${data['order_by_postalcode']}"),
                          ],
                        ),
                        SizedBox(
                          width: 130,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Total Amount",
                                style: TextStyle(fontFamily: regular),
                              ),
                              Text(
                                "${data['total_amount']}",
                                style: const TextStyle(
                                  color: primaryApp,
                                  fontFamily: bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ).box.outerShadowMd.white.make(),
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                "Ordered Product",
                style: TextStyle(
                  fontSize: 16,
                  color: greyDark2,
                  fontFamily: regular,
                ),
              ) .text
                  .size(16)
                  .color(greyDark2)
                  .fontFamily(regular)
                  .makeCentered(),
              const SizedBox(height: 10),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: data['orders'].length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      orderPlaceDetails(
                        title1: data['orders'][index]['title'],
                        title2: data['orders'][index]['tprice'],
                        d1: "${data['orders'][index]['qty']}x",
                        d2: "Refundable",
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          width: 30,
                          height: 20,
                          color: Color(data['orders'][index]['color']),
                        ),
                      ),
                    ],
                  );
                },
              ).box.outerShadowMd.white.margin(const EdgeInsets.only(bottom: 4)).make(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
