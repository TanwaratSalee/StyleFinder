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
      height: 85,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 35),
        child: tapButton(
          color: primaryApp,
          onPress: () {
            Get.to(() => const ShippingDetails());
          },
          textColor: whiteColor,
          title: "Proceed to shipping",
        ),
      ),
    ),
    appBar: AppBar(
      title: "Cart".text.color(greyDark).fontFamily(regular).make(),
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
          controller.productSnapshot = data;

          return Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      String formattedPrice = NumberFormat('#,##0', 'en_US')
                          .format(data[index]['tprice']);

                      return Slidable(
                        key: Key(data[index].id),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                FirestoreServices.deleteDocument(data[index].id);
                              },
                              backgroundColor: redThinColor,
                              foregroundColor: redColor,
                              icon: Icons.delete,
                              label: 'Delete',
                              spacing: 1,
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            navigateToItemDetails(
                                context, data[index]['title']);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 16),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(left: 5),
                                      alignment: Alignment.centerLeft,
                                      child: Text("x${data[index]['qty']}")
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
                                            data[index]['img'],
                                            fit: BoxFit.cover,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 140,
                                            child: Text(
                                              data[index]['title'],
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                              style: TextStyle(
                                                color: blackColor,
                                                fontFamily: medium,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          (data[index]['productsize'] != null &&
                                                  data[index]['productsize']
                                                      .isNotEmpty)
                                              ? Text(
                                                  'Size: ${data[index]['productsize']}',
                                                  style: TextStyle(
                                                    color: greyDark,
                                                    fontFamily: regular,
                                                    fontSize: 12,
                                                  ),
                                                )
                                              : SizedBox.shrink(),
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
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: FloatingActionButton(
                                            heroTag: 'decrement-${data[index].id}',
                                            onPressed:
                                                controller.decrementCount,
                                            tooltip: 'Decrement',
                                            child: Icon(Icons.remove),
                                            backgroundColor: greyThin,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(6)),
                                            ),
                                            elevation: 0,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Obx(() => Text('${controller.count}',
                                            style: TextStyle(fontSize: 18))),
                                        SizedBox(width: 10),
                                        SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: FloatingActionButton(
                                            heroTag: 'increment-${data[index].id}',
                                            onPressed:
                                                controller.incrementCount,
                                            tooltip: 'Increment',
                                            child: Icon(Icons.add),
                                            backgroundColor: primaryApp,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(6)),
                                            ),
                                            elevation: 0,
                                          )
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(color: greyThin),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
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
                            .color(greyDark)
                            .size(14)
                            .make(),
                      ],
                    ),
                  ],
                )
                    .box
                    .padding(const EdgeInsets.all(14))
                    .withDecoration(BoxDecoration(
                        border: Border(
                            top: BorderSide(color: greyLine, width: 1))))
                    .make(),
              ],
            ),
          );
        }
      },
    ),
  );
}


  void navigateToItemDetails(BuildContext context, String productName) {
    FirebaseFirestore.instance
        .collection('products')
        .where('p_name', isEqualTo: productName)
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
      }
    });
  }
}
