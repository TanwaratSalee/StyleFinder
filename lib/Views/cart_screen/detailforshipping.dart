import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/cart_screen/payment_method.dart';
import 'package:flutter_finalproject/Views/widgets_common/tapButton.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  Future<String> getVendorName(String vendorId) async {
    DocumentSnapshot vendorSnapshot = await FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorId)
        .get();

    if (vendorSnapshot.exists) {
      return vendorSnapshot['name'] ?? 'Unknown Vendor';
    } else {
      return 'Unknown Vendor';
    }
  }

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
    String formattedPrice = NumberFormat('#,##0', 'en_US').format(totalPrice);

    print(
        "Received address: $address, cart items: $cartItems, and total price: $totalPrice");

    // Group the cart items by vendor id
    Map<String, List<DocumentSnapshot>> groupedProducts = {};
    for (var doc in cartItems) {
      String vendorId = doc['vendor_id'] ?? 'Unknown Vendor';
      if (!groupedProducts.containsKey(vendorId)) {
        groupedProducts[vendorId] = [];
      }
      groupedProducts[vendorId]!.add(doc);
    }

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
              SizedBox(height: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Order List")
                      .text
                      .size(20)
                      .fontFamily(semiBold)
                      .make(),
                  Divider(color: greyThin),
                  // Display the grouped products by vendor id
                  ...groupedProducts.entries.map((entry) {
                    String vendorId = entry.key;
                    List<DocumentSnapshot> products = entry.value;

                    return FutureBuilder<String>(
                      future: getVendorName(vendorId),
                      builder: (context, vendorSnapshot) {
                        if (vendorSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (!vendorSnapshot.hasData ||
                            vendorSnapshot.data == null) {
                          return Center(child: Text('Unknown Vendor'));
                        }
                        String sellerName = vendorSnapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                children: [
                                  Image.asset(
                                    iconsStore,
                                    width: 18,
                                  ),
                                  10.widthBox,
                                  Text(sellerName)
                                      .text
                                      .size(16)
                                      .fontFamily(semiBold)
                                      .color(blackColor)
                                      .make(),
                                ],
                              ),
                            ),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                var item = products[index];
                                String itemPrice =
                                    NumberFormat('#,##0', 'en_US')
                                        .format(item['total_price']);

                                // Fetch product data using product_id
                                return FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection('products')
                                      .doc(item['product_id'])
                                      .get(),
                                  builder: (context, productSnapshot) {
                                    if (productSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (!productSnapshot.hasData ||
                                        !productSnapshot.data!.exists) {
                                      return Center(
                                          child: Text('Product not found'));
                                    }

                                    var productData = productSnapshot.data!
                                        .data() as Map<String, dynamic>;
                                    String title = productData['name'] ?? '';
                                    String imgUrl =
                                        productData['imgs'][0] ?? '';

                                    return Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text('x${item['qty']}')
                                                .text
                                                .size(12)
                                                .fontFamily(regular)
                                                .color(greyDark)
                                                .make(),
                                            const SizedBox(width: 5),
                                            Image.network(imgUrl,
                                                width: 50,
                                                height: 60,
                                                fit: BoxFit.cover),
                                            const SizedBox(width: 15),
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  title,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )
                                                    .text
                                                    .size(14)
                                                    .fontFamily(medium)
                                                    .color(blackColor)
                                                    .make(),
                                                Text(
                                                  '$itemPrice Bath',
                                                  style: const TextStyle(
                                                      color: greyDark),
                                                ),
                                              ],
                                            )),
                                          ],
                                        )
                                            .box
                                            .padding(EdgeInsets.only(bottom: 5))
                                            .make(),
                                      ],
                                    );
                                  },
                                );
                              },
                            )
                          ],
                        );
                      },
                    );
                  }).toList(),
                  Divider(color: greyThin),
                  5.heightBox,
                  Row(
                    children: [
                      Text(
                        "Total   $formattedPrice  Bath",
                      ).text.size(14).color(greyDark).fontFamily(medium).make(),
                    ],
                  ).box.padding(EdgeInsets.only(left: 15)).make(),
                ],
              )
                  .box
                  .white
                  .border(color: greyThin)
                  .padding(EdgeInsets.symmetric(horizontal: 22, vertical: 15))
                  .rounded
                  .make()
            ],
          ),
        ),
      ),
    );
  }
}
