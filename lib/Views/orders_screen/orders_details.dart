import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/chat_screen/chat_screen.dart';
import 'package:flutter_finalproject/Views/orders_screen/component/order_place_details.dart';
import 'package:flutter_finalproject/Views/orders_screen/component/orders_status.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';

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
        ).text.size(24).fontFamily(semiBold).color(blackColor).make(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Order Status",
                    )
                        .text
                        .size(20)
                        .color(blackColor)
                        .fontFamily(medium)
                        .makeCentered(),
                        10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        orderStatus(
                          icon: icPlaced,
                          title: "Placed",
                          showDone: data['order_placed'],
                        ),
                        3.widthBox,
                        horizontalLine(isActive: data['order_confirmed']),
                        orderStatus(
                          icon: icOnDelivery,
                          title: "Confirmed",
                          showDone: data['order_confirmed'],
                        ),
                        horizontalLine(isActive: data['order_on_delivery']),
                        orderStatus(
                          icon: icDelivered,
                          title: "On Delivery",
                          showDone: data['order_on_delivery'],
                        ),
                        horizontalLine(isActive: data['order_delivered']),
                        orderStatus(
                          icon: icHome,
                          title: "Delivered",
                          showDone: data['order_delivered'],
                        ),
                      ],
                    ),
                  ],
                )
                    .box
                    .color(whiteColor)
                    .shadowXs
                    .roundedSM
                    .border(color: greyLine)
                    .padding(const EdgeInsets.all(12))
                    .make(),
              ),
              const SizedBox(height: 15),
              Column(
                children: [
                  ListTile(
                    leading: Image.asset(
                      icPerson,
                      color: greyDark,
                      height: 20,
                    ),
                    title: Text(
                      'Contact Seller',
                      style: TextStyle(color: greyDark, fontFamily: medium),
                    ),
                    trailing: Icon(Icons.chevron_right, color: greyDark),
                    onTap: () {
                      Get.to(() => const ChatScreen(),
                          arguments: [data['p_seller'], data['vendor_id']]);
                    },
                  )
                      .box
                      .color(whiteColor)
                      .shadowXs
                      .roundedSM
                      .border(color: greyLine)
                      .padding(const EdgeInsets.symmetric(horizontal: 4))
                      .make(),
                ],
              ),
              const SizedBox(height: 15),
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
                  // orderPlaceDetails(
                  //   d1: "Order Placed",
                  //   d2: "",
                  //   title1: "Delivery Status",
                  //   title2: "",
                  // ),
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
                              style: TextStyle(fontFamily: semiBold),
                            ),
                            Text(
                                "${data['order_by_firstname']} ${data['order_by_surname']}"),
                            // Text("${data['order_by_email']}"),
                            Text("${data['order_by_address']}"),
                            Text("${data['order_by_city']}"),
                            Text("${data['order_by_state']}"),
                            Text("${data['order_by_phone']}"),
                            Text("${data['order_by_postalcode']}"),
                          ],
                        ),
                        SizedBox(
                          width: 130,
                          height: 140,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Total Amount",
                                style: TextStyle(fontFamily: semiBold),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "${intl.NumberFormat('#,##0').format(data['total_amount'])} ",
                                    style: const TextStyle(
                                        color: greyDark,
                                        fontFamily: regular,
                                        fontSize: 24),
                                  ),
                                  5.widthBox,
                                  Text('Bath')
                                      .text
                                      .fontFamily(light)
                                      .size(14)
                                      .make()
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
                  .box
                  .color(whiteColor)
                  .shadowXs
                  .roundedSM
                  .border(color: greyLine)
                  .padding(const EdgeInsets.all(6))
                  .make(),
              const SizedBox(height: 15),
              Column(
                children: [
                    const Text(
                      "Ordered Product",
                    )
                        .text
                        .size(20)
                        .color(blackColor)
                        .fontFamily(medium)
                        .makeCentered(),
                        5.heightBox,
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data['orders'].length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // orderPlaceDetails(
                          //   title1: data['orders'][index]['title'],
                          //   title2: data['orders'][index]['tprice'],
                          //   d1: "${data['orders'][index]['qty']}x",
                          //   d2: "Refundable",
                          // ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment
                                .center, 
                            children: [
                              Text(
                                'x${data['orders'][index]['qty']}',
                              ).text.size(12).fontFamily(regular).color(greyDark).make(),
                              const SizedBox(width: 5),
                              Image.network(data['orders'][index]['img'],
                                  width: 70, height: 60, fit: BoxFit.cover),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['orders'][index]['title'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ).text.size(14).fontFamily(semiBold).color(greyDark).make(),
                                    Text(
                                      '${NumberFormat('#,##0').format(data['orders'][index]['price'])} Bath',
                                      style:
                                          const TextStyle(color: greyDark),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ).box.p8.make()
                        ],
                      );
                    },
                  )
                ],
              ).box
                  .p12
                  .color(whiteColor)
                  .shadowXs
                  .roundedSM
                  .border(color: greyLine)
                  .make(),
            ],
          ),
        ),
      ),
    );
  }
}
