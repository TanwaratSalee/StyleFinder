import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_finalproject/Views/chat_screen/chat_screen.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/orders_screen/component/orders_status.dart';
import 'package:flutter_finalproject/Views/store_screen/store_screen.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<Map<String, String>> getProductDetails(String productId) async {
    if (productId.isEmpty) {
      debugPrint('Error: productId is empty.');
      return {'name': 'Unknown Product', 'id': productId, 'imageUrl': ''};
    }

    try {
      var productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();
      if (productSnapshot.exists) {
        debugPrint('Document ID: ${productSnapshot.id}'); // Use debugPrint
        var productData = productSnapshot.data() as Map<String, dynamic>?;
        return {
          'name': productData?['name'] ?? 'Unknown Product',
          'id': productId,
          'imageUrl':
              (productData?['imgs'] != null && productData!['imgs'].isNotEmpty)
                  ? productData['imgs'][0]
                  : ''
        };
      } else {
        return {'name': 'Unknown Product', 'id': productId, 'imageUrl': ''};
      }
    } catch (e) {
      debugPrint('Error getting product name: $e');
      return {'name': 'Unknown Product', 'id': productId, 'imageUrl': ''};
    }
  }

  Future<Map<String, String>> getVendorDetails(String vendorId) async {
    if (vendorId.isEmpty) {
      debugPrint('Error: vendorId is empty.');
      return {'name': 'Unknown Vendor', 'id': vendorId};
    }

    try {
      var vendorSnapshot = await FirebaseFirestore.instance
          .collection('vendors')
          .doc(vendorId)
          .get();
      if (vendorSnapshot.exists) {
        debugPrint('Document ID: ${vendorSnapshot.id}'); // Use debugPrint
        var vendorData = vendorSnapshot.data() as Map<String, dynamic>?;
        return {
          'name': vendorData?['name'] ?? 'Unknown Vendor',
          'id': vendorId
        };
      } else {
        return {'name': 'Unknown Vendor', 'id': vendorId};
      }
    } catch (e) {
      debugPrint('Error getting vendor name: $e');
      return {'name': 'Unknown Vendor', 'id': vendorId};
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalOrderPrice = 0;

    data['orders'].forEach((orderItem) {
      totalOrderPrice += (orderItem['total_price'] ?? 0).toDouble();
    });

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
                        .fontFamily(semiBold)
                        .make(),
                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        orderStatus(
                          icon: icPlaced,
                          title: "Placed",
                          showDone: data['order_placed'] ?? false,
                        ),
                        3.widthBox,
                        horizontalLine(
                            isActive: data['order_confirmed'] ?? false),
                        orderStatus(
                          icon: icOnDelivery,
                          title: "Confirmed",
                          showDone: data['order_confirmed'] ?? false,
                        ),
                        horizontalLine(
                            isActive: data['order_on_delivery'] ?? false),
                        orderStatus(
                          icon: icDelivered,
                          title: "On Delivery",
                          showDone: data['order_on_delivery'] ?? false,
                        ),
                        horizontalLine(
                            isActive: data['order_delivered'] ?? false),
                        orderStatus(
                          icon: icHome,
                          title: "Delivered",
                          showDone: data['order_delivered'] ?? false,
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
                        horizontal: 32, vertical: 12))
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
                          "${data['order']['order_by_firstname'] ?? ''} ${data['order']['order_by_surname'] ?? ''},\n"
                          "${data['order']['order_by_address'] ?? ''},\n"
                          "${data['order']['order_by_city'] ?? ''}, "
                          "${data['order']['order_by_state'] ?? ''}, "
                          "${data['order']['order_by_postalcode'] ?? ''}\n"
                          "${formatPhoneNumber(data['order']['order_by_phone'] ?? '')}"),
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
                            Text('Order Code : ')
                                .text
                                .size(14)
                                .black
                                .fontFamily(semiBold)
                                .make(),
                            Text(data['order_id'] ?? '')
                          ],
                        ),
                        5.heightBox,
                        Row(
                          children: [
                            Text('Order Date : ')
                                .text
                                .size(14)
                                .black
                                .fontFamily(semiBold)
                                .make(),
                            Text(data['created_at'] != null
                                ? intl.DateFormat()
                                    .add_yMd()
                                    .format((data['created_at'].toDate()))
                                : '')
                          ],
                        ),
                        5.heightBox,
                        Row(
                          children: [
                            Text('Payment Method : ')
                                .text
                                .size(14)
                                .black
                                .fontFamily(semiBold)
                                .make(),
                            Text(data['payment_method'] ?? '')
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
              GestureDetector(
                onTap: () async {
                  var vendorDetails = await getVendorDetails(
                      data['orders'][0]['vendor_id'] ?? '');
                  Get.to(() => const ChatScreen(), arguments: [
                    vendorDetails['name'] ?? '',
                    vendorDetails['id'] ?? ''
                  ]);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          icMessage,
                          width: 25,
                        ),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chat with seller',
                              style: TextStyle(
                                  color: blackColor,
                                  fontFamily: medium,
                                  fontSize: 16),
                            ),
                            Text(
                              'Product, pre-shipping issues, and other questions',
                              style: TextStyle(
                                  color: greyDark,
                                  fontFamily: regular,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Image.asset(
                      icSeeAll,
                      width: 12,
                    ),
                  ],
                ),
              )
                  .box
                  .color(whiteColor)
                  .padding(EdgeInsets.fromLTRB(6, 10, 6, 10))
                  .roundedSM
                  .border(color: greyLine)
                  .make(),
              15.heightBox,
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(iconsStore, width: 20),
                          10.widthBox,
                          FutureBuilder<Map<String, String>>(
                            future: getVendorDetails(
                                data['orders'][0]['vendor_id'] ?? ''),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              if (!snapshot.hasData ||
                                  snapshot.data!['name']!.isEmpty) {
                                return Text('Unknown Vendor');
                              }

                              return Text(snapshot.data!['name']!)
                                  .text
                                  .size(16)
                                  .fontFamily(semiBold)
                                  .color(blackColor)
                                  .make();
                            },
                          ),
                        ],
                      ),
                       Image.asset(
                      icSeeAll,
                      width: 12,
                    ),
                    ],
                  ).paddingSymmetric(horizontal: 6),
                  Divider(color: greyLine),
                  5.heightBox,
                  ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data['orders'].length,
                    itemBuilder: (context, index) {
                      var orderItem = data['orders'][index];
                      String productId = orderItem['product_id'] ?? '';

                      return FutureBuilder<Map<String, String>>(
                        future: getProductDetails(productId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }
                          if (!snapshot.hasData) {
                            return Center(child: Text('Product not found'));
                          }

                          var productDetails = snapshot.data!;

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'x${orderItem['qty'] ?? 0}',
                              )
                                  .text
                                  .size(16)
                                  .fontFamily(regular)
                                  .color(greyDark)
                                  .make(),
                              const SizedBox(width: 5),
                              productDetails['imageUrl']!.isNotEmpty
                                  ? Image.network(productDetails['imageUrl']!,
                                      width: 70, height: 80, fit: BoxFit.cover)
                                  : loadingIndicator(),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productDetails['name'] ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                        .text
                                        .size(16)
                                        .fontFamily(semiBold)
                                        .color(greyDark)
                                        .make(),
                                    Text(
                                      '${NumberFormat('#,##0').format(orderItem['total_price'] ?? 0)} Bath',
                                      style: const TextStyle(color: greyDark),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ).paddingSymmetric(vertical: 3);
                        },
                      );
                    },
                  ),
                  Divider(color: greyLine),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Total: ${NumberFormat('#,##0').format(totalOrderPrice)} Bath',
                      style: TextStyle(
                        color: blackColor,
                        fontFamily: regular,
                        fontSize: 16,
                      ),
                    ).paddingSymmetric(vertical: 8),
                  ),
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
