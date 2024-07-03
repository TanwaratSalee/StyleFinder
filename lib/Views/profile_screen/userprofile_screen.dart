import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/match_screen/matchpost_details.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UserProfileScreen extends StatelessWidget {
  final String userId;
  final String postedName;
  final String postedImg;

  const UserProfileScreen({
    required this.userId,
    required this.postedName,
    required this.postedImg,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          postedName,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: blackColor,
            fontSize: 26,
            fontFamily: medium,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: postedImg.isNotEmpty
                              ? Image.network(
                                  postedImg,
                                  width: 110,
                                  height: 110,
                                  fit: BoxFit.cover,
                                )
                              : loadingIndicator()),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          Image.asset(
                            icTapPostProfile,
                            width: 22,
                            height: 22,
                            color: primaryApp,
                          ),
                          SizedBox(height: 5),
                          Divider(
                            color: primaryApp,
                            thickness: 2,
                            height: 2,
                          ).paddingSymmetric(horizontal: 175),
                        ],
                      ),
                      Divider(
                        color: greyLine,
                        thickness: 1,
                        height: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(child: buildPostTab()),
          ],
        ),
      ),
    );
  }

  Widget buildPostTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('usermixandmatch')
          .where('user_id', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        var data = snapshot.data!.docs;

        if (data.isEmpty) {
          return Center(
            child:
                Text("No posts available!", style: TextStyle(color: greyDark)),
          );
        }

        var limitedData = data.take(4).toList();

        return GridView.builder(
          padding: EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 8 / 10,
          ),
          itemCount: limitedData.length,
          itemBuilder: (context, index) {
            var doc = limitedData[index];
            var docData = doc.data() as Map<String, dynamic>;
            var productIdTop = docData['product_id_top'] ?? '';
            var productIdLower = docData['product_id_lower'] ?? '';

            return FutureBuilder<List<DocumentSnapshot>>(
              future: Future.wait([
                FirebaseFirestore.instance
                    .collection('products')
                    .doc(productIdTop)
                    .get(),
                FirebaseFirestore.instance
                    .collection('products')
                    .doc(productIdLower)
                    .get()
              ]),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(
                    child: Text(
                      "An error occurred: ${snapshot.error}",
                      style: TextStyle(color: greyDark),
                    ),
                  );
                }

                var snapshotTop = snapshot.data![0];
                var snapshotLower = snapshot.data![1];

                if (!snapshotTop.exists || !snapshotLower.exists) {
                  return Center(child: Text("One or more products not found"));
                }

                var productDataTop =
                    snapshotTop.data() as Map<String, dynamic>?;
                var productDataLower =
                    snapshotLower.data() as Map<String, dynamic>?;

                var topImage =
                    productDataTop != null && productDataTop['imgs'] != null
                        ? (productDataTop['imgs'] as List<dynamic>).first
                        : '';
                var lowerImage =
                    productDataLower != null && productDataLower['imgs'] != null
                        ? (productDataLower['imgs'] as List<dynamic>).first
                        : '';
                var productNameTop = productDataTop?['name'] ?? '';
                var productNameLower = productDataLower?['name'] ?? '';
                var priceTop = productDataTop?['price']?.toString() ?? '0';
                var priceLower = productDataLower?['price']?.toString() ?? '0';
                var collections = docData['collection'] != null
                    ? List<String>.from(docData['collection'])
                    : [];
                var siturations = docData['siturations'] != null
                    ? List<String>.from(docData['siturations'])
                    : [];
                var description = docData['description'] ?? '';
                var views = docData['views'] ?? 0;
                var gender = docData['gender'] ?? '';
                var postedBy = docData['user_id'] ?? '';

                return GestureDetector(
                  onTap: () {
                    Get.to(() => MatchPostsDetails(
                          docId: doc.id,
                          productName1: productNameTop,
                          productName2: productNameLower,
                          price1: priceTop,
                          price2: priceLower,
                          productImage1: topImage,
                          productImage2: lowerImage,
                          totalPrice:
                              (int.parse(priceTop) + int.parse(priceLower))
                                  .toString(),
                          vendorName1: 'Vendor Name 1',
                          vendorName2: 'Vendor Name 2',
                          vendor_id: doc.id,
                          collection: collections,
                          siturations: siturations,
                          description: description,
                          gender: gender,
                          posted_by: postedBy,
                        ));
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 75,
                              height: 80,
                              child: Image.network(
                                topImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    productNameTop,
                                    style: const TextStyle(
                                      fontFamily: medium,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  Text(
                                    "${NumberFormat('#,##0').format(double.parse(priceTop).toInt())} Bath",
                                    style: const TextStyle(color: greyColor),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(
                              width: 75,
                              height: 80,
                              child: Image.network(
                                lowerImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    productNameLower,
                                    style: const TextStyle(
                                      fontFamily: medium,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  Text(
                                    "${NumberFormat('#,##0').format(double.parse(priceLower).toInt())} Bath",
                                    style: const TextStyle(color: greyColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 4),
                            Text(
                              "Total ${NumberFormat('#,##0').format(int.parse(priceTop) + int.parse(priceLower))} Bath",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: medium,
                                color: blackColor,
                              ),
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 6),
                      ],
                    )
                        .box
                        .border(color: greyLine)
                        .rounded
                        .padding(EdgeInsets.all(8))
                        .make(),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
