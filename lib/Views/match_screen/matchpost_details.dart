import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/match_screen/edit_matchpost.dart';
import 'package:flutter_finalproject/Views/profile_screen/userprofile_screen.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/matchproduct_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MatchPostsDetails extends StatefulWidget {
  final String docId;
  final String productName1;
  final String productName2;
  final String price1;
  final String price2;
  final String productImage1;
  final String productImage2;
  final String totalPrice;
  final String vendorName1;
  final String vendorName2;
  final String vendor_id;
  final List<dynamic> collection;
  final String description;
  final String gender;
  final String posted_by;

  const MatchPostsDetails({
    required this.docId,
    required this.productName1,
    required this.productName2,
    required this.price1,
    required this.price2,
    required this.productImage1,
    required this.productImage2,
    required this.totalPrice,
    required this.vendorName1,
    required this.vendorName2,
    required this.vendor_id,
    required this.collection,
    required this.description,
    required this.gender,
    required this.posted_by,
  });

  @override
  _MatchPostsDetailsState createState() => _MatchPostsDetailsState();
}

class _MatchPostsDetailsState extends State<MatchPostsDetails> {
  late final MatchProductController controller;
  String? productImageUrl;
  String? postedUserName;
  String? postedUserImageUrl;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MatchProductController());
    checkIsInWishlist();
    incrementViewCount();
    fetchProductImage();
    fetchPostedUserDetails();
  }

  void checkIsInWishlist() async {
    String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';

    FirebaseFirestore.instance
        .collection('usermixandmatch')
        .where('name', isEqualTo: widget.productName1)
        .where('vendor_id', isEqualTo: widget.vendor_id)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        List<dynamic> wishlist = doc['favorite_userid'];
        if (wishlist.contains(currentUserUID)) {
          controller.isFav(true);
        } else {
          controller.isFav(false);
        }
      } else {
        print('Document not found for checking wishlist status');
      }
    }).catchError((error) {
      print('Error fetching document for checking wishlist status: $error');
    });
  }

  void updateIsFav(bool isFav) {
    setState(() {
      controller.isFav.value = isFav;
    });
  }

  void incrementViewCount() async {
    await FirebaseFirestore.instance
        .collection('usermixandmatch')
        .where('product_name_top', isEqualTo: widget.productName1)
        .where('product_name_lower', isEqualTo: widget.productName2)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        FirebaseFirestore.instance
            .collection('usermixandmatch')
            .doc(doc.id)
            .update({
          'views': FieldValue.increment(1),
        });
      }
    }).catchError((error) {
      print('Error incrementing view count: $error');
    });
  }

  void fetchProductImage() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('usermixandmatch')
        .where('name_top', isEqualTo: widget.productName1)
        .where('vendor_id_top', isEqualTo: widget.vendor_id)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs.first.data() as Map<String, dynamic>;
      String vendorIdTop = doc['vendor_id_top'];

      QuerySnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('vendor_id', isEqualTo: vendorIdTop)
          .limit(1)
          .get();

      if (productSnapshot.docs.isNotEmpty) {
        var productDoc =
            productSnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          productImageUrl = productDoc['imgs'][0];
        });
      }
    }
  }

  void fetchPostedUserDetails() async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(widget.posted_by)
        .get();

    if (userSnapshot.exists) {
      var userData = userSnapshot.data() as Map<String, dynamic>;
      setState(() {
        postedUserName = userData['name'];
        postedUserImageUrl = userData['imageUrl'];
      });
    }
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

  void navigateToUserProfile(String userId) {
    Get.to(() => UserProfileScreen(
          userId: userId,
          postedName: postedUserName ?? '',
          postedImg: postedUserImageUrl ?? '',
        ));
  }

  void editPost() {
    Get.to(() => EditMatchProduct(), arguments: {
      'document': widget,
    });
  }

  void removeMatch(String docId) async {
    await FirebaseFirestore.instance
        .collection('usermixandmatch')
        .doc(docId)
        .delete()
        .then((_) {
      VxToast.show(context, msg: "Post deleted successfully.");
      print('Post deleted successfully.');
      Navigator.pop(context);
    }).catchError((error) {
      VxToast.show(context, msg: "Error deleting post: $error");
      print('Error deleting post: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isCurrentUser =
        widget.posted_by == FirebaseAuth.instance.currentUser?.uid;

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
          if (isCurrentUser)
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'Edit':
                    editPost();
                    break;
                  case 'Delete':
                    removeMatch(widget.docId);
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Edit', 'Delete'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
              icon: const Icon(Icons.more_vert),
            )
          else
            Obx(() => IconButton(
                 onPressed: () {
                    print("IconButton pressed");
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
                ).box.padding(const EdgeInsets.only(right: 10)).make()),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
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
                                onTap: () =>
                                    navigateToItemDetails(widget.productName1),
                                child: Container(
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(14),
                                        topLeft: Radius.circular(14),
                                      ),
                                      child: Image.network(
                                        widget.productImage1,
                                        height: 150,
                                        width: 170,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              5.heightBox,
                              SizedBox(
                                width: 130,
                                child: Text(
                                  widget.productName1,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: greyDark,
                                    fontSize: 14,
                                    fontFamily: semiBold,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                              Text(
                                "${NumberFormat('#,##0').format(double.parse(widget.price1).toInt())} Bath",
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
                              .margin(const EdgeInsets.symmetric(horizontal: 5))
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
                                .padding(const EdgeInsets.all(4))
                                .make(),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    navigateToItemDetails(widget.productName2),
                                child: Container(
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(14),
                                        topLeft: Radius.circular(14),
                                      ),
                                      child: Image.network(
                                        widget.productImage2,
                                        height: 150,
                                        width: 170,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              5.heightBox,
                              SizedBox(
                                width: 130,
                                child: Text(
                                  widget.productName2,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: greyDark,
                                    fontSize: 14,
                                    fontFamily: semiBold,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                              Text(
                                "${NumberFormat('#,##0').format(double.parse(widget.price2).toInt())} Bath",
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
                              .margin(const EdgeInsets.symmetric(horizontal: 5))
                              .rounded
                              .make(),
                        ),
                      ],
                    ),
                    30.heightBox,
                    Container(
                      width: double.infinity,
                      height: 70,
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const SizedBox(width: 12),
                                if (postedUserImageUrl != null)
                                  Container(
                                    width: 50,
                                    height: 50,
                                    child: ClipOval(
                                      child: Image.network(
                                        postedUserImageUrl!,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                      .box
                                      .border(color: greyLine, width: 1.5)
                                      .roundedFull
                                      .make(),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      postedUserName ?? '',
                                      style: const TextStyle(
                                        fontFamily: medium,
                                        color: blackColor,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              navigateToUserProfile(widget.posted_by);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 12),
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
                      ).box.white.roundedSM.outerShadow.make(),
                    ),
                    20.heightBox,
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Suitable for gender',
                          ).text.fontFamily(regular).size(16).make(),
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            Container(
                              height: 40,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.gender.split(' ').length,
                                itemBuilder: (context, index) {
                                  String item = widget.gender.split(' ')[index];
                                  String capitalizedItem =
                                      item[0].toUpperCase() + item.substring(1);
                                  return Container(
                                    alignment: Alignment.center,
                                    child: capitalizedItem.text
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
                        Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Opportunity suitable for',
                          ).text.fontFamily(regular).size(16).make(),
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            Container(
                              height: 40,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.collection.length,
                                itemBuilder: (context, index) {
                                  String item =
                                      widget.collection[index].toString();
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
                        Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'The reason for match',
                            style: TextStyle(
                              fontFamily: regular,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: greyThin,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                widget.description,
                                style: const TextStyle(
                                  color: blackColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ).paddingSymmetric(horizontal: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addToFavorites() async {
    String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';
    await FirebaseFirestore.instance.collection('usermixandmatch').doc(widget.docId).update({
      'favorite_userid': FieldValue.arrayUnion([currentUserUID])
    }).then((_) {
      updateIsFav(true);
    }).catchError((error) {
      print('Error adding to favorites: $error');
    });
  }

  void removeFromFavorites() async {
    String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';
    await FirebaseFirestore.instance.collection('usermixandmatch').doc(widget.docId).update({
      'favorite_userid': FieldValue.arrayRemove([currentUserUID])
    }).then((_) {
      updateIsFav(false);
    }).catchError((error) {
      print('Error removing from favorites: $error');
    });
  }
}
