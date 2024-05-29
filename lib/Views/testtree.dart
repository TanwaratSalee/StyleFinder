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
        title: Text(
          "Order Details",
        ).text
            .size(28)
            .fontFamily(semiBold)
            .color(blackColor)
            .make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order Status",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: bold,
                        color: blackColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 90,
                          child: orderStatus(
                            icon: icPlaced,
                            title: "Placed",
                            showDone: data['order_placed'],
                          ),
                        ),
                        Container(
                          width: 90,
                          child: orderStatus(
                            icon: icConfirm,
                            title: "Confirmed",
                            showDone: data['order_confirmed'],
                          ),
                        ),
                        Container(
                          width: 90,
                          child: orderStatus(
                            icon: icOnDelivery,
                            title: "On Delivery",
                            showDone: data['order_on_delivery'],
                          ),
                        ),
                        Container(
                          width: 90,
                          child: orderStatus(
                            icon: icDelivered,
                            title: "Delivered",
                            showDone: data['order_delivered'],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              SizedBox(height: 10),
              // Rest of your code...
            ],
          ),
        ),
      ),
    );
  }
}
