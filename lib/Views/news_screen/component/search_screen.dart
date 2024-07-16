// ignore_for_file: use_super_parameters

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FirestoreServices {
  static Future<List<Map<String, dynamic>>> getFeaturedProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection(productsCollection).get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error fetching featured products: $e");
      return [];
    }
  }
}

class SearchScreen extends StatelessWidget {
  final String? title;
  const SearchScreen({Key? key, required this.title}) : super(key: key);

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    return FirestoreServices.getFeaturedProducts();
  }

  List<Widget> buildGridView(List<Map<String, dynamic>> filtered) {
    return filtered.map((currentValue) {
      if (currentValue['imgs'] == null) {
        return SizedBox();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(8),
              topLeft: Radius.circular(8),
            ),
            child: Image.network(
              currentValue['imgs'][0],
              height: 200,
              width: 195,
              fit: BoxFit.cover,
            ),
          ),
          5.heightBox,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${currentValue['name']}",
                style: const TextStyle(
                  fontFamily: medium,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              "${NumberFormat('#,##0').format(double.parse(currentValue['price']).toInt())} Bath"
                  .text
                  .color(greyDark)
                  .fontFamily(regular)
                  .size(14)
                  .make(),
            ],
          )
              .box
              .padding(EdgeInsets.symmetric(horizontal: 12, vertical: 5))
              .make(),
        ],
      ).box.white.roundedSM.border(color: greyLine).make().onTap(() {
        Get.to(() => ItemDetails(
              title: currentValue['name'],
              data: currentValue,
            ));
      });
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: AutoSizeText(
          title!,
          style: TextStyle(
            fontSize: 24,
            fontFamily: medium,
            color: blackColor,
          ),
          maxLines: 1, 
          minFontSize: 10, 
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.error != null) {
            return Center(child: Text('An error occurred: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No results found'));
          }

          List<Map<String, dynamic>> filtered = snapshot.data!
              .where((element) => element['name']
                  .toString()
                  .toLowerCase()
                  .contains(title!.toLowerCase()))
              .toList();

          if (filtered.isEmpty) {
            return const Center(child: Text('No results found'));
          }

          return Padding(
            padding: const EdgeInsets.all(18),
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                mainAxisExtent: 260,
              ),
              children: buildGridView(filtered),
            ),
          );
        },
      ),
    );
  }
}
