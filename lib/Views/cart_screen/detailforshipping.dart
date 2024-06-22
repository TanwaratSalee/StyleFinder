import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/cart_screen/payment_method.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:flutter_finalproject/Views/widgets_common/tapButton.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/cart_controller.dart';

class DetailForShipping extends StatelessWidget {
  final Map<String, dynamic>? address;
  final List<DocumentSnapshot> cartItems;
  final int totalPrice;

  const DetailForShipping({
    Key? key,
    required this.address,
    required this.cartItems,
    required this.totalPrice,
  }) : super(key: key);

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

  Future<String?> getVendorName(String vendorId) async {
    final doc = await FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorId)
        .get();
    if (doc.exists) {
      final data = doc.data();
      return data?['name'];
    }
    return null;
  }

  Future<Map<String, dynamic>?> getProductDetails(String productId) async {
    final doc = await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get();
    if (doc.exists) {
      return doc.data();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final CartController cartController = Get.put(CartController());

    String formattedPrice = NumberFormat('#,##0', 'en_US').format(totalPrice);

    return Scaffold(
      appBar: AppBar(
        title: Text("Details For Shipping")
            .text
            .size(24)
            .fontFamily(semiBold)
            .color(blackColor)
            .make(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: SizedBox(
          height: 50,
          child: tapButton(
            onPress: () {
              Get.to(() => const PaymentMethods());
            },
            color: primaryApp,
            textColor: whiteColor,
            title: "Confirm order information",
          ),
        ).box.padding(EdgeInsets.symmetric(vertical: 12)).white.make(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  8.heightBox,
                  Text("Shipping Address")
                      .text
                      .size(20)
                      .fontFamily(semiBold)
                      .make(),
                  8.heightBox,
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined),
                      20.widthBox,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (address != null) ...[
                            Text('${address!['firstname']} ${address!['surname']}')
                                .text
                                .size(14)
                                .fontFamily(medium)
                                .make(),
                            Text('${address!['address']}')
                                .text
                                .size(12)
                                .fontFamily(regular)
                                .make(),
                            Text('${address!['city']}, ${address!['state']} ${address!['postalCode']}')
                                .text
                                .size(12)
                                .fontFamily(regular)
                                .make(),
                            Text('${formatPhoneNumber(address!['phone'])}')
                                .text
                                .size(12)
                                .fontFamily(regular)
                                .make(),
                          ],
                        ],
                      )
                    ],
                  )
                ],
              )
                  .box
                  .white
                  .border(color: greyThin)
                  .padding(EdgeInsets.fromLTRB(22, 0, 22, 10))
                  .rounded
                  .make(),
              20.heightBox,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Order List").text.size(20).fontFamily(semiBold).make(),
              Divider(color: greyLine,),
              FutureBuilder<QuerySnapshot>(
                future: _firestore.collection('cart').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error loading cart items'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No items in cart'));
                  }

                  final cartDocs = snapshot.data!.docs;

                  // Group cart items by vendor_id
                  final groupedItems = <String, List<DocumentSnapshot>>{};
                  for (var doc in cartDocs) {
                    final vendorId = doc['vendor_id'] as String;
                    if (!groupedItems.containsKey(vendorId)) {
                      groupedItems[vendorId] = [];
                    }
                    groupedItems[vendorId]!.add(doc);
                  }

                  return Column(
                    children: groupedItems.entries.map((entry) {
                      final vendorId = entry.key;
                      final items = entry.value;
                      return FutureBuilder<String?>(
                        future: getVendorName(vendorId),
                        builder: (context, vendorSnapshot) {
                          if (vendorSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (vendorSnapshot.hasError ||
                              !vendorSnapshot.hasData) {
                            return Center(
                                child: Text('Error loading vendor name'));
                          }

                          final vendorName =
                              vendorSnapshot.data ?? 'Unknown Vendor';

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(iconsStore, width: 18),
                                  5.widthBox,
                                  Text(
                                    vendorName,
                                    style: TextStyle(
                                        fontSize: 18, fontFamily: medium),
                                  ),
                                ],
                              ),
                              ...items.map((item) {
                                return FutureBuilder<Map<String, dynamic>?>(
                                  future: getProductDetails(item['product_id']),
                                  builder: (context, productSnapshot) {
                                    if (productSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }

                                    if (productSnapshot.hasError ||
                                        !productSnapshot.hasData) {
                                      return Center(
                                          child: Text(
                                              'Error loading product details'));
                                    }

                                    final productDetails = productSnapshot.data;
                                    final productName =
                                        productDetails?['name'] ??
                                            'Unknown Product';
                                    final productImage =
                                        productDetails?['imgs'] != null
                                            ? productDetails!['imgs'][0]
                                            : null;

                                    return Row(
                                      children: [
                                        Text('x${item['qty']}'),
                                        5.widthBox,
                                         productImage != null
                                                  ? Image.network(productImage,
                                                      width: 65, height: 70)
                                                  : Icon(Icons.image),
                                                  15.widthBox,
                                                  Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                  '$productName',
                                                  style: TextStyle(color: blackColor, fontFamily: medium, fontSize: 16),
                                                  softWrap: false,
                                                  overflow: TextOverflow.ellipsis,
                                                ).box.width(200).make(),
                                                  Text('Size: ${item['select_size']}').text.size(14).color(greyDark).fontFamily(regular).make(),
                                                   Text('Total ${NumberFormat('#,##0').format(double.parse('${item['total_price']}').toInt())} Bath',
                                                    style: TextStyle(color: greyDark, fontFamily: regular, fontSize: 14)),
                                                ],
                                              ),
                                      ],
                                    ).paddingSymmetric(vertical: 5);
                                  },
                                );
                              }).toList(),
                              10.heightBox,
                            ],
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            
                ],
              ).box.border(color: greyLine).rounded.p12.make()
              ],
          ),
        ),
      ),
    );
  }
}
