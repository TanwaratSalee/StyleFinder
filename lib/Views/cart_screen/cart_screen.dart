// ignore_for_file: use_super_parameters

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/cart_screen/shipping_screen.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
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
  bool isCheck = false;

  @override
  void initState() {
    super.initState();
    controller = Get.put(CartController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        bottomNavigationBar: SizedBox(
          height: 60,
          child: ourButton(
              color: primaryApp,
              onPress: () {
                Get.to(() => const ShippingDetails());
              },
              textColor: whiteColor,
              title: "Proceed to shipping"),
        ),
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: "Cart".text.color(greyDark2).fontFamily(regular).make(),
        ),
        body: StreamBuilder(
          stream: FirestoreServices.getCart(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: loadingIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: "Cart is empty".text.color(greyDark2).make(),
              );
            } else {
              var data = snapshot.data!.docs;
              controller.calculate(data);
              controller.productSnapshot = data;

              return Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              String formattedPrice =
                                  NumberFormat('#,##0', 'en_US')
                                      .format(data[index]['tprice']);

                              return InkWell(
                                onTap: () {
                                  navigateToItemDetails(
                                      context, data[index]['title']);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(left: 5),
                                            alignment: Alignment.centerLeft,
                                            child:
                                                Text("x${data[index]['qty']}")
                                                    .text
                                                    .size(14)
                                                    .color(greyDark2)
                                                    .fontFamily(regular)
                                                    .make(),
                                          ),
                                          15.widthBox,
                                          Container(
                                            width: 56,
                                            height: 70,
                                            child: Stack(
                                              children: [
                                                Image.network(
                                                  data[index]['img'],
                                                  fit: BoxFit.cover,
                                                ),
                                              ],
                                            ),
                                          ).box.border(color: thinGrey0).make(),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 220,
                                                  child: Text(
                                                    data[index]['title'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: false,
                                                    style: TextStyle(
                                                      color: greyDark2,
                                                      fontFamily: 'medium',
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  'Size: ${data[index]['productsize']}',
                                                  style: TextStyle(
                                                    color: greyDark1,
                                                    fontFamily: regular,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                SizedBox(height: 3),
                                                Text(
                                                  "$formattedPrice Bath",
                                                  style: TextStyle(
                                                    color: greyDark1,
                                                    fontFamily: regular,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              FirestoreServices.deleteDocument(
                                                  data[index].id);
                                            },
                                            child: Icon(Icons.delete,
                                                color: primaryApp),
                                          ),
                                        ],
                                      ),
                                      Divider(color: thinGrey01,).box.padding(EdgeInsets.only(top: 14)).make(), 
                                    ],
                                  ),
                                ),
                              );
                            })),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            "Total price  "
                                .text
                                .fontFamily(regular)
                                .color(greyDark1)
                                .size(14)
                                .make(),
                            Obx(
                              () => "${controller.totalP.value}"
                                  .numCurrency
                                  .text
                                  .size(18)
                                  .fontFamily(medium)
                                  .color(blackColor)
                                  .make(),
                            ),
                            "  Bath"
                                .text
                                .fontFamily(regular)
                                .color(greyDark1)
                                .size(14)
                                .make(),
                          ],
                        )
                      ],
                    )
                        .box
                        .padding(const EdgeInsets.all(22))
                        // .color(thinGrey01)
                        .border(color: thinGrey01)
                        .make(),
                  ],
                ),
              );
            }
          },
        ));
  }

  void navigateToItemDetails(BuildContext context, Productname) {
    FirebaseFirestore.instance
        .collection('products')
        .where('p_name', isEqualTo: Productname)
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
              title: productData['p_name'],
              data: productData,
            ),
          ),
        );
      } else {
        //
      }
    });
  }
}
