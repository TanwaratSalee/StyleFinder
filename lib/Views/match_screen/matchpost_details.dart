import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/match_screen/edit_matchpost.dart';
import 'package:flutter_finalproject/Views/profile_screen/userprofile_screen.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:flutter_finalproject/Views/widgets_common/infosituation.dart';
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
  final List<dynamic> situations;
  final String description;
  final String gender;
  final String user_id;

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
    required this.situations,
    required this.description,
    required this.gender,
    required this.user_id,
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
    fetchUserDetails();
  }

  void fetchUserDetails() async {
    await controller.fetchUserSkinTone();
    await controller.fetchUserBirthday();
  }

  Widget buildMatchReasonSection(
    Map<String, dynamic> matchResult,
    int? skinTone,
  ) {
    final int? topPrimaryColor = matchResult['topClosestColor'];
    final int? lowerPrimaryColor = matchResult['lowerClosestColor'];

    if (topPrimaryColor == null || lowerPrimaryColor == null) {
      return Text('Unknown colors selected', style: TextStyle(fontSize: 14));
    }

    final String topColorName = topPrimaryColor != null
        ? controller.getColorName(topPrimaryColor)
        : 'Unknown';
    final String lowerColorName = lowerPrimaryColor != null
        ? controller.getColorName(lowerPrimaryColor)
        : 'Unknown';

    final topMatchesSkinTone = topPrimaryColor != null && skinTone != null
        ? controller.isColorMatchingSkinTone(topPrimaryColor, skinTone)
        : false;
    final lowerMatchesSkinTone = lowerPrimaryColor != null && skinTone != null
        ? controller.isColorMatchingSkinTone(lowerPrimaryColor, skinTone)
        : false;
    final isColorsMatch = topPrimaryColor != null && lowerPrimaryColor != null
        ? controller.colorMatchMap[topPrimaryColor]
                ?.contains(lowerPrimaryColor) ==
            true
        : false;

    Map<int, String> recommendedColors =
        controller.getRecommendedColors(controller.dayOfWeek.value);
    Map<int, String> nonMatchingColors =
        controller.getNonMatchingColors(controller.dayOfWeek.value);

    final topIsRecommended = recommendedColors.containsKey(topPrimaryColor);
    final lowerIsRecommended = recommendedColors.containsKey(lowerPrimaryColor);
    final topIsNonMatching = nonMatchingColors.containsKey(topPrimaryColor);
    final lowerIsNonMatching = nonMatchingColors.containsKey(lowerPrimaryColor);

    List<Map<String, dynamic>> matchReasons = [
      {
        'text': 'Your Skin Tone',
        'match': topMatchesSkinTone && lowerMatchesSkinTone,
      },
      {
        'text': 'Enhance your birthday',
        'match': !topIsNonMatching && !lowerIsNonMatching,
      },
      {
        'text': 'The color of the top and bottoms match',
        'match': isColorsMatch,
      }
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: matchReasons.map((reason) {
        return Row(
          children: [
            Icon(
              reason['match'] ? Icons.check : Icons.close,
              color: reason['match'] ? greenColor : redColor,
            ),
            SizedBox(width: 3),
            Text(reason['text']).text.fontFamily(regular).size(12).make(),
          ],
        );
      }).toList(),
    );
  }

  void showMatchReasonModalMatchPost(
      BuildContext context, Map<String, dynamic> matchResult, int? skinTone) {
    final int? topPrimaryColor = matchResult['topClosestColor'];
    final int? lowerPrimaryColor = matchResult['lowerClosestColor'];

    final String topColorName = topPrimaryColor != null
        ? controller.getColorName(topPrimaryColor)
        : 'Unknown';
    final String lowerColorName = lowerPrimaryColor != null
        ? controller.getColorName(lowerPrimaryColor)
        : 'Unknown';

    print('Top Colors: $topPrimaryColor');
    print('Lower Colors: $lowerPrimaryColor');

    int nonMatchingConditions = 0;
    List<Widget> reasonWidgets = [];
    List<Widget> colorReasonsWidgets = [];
    bool dayOfWeekTextAdded = false;
    final String additionalReason =
        (topPrimaryColor != null && lowerPrimaryColor != null)
            ? controller.getAdditionalReason(topPrimaryColor, lowerPrimaryColor)
            : '';

    Map<int, String> recommendedColors =
        controller.getRecommendedColors(controller.dayOfWeek.value);
    Map<int, String> nonMatchingColors =
        controller.getNonMatchingColors(controller.dayOfWeek.value);

    if (topPrimaryColor == null || lowerPrimaryColor == null) {
      reasonWidgets
          .add(Text('Unknown colors selected', style: TextStyle(fontSize: 14)));
      nonMatchingConditions++;
    } else {
      if (controller.colorMatchMap[topPrimaryColor]
              ?.contains(lowerPrimaryColor) !=
          true) {
        nonMatchingConditions++;
      }

      final topMatchesSkinTone =
          controller.isColorMatchingSkinTone(topPrimaryColor, skinTone);
      final lowerMatchesSkinTone =
          controller.isColorMatchingSkinTone(lowerPrimaryColor, skinTone);

      reasonWidgets.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              topMatchesSkinTone ? Icons.check : Icons.close,
              size: 20,
              color: topMatchesSkinTone ? greenColor : redColor,
            ),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                '${topColorName} ${topMatchesSkinTone ? "suits" : "does not suit"} your skin tone.',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      );

      if (!topMatchesSkinTone) {
        nonMatchingConditions++;
      }

      reasonWidgets.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              lowerMatchesSkinTone ? Icons.check : Icons.close,
              size: 20,
              color: lowerMatchesSkinTone ? greenColor : redColor,
            ),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                '${lowerColorName} ${lowerMatchesSkinTone ? "suits" : "does not suit"} your skin tone.',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      );

      if (!lowerMatchesSkinTone) {
        nonMatchingConditions++;
      }

      if (recommendedColors.containsKey(topPrimaryColor)) {
        if (!dayOfWeekTextAdded) {
          colorReasonsWidgets.add(
            Row(
              children: [
                Text(
                  'You were born on :',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: medium,
                  ),
                ),
                Text(
                  ' ${controller.dayOfWeek.value}',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: regular,
                  ),
                ),
              ],
            ),
          );
          dayOfWeekTextAdded = true;
        }
        colorReasonsWidgets.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check,
                size: 20,
                color: greenColor,
              ),
              SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The top color is: ',
                    style: TextStyle(fontSize: 14, fontFamily: regular),
                  ),
                  SizedBox(
                    width: 200,
                    child: Text(
                      recommendedColors[topPrimaryColor]!,
                      style: TextStyle(fontSize: 14, fontFamily: regular),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      }

      if (recommendedColors.containsKey(lowerPrimaryColor)) {
        if (!dayOfWeekTextAdded) {
          colorReasonsWidgets.add(
            Text(
              'You were born on : ${controller.dayOfWeek.value}',
              style: TextStyle(fontSize: 14, fontFamily: bold),
            ),
          );
          dayOfWeekTextAdded = true;
        }
        colorReasonsWidgets.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check,
                size: 20,
                color: greenColor,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The lower color is: ',
                    style: TextStyle(fontSize: 14, fontFamily: regular),
                  ),
                  SizedBox(width: 5),
                  SizedBox(
                    width: 200,
                    child: Text(
                      recommendedColors[lowerPrimaryColor]!,
                      style: TextStyle(fontSize: 14, fontFamily: regular),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      }

      if (nonMatchingColors.containsKey(topPrimaryColor) ||
          nonMatchingColors.containsKey(lowerPrimaryColor)) {
        if (!dayOfWeekTextAdded) {
          colorReasonsWidgets.add(
            Row(
              children: [
                Text(
                  'You were born on :',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: bold,
                  ),
                ),
                Text(
                  ' ${controller.dayOfWeek.value}',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: regular,
                  ),
                ),
              ],
            ),
          );
          dayOfWeekTextAdded = true;
        }
      }

      if (nonMatchingColors.containsKey(topPrimaryColor)) {
        colorReasonsWidgets.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.close,
                size: 20,
                color: redColor,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The top color is: ',
                    style: TextStyle(fontSize: 14, fontFamily: regular),
                  ),
                  SizedBox(width: 5),
                  SizedBox(
                    width: 200,
                    child: Text(
                      nonMatchingColors[topPrimaryColor]!,
                      style: TextStyle(fontSize: 14, fontFamily: regular),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
        nonMatchingConditions++;
      }

      if (nonMatchingColors.containsKey(lowerPrimaryColor)) {
        colorReasonsWidgets.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.close,
                size: 20,
                color: redColor,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The lower color is: ',
                    style: TextStyle(fontSize: 14, fontFamily: regular),
                  ),
                  SizedBox(width: 5),
                  SizedBox(
                    width: 200,
                    child: Text(
                      nonMatchingColors[lowerPrimaryColor]!,
                      style: TextStyle(fontSize: 14, fontFamily: regular),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
        nonMatchingConditions++;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: whiteColor,
          contentPadding: EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    nonMatchingConditions == 0
                        ? 'Perfect Match!'
                        : '$nonMatchingConditions Conditions Not Matching',
                    style: TextStyle(
                      color: nonMatchingConditions == 0 ? greenColor : redColor,
                      fontSize: 24,
                      fontFamily: bold,
                    ),
                  ),
                ),
                Divider(
                  color: greyLine,
                ),
                buildReasonSection(
                  '',
                  Icons.person,
                  [
                    Row(
                      children: [
                        Text(
                          'Your skin tone :',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: medium,
                          ),
                        ),
                        Text(
                          ' ${controller.getSkinToneDescription(skinTone!)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: regular,
                          ),
                        ),
                      ],
                    ),
                    ...reasonWidgets,
                  ],
                ),
                if (colorReasonsWidgets.isNotEmpty)
                  buildReasonSection(
                    '',
                    Icons.calendar_today,
                    colorReasonsWidgets,
                  ),
                SizedBox(height: 15),
                buildReasonSection(
                  'The color of the top and bottoms match',
                  Icons.color_lens,
                  [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          controller.colorMatchMap[topPrimaryColor]
                                      ?.contains(lowerPrimaryColor) ==
                                  true
                              ? Icons.check
                              : Icons.close,
                          size: 20,
                          color: controller.colorMatchMap[topPrimaryColor]
                                      ?.contains(lowerPrimaryColor) ==
                                  true
                              ? greenColor
                              : redColor,
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            '${topColorName} ${controller.colorMatchMap[topPrimaryColor]?.contains(lowerPrimaryColor) == true ? "matches" : "does not match"} with ${lowerColorName}.',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (additionalReason.isNotEmpty) ...[
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.info, size: 20, color: primaryApp),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          additionalReason,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildReasonSection(
      String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            /* Icon(icon, size: 24, color: primaryApp), */
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontFamily: medium,
              ),
            ),
          ],
        ),
        ...children,
      ],
    );
  }

  Widget buildSkinToneRow(int? skinTone, List<Widget> reasonWidgets,
      List<Widget> colorReasonsWidgets) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Your Skin Tone : ',
              style: const TextStyle(
                fontSize: 16,
                fontFamily: medium,
              ),
            ),
            Text(
              skinTone == null
                  ? 'Error'
                  : '${controller.getSkinToneDescription(skinTone)}',
              style: const TextStyle(
                fontSize: 14,
                fontFamily: regular,
              ),
            ),
          ],
        ),
        ...reasonWidgets,
        if (colorReasonsWidgets.isNotEmpty) ...[
          ...colorReasonsWidgets.map((widget) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: widget,
              )),
        ],
      ],
    );
  }

  void checkIsInWishlist() async {
    String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';

    FirebaseFirestore.instance
        .collection('usermixandmatch')
        .doc(widget.docId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var doc = documentSnapshot.data() as Map<String, dynamic>;
        List<dynamic> wishlist = doc['favorite_userid'];
        if (wishlist.contains(currentUserUID)) {
          controller.isFav(true);
        } else {
          controller.isFav(false);
        }
      } else {
        controller.isFav(false);
        print('Document not found for checking wishlist status');
      }
    }).catchError((error) {
      controller.isFav(false);
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
    if (widget.user_id.isNotEmpty) {
      // ใช้ user_id แทน
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(widget.user_id) // ใช้ user_id แทน
          .get();

      if (userSnapshot.exists) {
        var userData = userSnapshot.data() as Map<String, dynamic>;
        setState(() {
          postedUserName = userData['name'];
          postedUserImageUrl = userData['imageUrl'];
        });
      }
    } else {
      print("user_id is empty or null");
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
    Get.to(() => EditMatchProduct(document: widget));
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

  Map<String, String> situationNames = {
    'formal': 'Formal Attire',
    'semi-formal': 'Semi-Formal Attire',
    'casual': 'Casual Attire',
    'special-activity': 'Activity Attire',
    'seasonal': 'Seasonal Attire',
    'work-from-home': 'Work from Home',
  };

  @override
  Widget build(BuildContext context) {
    bool isCurrentUser =
        widget.user_id == FirebaseAuth.instance.currentUser?.uid;

    Future<Map<String, dynamic>> getMatchResult() async {
      List<int> topColors = await controller.getColorFromProduct(
          widget.productName1); // ดึงสีจาก product_name_top
      List<int> lowerColors = await controller.getColorFromProduct(
          widget.productName2); // ดึงสีจาก product_name_lower

      // พิมพ์สีที่ได้
      print('Top Colors: $topColors');
      print('Lower Colors: $lowerColors');

      return {
        'topClosestColor': topColors.isNotEmpty ? topColors[0] : null,
        'lowerClosestColor': lowerColors.isNotEmpty ? lowerColors[0] : null,
      };
    }

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
                                  maxLines: null,
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
                                  maxLines: null,
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
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: postedUserImageUrl!.isNotEmpty
                                            ? Image.network(
                                                postedUserImageUrl!,
                                                width: 110,
                                                height: 110,
                                                fit: BoxFit.cover,
                                              )
                                            : loadingIndicator()),
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
                              navigateToUserProfile(widget.user_id);
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
                      )
                          .box
                          .white
                          .roundedSM
                          .border(color: greyLine)
                          .outerShadowSm
                          .make(),
                    ),
                    20.heightBox,
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Your match with this outfit',
                              ).text.fontFamily(medium).size(14).make(),
                            ),
                            GestureDetector(
                              onTap: () async {
                                final matchResult = await getMatchResult();
                                final skinTone = controller.userSkinTone.value;
                                showMatchReasonModalMatchPost(
                                    context, matchResult, skinTone);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('See All')
                                      .text
                                      .fontFamily(medium)
                                      .size(14)
                                      .color(blackColor)
                                      .make(),
                                  5.widthBox,
                                  Image.asset(
                                    icSeeAll,
                                    width: 10,
                                  )
                                ],
                              ).marginOnly(right: 15),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () async {
                            final matchResult = await getMatchResult();
                            final skinTone = controller.userSkinTone.value;
                            showMatchReasonModalMatchPost(
                                context, matchResult, skinTone);
                          },
                          child: FutureBuilder<Map<String, dynamic>>(
                            future: getMatchResult(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                final matchResult = snapshot.data ?? {};
                                final skinTone = controller.userSkinTone.value;
                                return buildMatchReasonSection(
                                    matchResult, skinTone);
                              }
                            },
                          ),
                        )
                            .box
                            .color(thinPrimaryApp)
                            .roundedLg
                            .padding(EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12))
                            .make(),
                        15.heightBox,
                        Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Suitable for gender',
                          ).text.fontFamily(medium).size(14).make(),
                        ),
                        Column(
                          children: [
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
                        15.heightBox,
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
                            Container(
                              height: 40,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.situations.length,
                                itemBuilder: (context, index) {
                                  String item =
                                      widget.situations[index].toString();
                                  String fullName =
                                      situationNames[item] ?? item;
                                  return Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      fullName,
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
                        15.heightBox,
                        Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Suitable for seasons',
                          ).text.fontFamily(medium).size(14).make(),
                        ),
                        Column(
                          children: [
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
                        15.heightBox,
                        Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'The reason for match',
                          ).text.fontFamily(medium).size(14).make(),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: greyMessage,
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
                        ),
                        50.heightBox
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

  void updateFavoriteCount() async {
    await FirebaseFirestore.instance
        .collection('usermixandmatch')
        .doc(widget.docId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var doc = documentSnapshot.data() as Map<String, dynamic>;
        List<dynamic> favoriteUsers = doc['favorite_userid'];
        int favoriteCount = favoriteUsers.length;

        FirebaseFirestore.instance
            .collection('usermixandmatch')
            .doc(widget.docId)
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
    await FirebaseFirestore.instance
        .collection('usermixandmatch')
        .doc(widget.docId)
        .update({
      'favorite_userid': FieldValue.arrayUnion([currentUserUID])
    }).then((_) {
      updateIsFav(true);
      updateFavoriteCount(); // เรียกฟังก์ชันนี้หลังจากเพิ่มผู้ใช้ใน favorite
    }).catchError((error) {
      print('Error adding to favorites: $error');
    });
  }

  void removeFromFavorites() async {
    String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';
    await FirebaseFirestore.instance
        .collection('usermixandmatch')
        .doc(widget.docId)
        .update({
      'favorite_userid': FieldValue.arrayRemove([currentUserUID])
    }).then((_) {
      updateIsFav(false);
      updateFavoriteCount(); // เรียกฟังก์ชันนี้หลังจากเอาผู้ใช้ออกจาก favorite
    }).catchError((error) {
      print('Error removing from favorites: $error');
    });
  }
}
