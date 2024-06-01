import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/cart_screen/cart_screen.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/store_screen/store_screen.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class AllStoreScreen extends StatelessWidget {
  const AllStoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 20),
            Image.asset(icLogoOnTop, height: 40),
            IconButton(
              icon: Image.asset(icCart, width: 21),
              onPressed: () {
                Get.to(() => const CartScreen());
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: ListView(
          children: [
            'OFFICIAL STORE'
                .text
                .fontFamily(semiBold)
                .color(blackColor)
                .size(20)
                .make(),
            SizedBox(height: 10),
            StreamBuilder(
              stream: FirestoreServices.allmatchbystore(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: loadingIndicator(),
                  );
                } else {
                  var allproductsdata = snapshot.data!.docs;
                  var officialProducts = allproductsdata.where((doc) {
                    var productData = doc.data() as Map<String, dynamic>;
                    return productData['vendor_official'] == true;
                  }).toList();

                  if (officialProducts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 150.heightBox,
                          'Coming Soon'
                              .text
                              .fontFamily(regular)
                              .color(blackColor)
                              .size(18)
                              .make(),
                        ],
                      ),
                    );
                  } else {
                    officialProducts.shuffle(math.Random());

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1 / 1.1,
                      ),
                      itemCount: officialProducts.length,
                      itemBuilder: (context, index) {
                        var productData = officialProducts[index].data()
                            as Map<String, dynamic>;
                        return GestureDetector(
                          onTap: () {
                            var vendorId = productData['vendor_id'];
                            print(
                                "Navigating to StoreScreen with vendor_id: $vendorId");
                            Get.to(() => StoreScreen(vendorId: vendorId));
                          },
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    productData['imageUrl'],
                                    height: 80,
                                    width: 110,
                                    fit: BoxFit.cover,
                                  )
                                      .box
                                      .white
                                      .roundedSM
                                      .border(color: greyLine)
                                      .make(),
                                ),
                                3.heightBox,
                                Text(
                                  "${productData['vendor_name']}",
                                  style: const TextStyle(
                                    fontFamily: medium,
                                    fontSize: 16,
                                    color: blackColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
              },
            ),
            30.heightBox,
            'NEW STORE'
                .text
                .fontFamily(semiBold)
                .color(blackColor)
                .size(20)
                .make(),
            SizedBox(height: 10),
            StreamBuilder(
              stream: FirestoreServices.allmatchbystore(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: loadingIndicator(),
                  );
                } else {
                  var allproductsdata = snapshot.data!.docs;
                  var officialProducts = allproductsdata.where((doc) {
                    var productData = doc.data() as Map<String, dynamic>;
                    return productData['vendor_official'] == false;
                  }).toList();

                  if (officialProducts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          100.heightBox,
                          'Coming Soon'
                              .text
                              .fontFamily(regular)
                              .color(blackColor)
                              .size(18)
                              .make(),
                        ],
                      ),
                    );
                  } else {
                    officialProducts.shuffle(math.Random());

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1 / 1,
                      ),
                      itemCount: officialProducts.length,
                      itemBuilder: (context, index) {
                        var productData = officialProducts[index].data()
                            as Map<String, dynamic>;
                        return GestureDetector(
                          onTap: () {
                            var vendorId = productData['vendor_id'];
                            print(
                                "Navigating to StoreScreen with vendor_id: $vendorId");
                            Get.to(() => StoreScreen(vendorId: vendorId));
                          },
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    productData['imageUrl'],
                                    height: 80,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  )
                                      .box
                                      .white
                                      .roundedSM
                                      .border(color: greyLine)
                                      .make(),
                                ),
                                3.heightBox,
                                Text(
                                  "${productData['vendor_name']}",
                                  style: const TextStyle(
                                    fontFamily: medium,
                                    fontSize: 16,
                                    color: blackColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
