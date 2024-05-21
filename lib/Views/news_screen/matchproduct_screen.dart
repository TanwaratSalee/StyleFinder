import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/cart_screen/cart_screen.dart';
import 'package:flutter_finalproject/Views/store_screen/mixandmatch_detail.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../consts/consts.dart';

class MatchProductScreen extends StatelessWidget {
  const MatchProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 20),
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
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            Map<String, List<DocumentSnapshot>> mixMatchMap = {};

            for (var doc in snapshot.data!.docs) {
              var data = doc.data() as Map<String, dynamic>;
              if (data['p_mixmatch'] != null) {
                String mixMatchKey = data['p_mixmatch'];
                if (!mixMatchMap.containsKey(mixMatchKey)) {
                  mixMatchMap[mixMatchKey] = [];
                }
                mixMatchMap[mixMatchKey]!.add(doc);
              }
            }

            var validPairs = mixMatchMap.entries
                .where((entry) => entry.value.length == 2)
                .toList();

            if (validPairs.isEmpty) {
              return const Text('No product');
            }

            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                mainAxisExtent: 240,
              ),
              itemCount: validPairs.length,
              itemBuilder: (BuildContext context, int index) {
                var pair = validPairs[index].value;

                var data1 = pair[0].data() as Map<String, dynamic>;
                var data2 = pair[1].data() as Map<String, dynamic>;

          String vendorName1 = data1['p_seller'];
          String vendorName2 = data2['p_seller'];

          String vendor_id = data1['vendor_id'];

          List<dynamic> collectionList = data1['p_mixmatch_collection'];
          String description = data1['p_mixmatch_desc'];
          
          String price1 = data1['p_price'].toString();
          String price2 = data2['p_price'].toString();
          String totalPrice = (int.parse(price1) + int.parse(price2)).toString();

          String productName1 = data1['p_name'];
          String productName2 = data2['p_name'];

          String productImage1 = data1['p_imgs'][0];
          String productImage2 = data2['p_imgs'][0];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MatchDetailScreen(
                    price1: price1,
                    price2: price2,
                    productName1: productName1,
                    productName2: productName2,
                    productImage1: productImage1,
                    productImage2: productImage2,
                    totalPrice: totalPrice,
                    vendorName1: vendorName1,
                    vendorName2: vendorName2,
                    vendor_id: vendor_id,
                    collection: collectionList,
                    description: description,
                  ),
                ),
              );
            },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: whiteColor,  // Ensure container background is white
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 2),
                            buildProductRow(productName1, productImage1, price1),
                            buildProductRow(productName2, productImage2, price2),
                            buildTotalPriceRow(totalPrice),
                          ],
                        )
                        .box
                        .color(whiteColor)
                        .padding(const EdgeInsets.all(12))
                        .rounded
                        .shadowSm
                        .make(),
                      ),
                    ],
                  ),
                );
              },
            ).box.margin(EdgeInsets.all(8)).make();
          },
        ),
      ),
    );
  }

  Widget buildProductRow(String productName, String productImage, String price) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            productImage,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ).text.color(greyDark).fontFamily(medium).size(16).make(),
                Text(
                  "${NumberFormat('#,##0').format(double.parse(price).toInt())} Bath",
                ).text.color(greyDark).fontFamily(regular).size(14).make(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTotalPriceRow(String totalPrice) {
    return Row(
      children: [
        const Text(
          "Price ",
        ).text.color(greyDark).fontFamily(regular).size(14).make(),
        SizedBox(width: 5),
        Text(
          "${NumberFormat('#,##0').format(double.parse(totalPrice).toInt())} ",
        ).text.color(greyDark).fontFamily(medium).size(16).make(),
        SizedBox(width: 5),
        const Text(
          "Bath",
        ).text.color(greyDark).fontFamily(regular).size(14).make(),
      ],
    );
  }
}
