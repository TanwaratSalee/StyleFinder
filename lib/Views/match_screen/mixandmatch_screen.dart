import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/auth_screen/login_screen.dart';
import 'package:flutter_finalproject/Views/widgets_common/appbar_ontop.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/consts/firebase_consts.dart';
import 'package:flutter_finalproject/consts/images.dart';
import 'package:flutter_finalproject/consts/styles.dart';
import 'package:flutter_finalproject/controllers/auth_controller.dart';
import 'package:flutter_finalproject/controllers/product_controller.dart';
import 'package:get/get.dart';

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

class MatchScreen extends StatefulWidget {
  const MatchScreen({Key? key}) : super(key: key);

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  int selectedCardIndex = 0;
  late final ProductController controller;
  List<Map<String, dynamic>> productsTop = [];
  List<Map<String, dynamic>> productsLower = [];

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProductController());
    fetchProductstop();
    fetchProductslower();

    selectedCardIndex = 0;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
        title: appbarField(context: context),
        elevation: 8.0,
        shadowColor: greyColor.withOpacity(0.5),
      ),
      body: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 50,
                ),
                buildCardSetTop(),
                const SizedBox(height: 5),
                buildCardSetlower(),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Match with you',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: bold,
                          color: blackColor,
                        ),
                      ),
                      IconButton(
                        icon: Image.asset(
                          icLikeButton,
                          width: 67,
                        ),
                        onPressed: () {
                        final productNameTop = productsTop[selectedCardIndex]['p_name'];
                        final productNameLower = productsLower[selectedCardIndex]['p_name'];
                        controller.addToWishlistMatch(productNameTop, productNameLower, context);
                        }
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget buildCardSetTop() {
  return FutureBuilder<List<Map<String, dynamic>>>(
    future: fetchProductstop(),
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
      final products = snapshot.data!;
      return Container(
        height: 250.0,
        child: PageView.builder(
          controller: PageController(viewportFraction: 0.8),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: 300.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    product['p_imgs'][0],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

  Widget buildCardSetlower() {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchProductslower(),
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
          final products = snapshot.data!;
          return Container(
            height: 250.0,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.8),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    width: 300.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        product['p_imgs'][0],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        });
  }

Future<List<Map<String, dynamic>>> fetchProductstop() async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('products')
      .where('p_part', isEqualTo: 'top')
      .get();
  return querySnapshot.docs
      .map((doc) => doc.data() as Map<String, dynamic>)
      .toList();
}

Future<List<Map<String, dynamic>>> fetchProductslower() async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('products')
      .where('p_part', isEqualTo: 'lower')
      .get();
  return querySnapshot.docs
      .map((doc) => doc.data() as Map<String, dynamic>)
      .toList();
}
}