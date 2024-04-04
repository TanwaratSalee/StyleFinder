// ignore_for_file: use_super_parameters

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/cart_screen/shipping_screen.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/widgets_common/our_button.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/cart_controller.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());

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
          title: "shopping Cart"
              .text
              .color(fontGreyDark)
              .fontFamily(regular)
              .make(),
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
                child: "Cart is empty".text.color(fontGreyDark).make(),
              );
            } else {
              var data = snapshot.data!.docs;
              controller.calculate(data);
              controller.productSnapshot = data;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: Image.network(
                                  "${data[index]['img']}",
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                                title:
                                    "${data[index]['title']} (x ${data[index]['qty']})"
                                        .text
                                        .fontFamily(regular)
                                        .size(16)
                                        .make(),
                                subtitle: "${data[index]['tprice']}"
                                    .numCurrency
                                    .text
                                    .color(primaryApp)
                                    .fontFamily(regular)
                                    .make(),
                                trailing:
                                    const Icon(Icons.delete, color: primaryApp)
                                        .onTap(() {
                                  FirestoreServices.deleteDocument(
                                      data[index].id);
                                }),
                              );
                            })),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "Total price"
                            .text
                            .fontFamily(regular)
                            .color(fontGreyDark)
                            .make(),
                        Obx(
                          () => "${controller.totalP.value}"
                              .numCurrency
                              .text
                              .fontFamily(regular)
                              .color(fontBlack)
                              .make(),
                        ),
                      ],
                    )
                        .box
                        .padding(const EdgeInsets.all(12))
                        .color(fontGrey)
                        .width(context.screenWidth - 60)
                        .roundedSM
                        .make(),
                    10.heightBox,
                    // SizedBox(
                    //   width: context.screenWidth - 60,
                    //   child: ourButton(
                    //       color: primaryApp,
                    //       onPress: () {},
                    //       textColor: whiteColor,
                    //       title: "Proceed to shipping"),
                    // )
                  ],
                ),
              );
            }
          },
        ));
  }
}
