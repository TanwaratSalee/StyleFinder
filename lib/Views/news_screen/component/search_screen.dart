// ignore_for_file: use_super_parameters

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  final String? title;
  const SearchScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: title!.text.color(fontGreyDark).make(),
      ),
      body: FutureBuilder(
        future: FirestoreServices.searchProducts(title),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndcator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return "No product found".text.makeCentered();
          } else {
            var data = snapshot.data!.docs;
            var filtered = data
                .where((element) => element['p_name']
                    .toString()
                    .toLowerCase()
                    .contains(title!.toLowerCase()))
                .toList();

            return Padding(
              padding: const EdgeInsets.all(6.0),
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  mainAxisExtent: 300,
                ),
                children: filtered
                    .mapIndexed((currentValue, index) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              filtered[index]['p_imgs'][0],
                              height: 210,
                              width: 180,
                              fit: BoxFit.cover,
                            ),
                            const Spacer(),
                            "${filtered[index]['p_name']}"
                                .text
                                .fontFamily(regular)
                                .color(fontGreyDark)
                                .make(),
                            5.heightBox,
                            "${filtered[index]['p_price']}"
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
                            .shadowMd
                            .margin(const EdgeInsets.symmetric(horizontal: 4))
                            .roundedSM
                            .padding(const EdgeInsets.all(12))
                            .make()
                            .onTap(() {
                          Get.to(() => ItemDetails(
                                title: "${data[index]['p_name']}",
                              ));
                        }))
                    .toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
