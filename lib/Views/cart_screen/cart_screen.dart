import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_finalproject/Views/cart_screen/shipping_screen.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:flutter_finalproject/Views/widgets_common/tapButton.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/cart_controller.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(CartController());
  }

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

  Future<String> getProductImage(String productId) async {
    DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get();
    return productSnapshot['imgs'][0] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      bottomNavigationBar: SizedBox(
        height: 85,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 35),
          child: tapButton(
            color: primaryApp,
            onPress: () {
              Get.to(() => ShippingInfoDetails());
            },
            textColor: whiteColor,
            title: "Proceed to shipping",
          ),
        ),
      ),
      appBar: AppBar(
        title: "Cart".text.size(26).fontFamily(semiBold).color(blackColor).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getCart(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: "Cart is empty".text.color(greyDark).make(),
            );
          } else {
            var data = snapshot.data!.docs;
            controller.calculate(data);
            controller.productSnapshot.value = data;

            return FutureBuilder(
              future: groupProductsByVendor(data),
              builder: (context, AsyncSnapshot<Map<String, List<DocumentSnapshot>>> groupedSnapshot) {
                if (!groupedSnapshot.hasData) {
                  return Center(
                    child: loadingIndicator(),
                  );
                }

                var groupedProducts = groupedSnapshot.data!;

                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: groupedProducts.entries.map((entry) {
                            String vendorName = entry.key;
                            List<DocumentSnapshot> vendorProducts = entry.value;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    vendorName,
                                    style: TextStyle(
                                      color: blackColor,
                                      fontFamily: semiBold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Column(
                                  children: vendorProducts.map((product) {
                                    String formattedPrice =
                                        NumberFormat('#,##0', 'en_US')
                                            .format(product['tprice']);
                                    return FutureBuilder(
                                      future: getProductImage(product.id),
                                      builder: (context, AsyncSnapshot<String> imageSnapshot) {
                                        if (!imageSnapshot.hasData) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }

                                        return Slidable(
                                          key: Key(product.id),
                                          endActionPane: ActionPane(
                                            motion: const ScrollMotion(),
                                            children: [
                                              SlidableAction(
                                                onPressed: (context) {
                                                  FirestoreServices.deleteDocument(
                                                      product.id);
                                                },
                                                backgroundColor: redThinColor,
                                                foregroundColor: redColor,
                                                icon: Icons.delete,
                                                label: 'Delete',
                                              ),
                                            ],
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              navigateToItemDetails(
                                                  context, product['title']);
                                            },
                                            child: Column(
                                              children: [
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(left: 15),
                                                      alignment: Alignment.centerLeft,
                                                      child: Text("x${product['qty']}")
                                                          .text
                                                          .size(14)
                                                          .color(greyDark)
                                                          .fontFamily(regular)
                                                          .make(),
                                                    ),
                                                    15.widthBox,
                                                    Container(
                                                      height: 70,
                                                      child: Stack(
                                                        children: [
                                                          Image.network(
                                                            imageSnapshot.data!,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    //information each product
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            width: 140,
                                                            child: Text(
                                                              product['title'],
                                                              overflow: TextOverflow.ellipsis,
                                                              softWrap: false,
                                                              style: TextStyle(
                                                                color: blackColor,
                                                                fontFamily: medium,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                          if (product['productsize'] != null && product['productsize'].isNotEmpty)
                                                            Text(
                                                              'Size: ${product['productsize']}',
                                                              style: TextStyle(
                                                                color: greyDark,
                                                                fontFamily: regular,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          SizedBox(height: 3),
                                                          Text(
                                                            "$formattedPrice Bath",
                                                            style: TextStyle(
                                                              color: greyDark,
                                                              fontFamily: regular,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // add count of product
                                                    Row(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          width: 25,
                                                          height: 25,
                                                          child: FloatingActionButton(
                                                            heroTag: 'decrement-${product.id}',
                                                            onPressed: () {
                                                              controller.decrementCount(product.id);
                                                            },
                                                            tooltip: 'Decrement',
                                                            child: Icon(Icons.remove),
                                                            backgroundColor: greyThin,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                                            ),
                                                            elevation: 0,
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        Obx(() {
                                                          var currentItem = controller.productSnapshot
                                                              .firstWhere((element) => element.id == product.id);
                                                          return Text('${currentItem['qty']}', style: TextStyle(fontSize: 18));
                                                        }),
                                                        SizedBox(width: 10),
                                                        SizedBox(
                                                          width: 25,
                                                          height: 25,
                                                          child: FloatingActionButton(
                                                            heroTag: 'increment-${product.id}',
                                                            onPressed: () {
                                                              controller.incrementCount(product.id);
                                                            },
                                                            tooltip: 'Increment',
                                                            child: Icon(Icons.add),
                                                            backgroundColor: primaryApp,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                                            ),
                                                            elevation: 0,
                                                          ),
                                                        ),
                                                      ],
                                                    ).box.margin(EdgeInsets.only(right: 20)).make(),
                                                  ],
                                                ),
                                                10.heightBox,
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                                Divider(
                                  thickness: 1,
                                  color: greyLine,
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                "Total price  "
                                    .text
                                    .fontFamily(regular)
                                    .color(greyDark)
                                    .size(14)
                                    .make(),
                                "${controller.totalP.value}"
                                    .numCurrency
                                    .text
                                    .size(18)
                                    .fontFamily(medium)
                                    .color(blackColor)
                                    .make(),
                                "  Bath"
                                    .text
                                    .fontFamily(regular)
                                    .color(greyDark)
                                    .size(14)
                                    .make(),
                              ],
                            ),
                          ],
                        ).box.padding(const EdgeInsets.all(14)).withDecoration(BoxDecoration(border: Border(top: BorderSide(color: greyLine, width: 1)))).make();
                      }),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void navigateToItemDetails(BuildContext context, String productName) {
    FirebaseFirestore.instance
        .collection('products')
        .where('name', isEqualTo: productName)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var productData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetails(
              title: productData['name'],
              data: productData,
            ),
          ),
        );
      }
    });
  }
}

void navigateToItemDetails(BuildContext context, String productName) {
  FirebaseFirestore.instance
      .collection('products')
      .where('name', isEqualTo: productName)
      .limit(1)
      .get()
      .then((QuerySnapshot querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      var productData = querySnapshot.docs.first.data() as Map<String, dynamic>;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemDetails(
            title: productData['name'],
            data: productData,
          ),
        ),
      );
    }
  });
}
