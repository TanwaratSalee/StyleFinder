// ignore_for_file: use_super_parameters

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';
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
      return SizedBox(); // หรือ Widget ที่ต้องการให้แสดงเมื่อ p_imgs เป็น null
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          currentValue['p_imgs'][0],
          height: 210,
          width: 180,
          fit: BoxFit.cover,
        ),
        const Spacer(),
        "${currentValue['p_name']}"
            .text
            .fontFamily(regular)
            .color(greyDark2)
            .make(),
        5.heightBox,
        "${NumberFormat('#,##0').format(double.parse(currentValue['p_price']).toInt())} Bath"
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
        title: title!.text.color(greyDark2).make(),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.error != null) {
            return Center(
                child: Text('An error occurred: ${snapshot.error}'));
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
              mainAxisExtent: 300,
            ),
            children: buildGridView(filtered),
          ),
          );
        },
      ),
    );
  }
}
