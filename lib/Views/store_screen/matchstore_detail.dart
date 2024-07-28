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
    fetchUserDetails();
  }

  void fetchUserDetails() async {
    await fetchUserSkinTone();
    await fetchUserBirthday();
  }

  var dayOfWeek = ''.obs;
  var userSkinTone = 0.obs;

  Future<void> fetchUserBirthday() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String userId = currentUser.uid;
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (userSnapshot.exists) {
          Map<String, dynamic>? userData =
              userSnapshot.data() as Map<String, dynamic>?;

          if (userData != null && userData.containsKey('birthday')) {
            String birthdayString = userData['birthday'];

            // แยกวันที่ออกจากวันในสัปดาห์
            List<String> parts = birthdayString.split(', ');
            if (parts.length == 2) {
              String dateString = parts[1];

              // แปลงวันที่เป็น DateTime
              DateTime birthday = DateFormat('dd/MM/yyyy').parse(dateString);

              String formattedDate =
                  DateFormat('dd MMMM yyyy').format(birthday);
              String day = DateFormat('EEEE').format(birthday);

              dayOfWeek.value = day; // เก็บค่า dayOfWeek ใน state

              print('User was born on: $formattedDate');
              print('Day of the week: $dayOfWeek');
            } else {
              print('Invalid birthday format for user $userId');
            }
          } else {
            print('Birthday field is missing for user $userId');
          }
        } else {
          print('User not found');
        }
      } else {
        print('No current user signed in');
      }
    } catch (e) {
      print('Error fetching user birthday: $e');
    }
  }

  Future<int?> fetchUserSkinTone() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (userDoc.exists) {
        var skinTone = userDoc.data()?['skinTone'];
        print('Fetched skinTone from Firestore: $skinTone'); // เพิ่มการพิมพ์ค่า
        userSkinTone.value = skinTone ?? 0;
        return userSkinTone.value;
      }
    }
    return null;
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

  Widget buildMatchReasonSection(
    Map<String, dynamic> matchResult,
    int? skinTone,
  ) {
    final int? topPrimaryColor = matchResult['topClosestColor'];
    final int? lowerPrimaryColor = matchResult['lowerClosestColor'];

    if (topPrimaryColor == null || lowerPrimaryColor == null) {
      return Text('Unknown colors selected', style: TextStyle(fontSize: 14));
    }

    final String topColorName =
        topPrimaryColor != null ? getColorName(topPrimaryColor) : 'Unknown';
    final String lowerColorName =
        lowerPrimaryColor != null ? getColorName(lowerPrimaryColor) : 'Unknown';

    final topMatchesSkinTone = topPrimaryColor != null && skinTone != null
        ? isColorMatchingSkinTone(topPrimaryColor, skinTone)
        : false;
    final lowerMatchesSkinTone = lowerPrimaryColor != null && skinTone != null
        ? isColorMatchingSkinTone(lowerPrimaryColor, skinTone)
        : false;
    final isColorsMatch = topPrimaryColor != null && lowerPrimaryColor != null
        ? colorMatchMap[topPrimaryColor]?.contains(lowerPrimaryColor) == true
        : false;

    Map<int, String> recommendedColors = getRecommendedColors(dayOfWeek.value);
    Map<int, String> nonMatchingColors = getNonMatchingColors(dayOfWeek.value);

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
              color: reason['match'] ? Colors.green : Colors.red,
            ),
            SizedBox(width: 8),
            Text(reason['text']).text.fontFamily(semiBold).size(12).make(),
          ],
        );
      }).toList(),
    );
  }

  void showMatchReasonModalMatchPost(
      BuildContext context, Map<String, dynamic> matchResult, int? skinTone) {
    final int? topPrimaryColor = matchResult['topClosestColor'];
    final int? lowerPrimaryColor = matchResult['lowerClosestColor'];

    final String topColorName =
        topPrimaryColor != null ? getColorName(topPrimaryColor) : 'Unknown';
    final String lowerColorName =
        lowerPrimaryColor != null ? getColorName(lowerPrimaryColor) : 'Unknown';

    print('Top Colors: $topPrimaryColor');
    print('Lower Colors: $lowerPrimaryColor');

    int nonMatchingConditions = 0;
    List<Widget> reasonWidgets = [];
    List<Widget> colorReasonsWidgets = [];
    bool dayOfWeekTextAdded = false;
    final String additionalReason =
        (topPrimaryColor != null && lowerPrimaryColor != null)
            ? getAdditionalReason(topPrimaryColor, lowerPrimaryColor)
            : '';

    Map<int, String> recommendedColors = getRecommendedColors(dayOfWeek.value);
    Map<int, String> nonMatchingColors = getNonMatchingColors(dayOfWeek.value);

    if (topPrimaryColor == null || lowerPrimaryColor == null) {
      reasonWidgets
          .add(Text('Unknown colors selected', style: TextStyle(fontSize: 14)));
      nonMatchingConditions++;
    } else {
      if (colorMatchMap[topPrimaryColor]?.contains(lowerPrimaryColor) != true) {
        nonMatchingConditions++;
      }

      final topMatchesSkinTone =
          isColorMatchingSkinTone(topPrimaryColor, skinTone);
      final lowerMatchesSkinTone =
          isColorMatchingSkinTone(lowerPrimaryColor, skinTone);

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
                  ' ${dayOfWeek.value}',
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
              'You were born on : ${dayOfWeek.value}',
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
                  ' ${dayOfWeek.value}',
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
                          ' ${getSkinToneDescription(skinTone!)}',
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
                          colorMatchMap[topPrimaryColor]
                                      ?.contains(lowerPrimaryColor) ==
                                  true
                              ? Icons.check
                              : Icons.close,
                          size: 20,
                          color: colorMatchMap[topPrimaryColor]
                                      ?.contains(lowerPrimaryColor) ==
                                  true
                              ? greenColor
                              : redColor,
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            '${topColorName} ${colorMatchMap[topPrimaryColor]?.contains(lowerPrimaryColor) == true ? "matches" : "does not match"} with ${lowerColorName}.',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (additionalReason.isNotEmpty) ...[
                  SizedBox(height: 15),
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

  Future<List<int>> getColorFromProduct(String productName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('name', isEqualTo: productName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var productDoc = querySnapshot.docs.first.data() as Map<String, dynamic>;
      List<int> colors = List<int>.from(productDoc['colors'] ?? []);

      // พิมพ์สีที่ได้จากฐานข้อมูล
      print('Colors for $productName: $colors');

      return colors;
    }

    return [];
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
                  : '${getSkinToneDescription(skinTone)}',
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

  @override
  Widget build(BuildContext context) {
    Future<Map<String, dynamic>> getMatchResult() async {
      List<int> topColors = await getColorFromProduct(nameTop);
      List<int> lowerColors = await getColorFromProduct(nameLower);

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
                              Align(
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  'Your match with this outfit',
                                ).text.fontFamily(medium).size(14).make(),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: greyMessage,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    final matchResult = await getMatchResult();
                                    final skinTone = userSkinTone.value;
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
                                        final skinTone = userSkinTone.value;
                                        return buildMatchReasonSection(
                                            matchResult, skinTone);
                                      }
                                    },
                                  ),
                                ),
                              ),
                              15.heightBox,
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
