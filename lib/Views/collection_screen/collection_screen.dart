// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/collection_screen/collection_details.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/consts/lists.dart';
import 'package:flutter_finalproject/controllers/product_controller.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());

    return Scaffold(
      appBar: AppBar(
        // title: collection.text.fontFamily(bold).black.make(),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: whiteColor,
      body: Container(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
            shrinkWrap: true,
            itemCount: 5,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, mainAxisSpacing: 8,crossAxisSpacing:8, mainAxisExtent: 200),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Image.asset(collectionImages[index],height: 183,width: 320, fit:BoxFit.fill,),
                  collectionList[index].text.size(2).color(whiteColor).align(TextAlign.center).make(),
                ],
              ).box.rounded.clip(Clip.antiAlias).color(whiteColor).outerShadowSm.make().onTap(() {
                controller.getSubCollection(collectionList[index]);
                Get.to(() => CollectionDetails(title: collectionList[index]));
              }); 
            }),
      ),
    );
  }
}
