import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_finalproject/Views/store_screen/store_screen.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/product_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MatchDetailScreen extends StatefulWidget {
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

  const MatchDetailScreen({
    this.productName1 = '',
    this.productName2 = '',
    this.price1 = '',
    this.price2 = '',
    this.productImage1 = '',
    this.productImage2 = '',
    this.totalPrice = '',
    this.vendorName1 = '',
    this.vendorName2 = '',
    this.vendor_id = '',
    required this.collection,
    this.description = '',
  });

  @override
  _MatchDetailScreenState createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  bool isFavorited = false;
  late final ProductController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProductController());
    checkIsInWishlist();
  }

  void checkIsInWishlist() async {
    String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';

    FirebaseFirestore.instance
        .collection('favoritemixmatch')
        .where('user_id', isEqualTo: currentUserUID)
        .where('vendor_id', isEqualTo: widget.vendor_id)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        bool hasBothProducts = querySnapshot.docs.any((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return data['product1']['p_name'] == widget.productName1 &&
              data['product2']['p_name'] == widget.productName2;
        });

        if (hasBothProducts) {
          controller.isFav(true);
        } else {
          controller.isFav(false);
        }
      } else {
        controller.isFav(false);
      }
    }).catchError((error) {
      print('Error checking wishlist status: $error');
    });
  }

  void _updateIsFav(bool isFav) {
    setState(() {
      controller.isFav.value = isFav;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text('Match Detail')
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
                  print("IconButton pressed");
                  bool isFav = !controller.isFav.value;
                  if (isFav == true) {
                    controller.addToWishlistMixMatch(
                        widget.productName1,
                        widget.productName2,
                        widget.vendor_id,
                        _updateIsFav,
                        context);
                  } else {
                    controller.removeToWishlistMixMatch(
                        widget.productName1,
                        widget.productName2,
                        widget.vendor_id,
                        _updateIsFav,
                        context);
                  }
                  print("isFav after toggling: $isFav");
                },
                icon: controller.isFav.value
                    ? Image.asset(icTapFavoriteButton, width: 23)
                    : Image.asset(icFavoriteButton, width: 23),
              ).box.padding(EdgeInsets.only(right: 10)).make()),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(14),
                                      topLeft: Radius.circular(14),
                                    ),
                                    child: Image.network(
                                      widget.productImage1,
                                      height: 160,
                                      width: 220,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              5.heightBox,
                              Text(
                                widget.productName1,
                                softWrap: true,
                                overflow: TextOverflow.clip,
                              )
                                  .text
                                  .color(greyDark)
                                  .fontFamily(bold)
                                  .size(16)
                                  .ellipsis
                                  .maxLines(1)
                                  .make(),
                              Text(
                                "${NumberFormat('#,##0').format(double.parse(widget.price1.toString()).toInt())} Bath",
                              )
                                  .text
                                  .color(greyDark)
                                  .fontFamily(regular)
                                  .size(14)
                                  .make(),
                            ],
                          ).box.border(color: greyLine).rounded.make(),
                        ),
                        const SizedBox(width: 10),
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
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(14),
                                      topLeft: Radius.circular(14),
                                    ),
                                    child: Image.network(
                                      widget.productImage2,
                                      height: 160,
                                      width: 220,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              5.heightBox,
                              Text(widget.productName2)
                                  .text
                                  .color(greyDark)
                                  .fontFamily(bold)
                                  .size(16)
                                  .ellipsis
                                  .maxLines(1)
                                  .make(),
                              Text(
                                "${NumberFormat('#,##0').format(double.parse(widget.price2.toString()).toInt())} Bath",
                              )
                                  .text
                                  .color(greyDark)
                                  .fontFamily(regular)
                                  .size(14)
                                  .make(),
                            ],
                          ).box.border(color: greyLine).rounded.make(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Container(
                      width: double.infinity,
                      height: 87,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: greyLine, width: 2),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 0.1,
                            blurRadius: 4,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(width: 5),
                                Obx(() {
                                  String imageUrl =
                                      controller.vendorImageUrl.value;
                                  return imageUrl.isNotEmpty
                                      ? Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: greyLine, width: 2),
                                            color: Colors.white,
                                          ),
                                          child: Image.network(
                                            imageUrl,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : SizedBox.shrink();
                                }),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      widget.vendorName1.toUpperCase(),
                                      style: TextStyle(
                                        fontFamily: 'medium',
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              Get.to(
                                () => StoreScreen(vendorId: widget.vendor_id),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                color: primaryApp,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'See Store',
                                style: TextStyle(
                                    color: whiteColor, fontFamily: 'regular'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 30, 0, 0),
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Suitable for gender',
                              style: TextStyle(
                                fontFamily: 'regular',
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(),
                            ),
                          ),
                        ],
                      ),
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
                            itemCount: widget.collection.length,
                            itemBuilder: (context, index) {
                              String item = widget.collection[index].toString();
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
                                  .margin(EdgeInsets.symmetric(horizontal: 6))
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 20, 0, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Opportunity suitable for',
                        ).text.fontFamily(regular).size(16).make(),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(height: 10),
                        Container(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.collection.length,
                            itemBuilder: (context, index) {
                              String item = widget.collection[index].toString();
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
                                  .margin(EdgeInsets.symmetric(horizontal: 6))
                                  .roundedLg
                                  .padding(EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12))
                                  .make();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'The reason for match',
                            style: TextStyle(
                              fontFamily: regular,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
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
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  widget.description,
                                  style: TextStyle(
                                    color: blackColor,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
