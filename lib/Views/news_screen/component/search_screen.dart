// ignore_for_file: use_super_parameters

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
      if (currentValue['p_imgs'] == null) {
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
              currentValue['p_imgs'][0],
              height: 210,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
          15.heightBox,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "${currentValue['p_name']}"
              .text
              .fontFamily(medium)
              .size(18)
              .color(greyColor3)
              .overflow(TextOverflow.ellipsis)
              .softWrap(true)
              .make(),
          "${NumberFormat('#,##0').format(double.parse(currentValue['p_price']).toInt())} Bath"
              .text
              .color(greyDark)
              .fontFamily(regular)
              .size(14)
              .make(),
            ],
          ).box.padding(EdgeInsets.symmetric(horizontal: 8)).make(),
        ],
      )
          .box
          .white
          .shadowMd
          .margin(const EdgeInsets.symmetric(horizontal: 4))
          .roundedSM
          // .padding(const EdgeInsets.all(12))
          .make()
          .onTap(() {
        Get.to(() => ItemDetails(
              title: currentValue['p_name'],
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
        title: title!.text.size(24).fontFamily(semiBold).color(greyColor3).make(),
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
            return const Center(child: Text('No data available'));
          }

          List<Map<String, dynamic>> filtered = snapshot.data!
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
                mainAxisExtent: 280,
              ),
              children: buildGridView(filtered),
            ),
          );
        },
      ),
    );
  }
}
