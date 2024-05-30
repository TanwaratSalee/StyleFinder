import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  String formatPhoneNumber(String phone) {
    String cleaned = phone.replaceAll(RegExp(r'\D'), '');

    if (cleaned.length == 10) {
      final RegExp regExp = RegExp(r'(\d{3})(\d{3})(\d{4})');
      return cleaned.replaceAllMapped(regExp, (Match match) {
        return '(+66) ${match[1]}-${match[2]}-${match[3]}';
      });
    } else if (cleaned.length == 9) {
      final RegExp regExp = RegExp(r'(\d{2})(\d{3})(\d{4})');
      return cleaned.replaceAllMapped(regExp, (Match match) {
        return '(+66) ${match[1]}-${match[2]}-${match[3]}';
      });
    }
    return phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text(
          "Order Details",
        ).text.size(26).fontFamily(semiBold).color(blackColor).make(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                    .roundedSM
                    .border(color: greyLine)
                    .padding(const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 12))
                    .make(),
              ),
              15.heightBox,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Shipping Address",
                  ).text.size(20).black.fontFamily(medium).make(),
                  5.heightBox,
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined),
                      20.widthBox,
                      Text(
                          "${data['order_by_firstname']} ${data['order_by_surname']},\n${data['order_by_address']},\n${data['order_by_city']}, ${data['order_by_state']},${data['order_by_postalcode']}\n${formatPhoneNumber(data['order_by_phone'])}"),
                    ],
                  ),
                ],
              )
                  .box
                  .color(whiteColor)
                  .roundedSM
                  .border(color: greyLine)
                  .padding(
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 12))
                  .make(),
              const SizedBox(height: 15),
              Container(
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('Order Code :    ')
                                .text
                                .size(14)
                                .black
                                .fontFamily(semiBold)
                                .make(),
                            Text(data['order_code'])
                          ],
                        ),
                        5.heightBox,
                        Row(
                          children: [
                            Text('Order Date :    ')
                                .text
                                .size(14)
                                .black
                                .fontFamily(semiBold)
                                .make(),
                            Text(intl.DateFormat()
                                .add_yMd()
                                .format((data['order_date'].toDate())))
                          ],
                        ),
                        5.heightBox,
                        Row(
                          children: [
                            Text('Payment Method :    ')
                                .text
                                .size(14)
                                .black
                                .fontFamily(semiBold)
                                .make(),
                            Text(data['shipping_method'])
                          ],
                        ),
                      ],
                    )),
              )
                  .box
                  .color(whiteColor)
                  .roundedSM
                  .border(color: greyLine)
                  .padding(const EdgeInsets.all(6))
                  .make(),

              15.heightBox,

              Column(
                children: [
                  Column(
                    children: [
                     Row(
                            children: [
                              Image.asset(iconsStore, width: 18,),
                              10.widthBox,
                              // Text(sellerName)
                              //     .text
                              //     .size(16)
                              //     .fontFamily(semiBold)
                              //     .color(blackColor)
                              //     .make(),
                            ],
                          ),
                    ],
                  ),
                  10.heightBox,
                  ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data['orders'].length,
                    itemBuilder: (context, index) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'x${data['orders'][index]['qty']}',
                          )
                              .text
                              .size(12)
                              .fontFamily(regular)
                              .color(greyDark)
                              .make(),
                          const SizedBox(width: 5),
                          Image.network(data['orders'][index]['img'],
                              width: 50, height: 60, fit: BoxFit.cover),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['orders'][index]['title'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                                    .text
                                    .size(14)
                                    .fontFamily(semiBold)
                                    .color(greyDark)
                                    .make(),
                                Text(
                                  '${NumberFormat('#,##0').format(data['orders'][index]['price'])} Bath',
                                  style: const TextStyle(color: greyDark),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ).box.padding(EdgeInsets.symmetric(vertical: 5)).make();
                    },
                  )
                ],
              )
                  .box
                  .color(whiteColor)
                  .padding(EdgeInsets.fromLTRB(20, 10, 20, 0))
                  .roundedSM
                  .border(color: greyLine)
                  .make()
            ],
          ),
        ),
      ),
    );
  }
}
