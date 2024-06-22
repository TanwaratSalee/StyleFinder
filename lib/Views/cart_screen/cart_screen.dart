import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/cart_screen/shipping_screen.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:flutter_finalproject/Views/widgets_common/tapButton.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/cart_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  Future<Map<String, List<DocumentSnapshot>>> groupProductsByVendor(
      List<DocumentSnapshot> data) async {
    Map<String, List<DocumentSnapshot>> groupedProducts = {};

    for (var doc in data) {
      String vendorId = doc['vendor_id'];
      DocumentSnapshot vendorSnapshot = await FirebaseFirestore.instance
          .collection('vendors')
          .doc(vendorId)
          .get();

      String vendorName = vendorSnapshot['name'] ?? 'Unknown Vendor';
      if (!groupedProducts.containsKey(vendorName)) {
        groupedProducts[vendorName] = [];
      }
      groupedProducts[vendorName]!.add(doc);
    }

    return groupedProducts;
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final User? currentUser = FirebaseAuth.instance.currentUser;

    // Initialize the CartController
    final CartController cartController = Get.put(CartController());

    return Scaffold(
      backgroundColor: whiteColor,
      bottomNavigationBar: SizedBox(
        height: 85,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 35),
          child: tapButton(
            color: primaryApp,
            onPress: () {
              print(
                  "Proceeding to shipping with cart items: ${cartController.productSnapshot} and total price: ${cartController.totalP.value}");
              Get.to(() => ShippingInfoDetails(
                    cartItems: cartController.productSnapshot.toList(),
                    totalPrice: cartController.totalP.value,
                  ));
            },
            textColor: whiteColor,
            title: "Proceed to shipping",
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: StreamBuilder(
        stream: _firestore
            .collection('cart')
            .where('user_id', isEqualTo: currentUser?.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No items in the cart'));
          }

          // Update CartController with the data from Firestore
          cartController.updateCart(snapshot.data!.docs);

          return FutureBuilder<Map<String, List<DocumentSnapshot>>>(
            future: groupProductsByVendor(snapshot.data!.docs),
            builder: (context, vendorSnapshot) {
              if (vendorSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!vendorSnapshot.hasData || vendorSnapshot.data!.isEmpty) {
                return const Center(child: Text('No vendors found'));
              }

              var groupedProducts = vendorSnapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: groupedProducts.keys.map((vendorName) {
                    List<DocumentSnapshot> vendorProducts =
                        groupedProducts[vendorName]!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              15.widthBox,
                              Image.asset(iconsStore, width: 18),
                              5.widthBox,
                              Text(
                                vendorName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: medium,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: vendorProducts.map((productDoc) {
                              var data =
                                  productDoc.data() as Map<String, dynamic>?;

                              String productId = data?['product_id'] ?? '';
                              int qty = data?['qty'] ?? 0;
                              String selectSize = data?['select_size'] ?? '';
                              double totalPrice = (data?['total_price']
                                      is String)
                                  ? double.tryParse(data?['total_price']) ?? 0.0
                                  : data?['total_price'] is int
                                      ? (data?['total_price'] as int).toDouble()
                                      : data?['total_price'] ?? 0.0;
                              String userId = data?['user_id'] ?? '';

                              return FutureBuilder<DocumentSnapshot>(
                                future: _firestore
                                    .collection('products')
                                    .doc(productId)
                                    .get(),
                                builder: (context, productSnapshot) {
                                  if (productSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }

                                  if (!productSnapshot.hasData ||
                                      !productSnapshot.data!.exists) {
                                    return const Center(
                                        child: Text('Product not found'));
                                  }

                                  var productData = productSnapshot.data!.data()
                                      as Map<String, dynamic>;
                                  String productName =
                                      productData['name'] ?? '';
                                  List<dynamic> productImages =
                                      productData['imgs'] ?? [];
                                  double productPrice = (productData['price']
                                          is String)
                                      ? double.tryParse(productData['price']) ??
                                          0.0
                                      : productData['price'] is int
                                          ? (productData['price'] as int)
                                              .toDouble()
                                          : productData['price'] ?? 0.0;

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ItemDetails(
                                            title: productName,
                                            data: productData,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              productImages.isNotEmpty
                                                  ? Image.network(
                                                      productImages[0],
                                                      height: 70,
                                                      width: 70)
                                                  : loadingIndicator(),
                                              10.widthBox,
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    productName,
                                                    style: const TextStyle(
                                                      fontFamily: medium,
                                                      fontSize: 16,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ).box.width(170).make(),
                                                  Text('Size: $selectSize')
                                                      .text
                                                      .color(greyDark)
                                                      .size(14)
                                                      .make(),
                                                  "Total ${NumberFormat('#,##0').format(double.parse('$totalPrice').toInt())} Bath"
                                                      .text
                                                      .color(greyDark)
                                                      .fontFamily(regular)
                                                      .size(14)
                                                      .make(),
                                                ],
                                              ),
                                              Spacer(),
                                              IconButton(
                                                icon: Icon(Icons.remove),
                                                onPressed: () {
                                                  cartController
                                                      .decrementCount(
                                                          productDoc.id);
                                                },
                                              ),
                                              Text('$qty'),
                                              IconButton(
                                                icon: Icon(Icons.add),
                                                onPressed: () {
                                                  cartController.incrementCount(
                                                      productDoc.id);
                                                },
                                              ),
                                              SizedBox(height: 10),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                          Divider(color: greyLine),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
