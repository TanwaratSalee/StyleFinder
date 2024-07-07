import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:flutter_finalproject/Views/store_screen/store_screen.dart';
import 'package:flutter_finalproject/Views/widgets_common/infosituation.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/product_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MatchStoreDetailScreen extends StatefulWidget {
  final String documentId;

  const MatchStoreDetailScreen({
    required this.documentId,
  });

  @override
  _MatchStoreDetailScreenState createState() => _MatchStoreDetailScreenState();
}

class _MatchStoreDetailScreenState extends State<MatchStoreDetailScreen> {
  bool isFavorited = false;
  late final ProductController controller;
  Map<String, dynamic>? docData;
  String nameTop = '';
  String nameLower = '';
  String priceTop = '';
  String priceLower = '';
  String imageTop = '';
  String imageLower = '';
  String totalPrice = '';
  String vendorName = '';
  String vendorIdTop = '';
  String vendorIdLower = '';
  List<dynamic> collection = [];
  List<dynamic> situations = [];
  String description = '';
  String gender = '';

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProductController());
    fetchDocumentData();
  }

  final Map<String, String> situationMap = {
    'formal': 'Formal Attire',
    'semi-formal': 'Semi-Formal Attire',
    'casual': 'Casual Attire',
    'seasonal': 'Seasonal Attire',
    'special-activity': 'Special Activity Attire',
    'work-from-home': 'Work from Home',
  };

  void fetchDocumentData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('storemixandmatchs')
          .doc(widget.documentId)
          .get();

      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        var productIdTop = data['product_id_top'];
        var productIdLower = data['product_id_lower'];

        // ใช้ Future.wait เพื่อโหลดข้อมูลแบบขนาน
        var productTopDoc = FirebaseFirestore.instance
            .collection('products')
            .doc(productIdTop)
            .get();

        var productLowerDoc = FirebaseFirestore.instance
            .collection('products')
            .doc(productIdLower)
            .get();

        var results = await Future.wait([productTopDoc, productLowerDoc]);

        var productTop = results[0];
        var productLower = results[1];

        if (productTop.exists && productLower.exists) {
          setState(() {
            nameTop = productTop.data()?['name'] ?? 'Unknown Product';
            imageTop = productTop.data()?['imgs']?.isNotEmpty ?? false
                ? productTop.data()!['imgs'][0]
                : '';
            priceTop = productTop.data()?['price']?.toString() ?? '0';

            nameLower = productLower.data()?['name'] ?? 'Unknown Product';
            imageLower = productLower.data()?['imgs']?.isNotEmpty ?? false
                ? productLower.data()!['imgs'][0]
                : '';
            priceLower = productLower.data()?['price']?.toString() ?? '0';

            totalPrice =
                (double.parse(priceTop) + double.parse(priceLower)).toString();

            vendorIdTop = productTop.data()?['vendor_id'] ?? '';
            vendorIdLower = productLower.data()?['vendor_id'] ?? '';

            // Fetch vendor data
            controller.fetchVendorData(vendorIdTop);

            docData = data;
            description = data['description'] ?? '';
            gender = data['gender'] ?? '';
            collection = data['collection'] ?? [];
            situations = data['situations'] ?? [];
          });

          listenToFavoriteStatus();
        }
      }
    } catch (e) {
      print('Error fetching document data: $e');
    }
  }

  void listenToFavoriteStatus() {
    FirebaseFirestore.instance
        .collection('storemixandmatchs')
        .doc(widget.documentId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        var docData = snapshot.data() as Map<String, dynamic>;
        var favoriteUserIds =
            List<String>.from(docData['favorite_userid'] ?? []);
        String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';
        bool isFav = favoriteUserIds.contains(currentUserUID);

        controller.isFav.value = isFav;
      }
    });
  }

  void navigateToItemDetails(String productName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('name', isEqualTo: productName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var productData = querySnapshot.docs.first.data();
      Get.to(() => ItemDetails(title: productName, data: productData));
    } else {
      print('Product not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text('Match Product')
            .text
            .size(26)
            .fontFamily(semiBold)
            .color(blackColor)
            .make(),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          Obx(() => IconButton(
                onPressed: () {
                  bool isFav = !controller.isFav.value;
                  if (isFav) {
                    addToFavorites();
                  } else {
                    removeFromFavorites();
                  }
                },
                icon: controller.isFav.value
                    ? Image.asset(icTapFavoriteButton, width: 23)
                    : Image.asset(icFavoriteButton, width: 23),
              ).box.padding(EdgeInsets.only(right: 10)).make()),
        ],
      ),
      body: docData == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => navigateToItemDetails(nameTop),
                                    child: Container(
                                      child: Center(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(14),
                                            topLeft: Radius.circular(14),
                                          ),
                                          child: imageTop.isNotEmpty
                                              ? Image.network(
                                                  imageTop,
                                                  height: 140,
                                                  width: 165,
                                                  fit: BoxFit.cover,
                                                )
                                              : Container(
                                                  height: 140,
                                                  width: 165,
                                                  color: greyLine,
                                                  child: Icon(Icons.image,
                                                      color: greyColor),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  5.heightBox,
                                  SizedBox(
                                    width: 135,
                                    child: Text(
                                      nameTop,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: greyDark,
                                        fontSize: 16,
                                        fontFamily: semiBold,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                  Text(
                                    "${NumberFormat('#,##0').format(double.parse(priceTop.toString()).toInt())} Bath",
                                  )
                                      .text
                                      .color(greyDark)
                                      .fontFamily(regular)
                                      .size(12)
                                      .make(),
                                ],
                              )
                                  .box
                                  .border(color: greyLine)
                                  .margin(EdgeInsets.symmetric(horizontal: 8))
                                  .rounded
                                  .make(),
                            ),
                            const SizedBox(width: 5),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: whiteColor,
                                )
                                    .box
                                    .color(primaryApp)
                                    .roundedFull
                                    .padding(EdgeInsets.all(4))
                                    .make(),
                              ],
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        navigateToItemDetails(nameLower),
                                    child: Container(
                                      child: Center(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(14),
                                            topLeft: Radius.circular(14),
                                          ),
                                          child: imageLower.isNotEmpty
                                              ? Image.network(
                                                  imageLower,
                                                  height: 140,
                                                  width: 165,
                                                  fit: BoxFit.cover,
                                                )
                                              : Container(
                                                  height: 140,
                                                  width: 165,
                                                  color: greyLine,
                                                  child: Icon(Icons.image,
                                                      color: greyColor),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  5.heightBox,
                                  SizedBox(
                                    width: 135,
                                    child: Text(
                                      nameLower,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: greyDark,
                                        fontSize: 16,
                                        fontFamily: semiBold,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                  Text(
                                    "${NumberFormat('#,##0').format(double.parse(priceLower.toString()).toInt())} Bath",
                                  )
                                      .text
                                      .color(greyDark)
                                      .fontFamily(regular)
                                      .size(12)
                                      .make(),
                                ],
                              )
                                  .box
                                  .border(color: greyLine)
                                  .margin(EdgeInsets.symmetric(horizontal: 8))
                                  .rounded
                                  .make(),
                            ),
                          ],
                        )
                            .box
                            .margin(EdgeInsets.symmetric(horizontal: 8))
                            .make(),
                        30.heightBox,
                        Container(
                          width: double.infinity,
                          height: 70,
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    SizedBox(width: 12),
                                    Obx(() {
                                      String imageUrl =
                                          controller.vendorImageUrl.value;
                                      return imageUrl.isNotEmpty
                                          ? Container(
                                              width: 50,
                                              height: 50,
                                              child: ClipOval(
                                                child: Image.network(
                                                  imageUrl,
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                              .box
                                              .border(
                                                  color: greyLine, width: 1.5)
                                              .roundedFull
                                              .make()
                                          : Icon(
                                              Icons.person,
                                              color: whiteColor,
                                              size: 27,
                                            );
                                    }),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Obx(() {
                                          return controller
                                                  .vendorName.isNotEmpty
                                              ? controller.vendorName.value
                                                  .toUpperCase()
                                                  .text
                                                  .fontFamily(medium)
                                                  .color(blackColor)
                                                  .size(18)
                                                  .make()
                                              : Container();
                                        }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => StoreScreen(
                                        vendorId: vendorIdTop,
                                        title: controller.vendorName.value),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 12),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: primaryApp,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'See Store',
                                    style: TextStyle(
                                        color: whiteColor, fontFamily: regular),
                                  ),
                                ),
                              ),
                            ],
                          )
                              .box
                              .white
                              .roundedSM
                              .outerShadow
                              .margin(EdgeInsets.symmetric(horizontal: 12))
                              .make(),
                        ),
                        20.heightBox,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Suitable for gender',
                                  ).text.fontFamily(medium).size(14).make(),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 40,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 1,
                                      itemBuilder: (context, index) {
                                        String item = gender.toString();
                                        return Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "${item[0].toUpperCase()}${item.substring(1)}",
                                          )
                                              .text
                                              .size(16)
                                              .color(greyDark)
                                              .fontFamily(medium)
                                              .make(),
                                        )
                                            .box
                                            .color(thinPrimaryApp)
                                            .margin(EdgeInsets.symmetric(
                                                horizontal: 6))
                                            .roundedLg
                                            .padding(EdgeInsets.symmetric(
                                                horizontal: 24, vertical: 12))
                                            .make();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              10.heightBox,
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text(
                                      "Suitable for work and situations",
                                    ).text.fontFamily(medium).size(14).make(),
                                    10.widthBox,
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return SituationsList();
                                          },
                                        );
                                      },
                                      child: Image.asset(
                                        icInfo,
                                        width: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Container(
                                    height: 40,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: situations.length,
                                      itemBuilder: (context, index) {
                                        String key =
                                            situations[index].toString();
                                        String item = situationMap[key] ?? key;

                                        return Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "${item[0].toUpperCase()}${item.substring(1)}",
                                          )
                                              .text
                                              .size(14)
                                              .color(greyDark)
                                              .fontFamily(medium)
                                              .make(),
                                        )
                                            .box
                                            .color(thinPrimaryApp)
                                            .margin(const EdgeInsets.symmetric(
                                                horizontal: 6))
                                            .roundedLg
                                            .padding(const EdgeInsets.symmetric(
                                                horizontal: 24, vertical: 12))
                                            .make();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              10.heightBox,
                              Text(
                                'Opportunity suitable for',
                              ).text.fontFamily(regular).size(16).make(),
                              Column(
                                children: [
                                  SizedBox(height: 10),
                                  Container(
                                    height: 40,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: collection.length,
                                      itemBuilder: (context, index) {
                                        String item =
                                            collection[index].toString();
                                        return Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "${item[0].toUpperCase()}${item.substring(1)}",
                                          )
                                              .text
                                              .size(16)
                                              .color(greyDark)
                                              .fontFamily(medium)
                                              .make(),
                                        )
                                            .box
                                            .color(thinPrimaryApp)
                                            .margin(EdgeInsets.symmetric(
                                                horizontal: 6))
                                            .roundedLg
                                            .padding(EdgeInsets.symmetric(
                                                horizontal: 24, vertical: 12))
                                            .make();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              10.heightBox,
                              Text(
                                'The reason for match',
                                style: TextStyle(
                                  fontFamily: regular,
                                  fontSize: 16,
                                ),
                              ),
                              8.heightBox,
                              Container(
                                  width: double.infinity,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: greyThin,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Text(
                                      description,
                                      style: TextStyle(
                                        color: blackColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void updateFavoriteCount() async {
    await FirebaseFirestore.instance
        .collection('storemixandmatchs')
        .doc(widget.documentId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var doc = documentSnapshot.data() as Map<String, dynamic>;
        List<dynamic> favoriteUsers = doc['favorite_userid'];
        int favoriteCount = favoriteUsers.length;

        FirebaseFirestore.instance
            .collection('storemixandmatchs')
            .doc(widget.documentId)
            .update({
          'favorite_count': favoriteCount,
        }).then((_) {
          print('Favorite count updated successfully.');
        }).catchError((error) {
          print('Error updating favorite count: $error');
        });
      } else {
        print('Document not found for updating favorite count');
      }
    }).catchError((error) {
      print('Error fetching document for updating favorite count: $error');
    });
  }

  void addToFavorites() async {
    String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';
    print('Current User ID: $currentUserUID');
    await FirebaseFirestore.instance
        .collection('storemixandmatchs')
        .doc(widget.documentId)
        .update({
      'favorite_userid': FieldValue.arrayUnion([currentUserUID])
    }).then((_) {
      VxToast.show(context, msg: "Match updated successfully.");
      print('Match updated successfully.');
      updateFavoriteCount();
    }).catchError((error) {
      print('Error adding to favorites: $error');
    });
  }

  void removeFromFavorites() async {
    String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';
    print('Current User ID: $currentUserUID');
    await FirebaseFirestore.instance
        .collection('storemixandmatchs')
        .doc(widget.documentId)
        .update({
      'favorite_userid': FieldValue.arrayRemove([currentUserUID])
    }).then((_) {
      VxToast.show(context, msg: "Removed from favorites successfully.");
      print('Removed from favorites successfully.');
      updateFavoriteCount();
    }).catchError((error) {
      print('Error removing from favorites: $error');
    });
  }
}
