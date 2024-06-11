import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
                              : Image.asset(
                                  imgProfile,
                                  height: 110,
                                  width: 110,
                                  fit: BoxFit.cover,
                                )),
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
            Expanded(child: buildPostTab(userId)),
          ],
        ),
      ),
    );
  }

  Widget buildPostTab(String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('usermixandmatch')
          .where('posted_by', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        var data = snapshot.data!.docs;

        if (data.isEmpty) {
          return Center(
            child: Text("No posts available!", style: TextStyle(color: greyDark)),
          );
        }
        data.shuffle();

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 7,
              crossAxisSpacing: 7,
              mainAxisExtent: 240,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              var doc = data[index];
              var docData = doc.data() as Map<String, dynamic>;
              var topImage = docData['p_imgs_top'] ?? '';
              var lowerImage = docData['p_imgs_lower'] ?? '';
              var productNameTop = docData['p_name_top'] ?? '';
              var productNameLower = docData['p_name_lower'] ?? '';
              var priceTop = docData['p_price_top']?.toString() ?? '0';
              var priceLower = docData['p_price_lower']?.toString() ?? '0';
              var vendorId = docData['vendor_id'] ?? '';
              var collections = docData['p_collection'] != null
                  ? List<String>.from(docData['p_collection'])
                  : [];
              var description = docData['p_desc'] ?? '';
              var views = docData['views'] ?? 0;
              var gender = docData['p_sex'] ?? '';

              String totalPrice = (int.parse(docData['p_price_top']) +
                      int.parse(docData['p_price_lower']))
                  .toString();
              var posted_by = docData['posted_by'] ?? '';
              var posted_name = docData['posted_name'];
              var posted_img = docData['posted_img'];

              return GestureDetector(
                onTap: () {
                  Get.to(() => MatchPostsDetails(
                      productName1: productNameTop,
                      productName2: productNameLower,
                      price1: priceTop,
                      price2: priceLower,
                      productImage1: topImage,
                      productImage2: lowerImage,
                      totalPrice: (int.parse(priceTop) + int.parse(priceLower))
                          .toString(),
                      vendorName1: 'Vendor Name 1',
                      vendorName2: 'Vendor Name 2',
                      vendor_id: vendorId,
                      collection: collections,
                      description: description,
                      gender: gender,
                      posted_by: posted_by,
                      posted_name: posted_name,
                      posted_img: posted_img));
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          children: [
                            Text(
                              "Total: ",
                              style: TextStyle(
                                  color: blackColor,
                                  fontFamily: regular,
                                  fontSize: 14),
                            ),
                            Text(
                              "${NumberFormat('#,##0').format(double.parse(totalPrice).toInt())} ",
                              style: TextStyle(
                                  color: blackColor,
                                  fontFamily: medium,
                                  fontSize: 16),
                            ),
                            Text(
                              "Bath",
                              style: TextStyle(
                                  color: blackColor,
                                  fontFamily: regular,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                      .box
                      .border(color: greyLine)
                      .p8
                      .margin(EdgeInsets.all(2))
                      .roundedSM
                      .make(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
