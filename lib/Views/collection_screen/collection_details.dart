// ignore_for_file: use_super_parameters

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/consts/styles.dart';
import 'package:flutter_finalproject/controllers/product_controller.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

class CollectionDetails extends StatefulWidget {
  final String? title;
  const CollectionDetails({Key? key, required this.title}) : super(key: key);

  @override
  State<CollectionDetails> createState() => _CollectionDetailsState();
}

class _CollectionDetailsState extends State<CollectionDetails> {
  @override
  void initState() {
    super.initState();
    switchCategory(widget.title);
  }

  switchCategory(title) {
    if (controller.subcat.contains(title)) {
      productMethod = FirestoreServices.getSubCollectionProducts(title);
    } else {
      productMethod = FirestoreServices.getProducts(title);
    }
  }

  var controller = Get.find<ProductController>();

  dynamic productMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title != null
            ? widget.title!.text
            .size(28)
            .fontFamily(semiBold)
            .color(blackColor)
            .make()
            : const Text('No Title').text
            .size(28)
            .fontFamily(semiBold)
            .color(blackColor)
            .make(),
      ),
      backgroundColor: whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                  controller.subcat.length,
                  (index) => "${controller.subcat[index]}"
                          .text
                          .fontFamily(regular)
                          .color(whiteColor)
                          .makeCentered()
                          .box
                          .color(primaryApp)
                          .rounded
                          .size(130, 60)
                          .margin(const EdgeInsets.symmetric(horizontal: 5))
                          .make()
                          .onTap(() {
                        switchCategory("${controller.subcat[index]}");
                        setState(() {});
                      })),
            ),
          ),
          20.heightBox,
          StreamBuilder(
              stream: productMethod,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshots) {
                if (!snapshots.hasData) {
                  return Expanded(
                    child: loadingIndicator(),
                  );
                } else if (snapshots.data!.docs.isEmpty) {
                  return Expanded(
                    child: "No products found!"
                        .text
                        .color(blackColor)
                        .makeCentered(),
                  );
                } else {
                  var data = snapshots.data!.docs;

                  return Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        mainAxisExtent: 300,
                      ),
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              data[index]['p_imgs'][0],
                              width: 190,
                              height: 210,
                              fit: BoxFit.cover,
                            ),
                            const Spacer(),
                            "${data[index]['p_name']}"
                                .text
                                .fontFamily(regular)
                                .color(blackColor)
                                .make(),
                            "${NumberFormat('#,##0').format(double.parse(data[index]['p_price']).toInt())} Bath"
                                .text
                                .color(primaryApp)
                                .fontFamily(bold)
                                .size(16)
                                .make(),
                            10.heightBox,
                          ],
                        )
                            .box
                            .white
                            .margin(const EdgeInsets.symmetric(horizontal: 6))
                            .roundedSM
                            .outerShadowSm
                            .padding(const EdgeInsets.all(12))
                            .make()
                            .onTap(() {
                          switchCategory("${controller.subcat[index]}");
                          controller.checkIfFav(data[index]);
                          Get.to(() => ItemDetails(
                              title: "${data[index]['p_name']}",
                              data: data[index]));
                        });
                      },
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }
}
