import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/cart_screen/shipping_screen.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:flutter_finalproject/Views/widgets_common/tapButton.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/cart_controller.dart';

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
              Get.to(() => const ShippingInfoDetails());
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
        stream: _firestore.collection('cart').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No items in the cart'));
          }

          var groupedProducts = <String, List<DocumentSnapshot>>{};
          for (var doc in snapshot.data!.docs) {
            String vendorId = doc['vendor_id'];
            if (!groupedProducts.containsKey(vendorId)) {
              groupedProducts[vendorId] = [];
            }
            groupedProducts[vendorId]!.add(doc);
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: groupedProducts.keys.map((vendorId) {
                List<DocumentSnapshot> vendorProducts = groupedProducts[vendorId]!;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder<DocumentSnapshot>(
                        stream: _firestore.collection('vendors').doc(vendorId).snapshots(),
                        builder: (context, vendorSnapshot) {
                          if (vendorSnapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (!vendorSnapshot.hasData || !vendorSnapshot.data!.exists) {
                            return const Center(child: Text('Vendor not found'));
                          }

                          var vendorData = vendorSnapshot.data!.data() as Map<String, dynamic>;
                          String vendorName = vendorData['name'] ?? 'Unknown Vendor';

                          return Row(
                            children: [
                              Image.asset(iconsStore, width: 18),
                              5.widthBox,
                              Text(
                                vendorName,
                                style: TextStyle(fontSize: 18, fontFamily: medium),
                              ),
                            ],
                          );
                        },
                      ),
                      Column(
                        children: vendorProducts.map((productDoc) {
                          var data = productDoc.data() as Map<String, dynamic>?;

                          String productId = data?['product_id'] ?? '';
                          int qty = data?['qty'] ?? 0;
                          String selectSize = data?['select_size'] ?? '';
                          double totalPrice = (data?['total_price'] is String)
                              ? double.tryParse(data?['total_price']) ?? 0.0
                              : data?['total_price'] is int
                                  ? (data?['total_price'] as int).toDouble()
                                  : data?['total_price'] ?? 0.0;
                          String userId = data?['user_id'] ?? '';

                          return Dismissible(
                            key: Key(productDoc.id),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (direction) async {
                              bool confirmDelete = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Confirm Delete'),
                                    content: Text('Are you sure you want to delete this item?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              return confirmDelete;
                            },
                            onDismissed: (direction) async {
                              await _firestore.collection('cart').doc(productDoc.id).delete();
                            },
                            background: Container(
                              color: Colors.red,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              alignment: AlignmentDirectional.centerEnd,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.delete, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            child: FutureBuilder<DocumentSnapshot>(
                              future: _firestore.collection('products').doc(productId).get(),
                              builder: (context, productSnapshot) {
                                if (productSnapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }

                                if (!productSnapshot.hasData || !productSnapshot.data!.exists) {
                                  return const Center(child: Text('Product not found'));
                                }

                                var productData = productSnapshot.data!.data() as Map<String, dynamic>;
                                String productName = productData['name'] ?? '';
                                List<dynamic> productImages = productData['imgs'] ?? [];
                                double productPrice = (productData['price'] is String)
                                    ? double.tryParse(productData['price']) ?? 0.0
                                    : productData['price'] is int
                                        ? (productData['price'] as int).toDouble()
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
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            productImages.isNotEmpty
                                                ? Image.network(productImages[0], height: 70, width: 60)
                                                : loadingIndicator(),
                                            10.widthBox,
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '$productName',
                                                  style: TextStyle(color: blackColor, fontFamily: medium, fontSize: 16),
                                                  softWrap: false,
                                                  overflow: TextOverflow.ellipsis,
                                                ).box.width(150).make(),
                                                Text('Size: $selectSize', style: TextStyle(color: greyColor, fontSize: 14)),
                                                Text(
                                                    'Total ${NumberFormat('#,##0').format(double.parse('$totalPrice').toInt())} Bath',
                                                    style: TextStyle(color: greyDark, fontFamily: regular, fontSize: 14)),
                                              ],
                                            ),
                                            SizedBox(width: 20),
                                            GetBuilder<CartController>(
                                              builder: (controller) {
                                                return Row(
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(Icons.remove),
                                                      onPressed: () {
                                                        controller.decrementQuantity(productDoc);
                                                      },
                                                    ),
                                                    Text('$qty'),
                                                    IconButton(
                                                      icon: Icon(Icons.add),
                                                      onPressed: () {
                                                        controller.incrementQuantity(productDoc);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
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
      ),
    );
  }
}

