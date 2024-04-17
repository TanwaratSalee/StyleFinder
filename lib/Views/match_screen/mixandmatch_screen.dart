import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/auth_screen/login_screen.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
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
  late final ProductController controller;
  late final PageController _pageControllerTop, _pageControllerLower;
  late int _currentPageIndexTop, _currentPageIndexLower;

  late Future<List<Map<String, dynamic>>> _topProductsFuture;
  late Future<List<Map<String, dynamic>>> _lowerProductsFuture;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProductController());
    _pageControllerTop = PageController(viewportFraction: 0.8);
    _pageControllerLower = PageController(viewportFraction: 0.8);
    _currentPageIndexTop = 0;
    _currentPageIndexLower = 0;

    _pageControllerTop.addListener(() {
      final newPageIndex = _pageControllerTop.page!.round();
      if (_currentPageIndexTop != newPageIndex) {
        setState(() {
          _currentPageIndexTop = newPageIndex;
        });
      }
    });

    _pageControllerLower.addListener(() {
      final newPageIndex = _pageControllerLower.page!.round();
      if (_currentPageIndexLower != newPageIndex) {
        setState(() {
          _currentPageIndexLower = newPageIndex;
        });
      }
    });

    _topProductsFuture = fetchProductstop();
    _lowerProductsFuture = fetchProductslower();
  }

  @override
  void dispose() {
    _pageControllerTop.dispose();
    _pageControllerLower.dispose();
    super.dispose();
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
                const SizedBox(height: 50),
                buildCardSetTop(),
                const SizedBox(height: 5),
                buildCardSetLower(),
                const SizedBox(height: 10),
                matchWithYouContainer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget matchWithYouContainer() {
    return Container(
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
            style: TextStyle(fontSize: 18, fontFamily: bold, color: blackColor),
          ),
          IconButton(
            icon: Image.asset(icLikeButton, width: 67),
            onPressed: () async {
              final topProducts = await _topProductsFuture;
              final lowerProducts = await _lowerProductsFuture;
              if (topProducts.isNotEmpty && lowerProducts.isNotEmpty) {
                final topProduct = topProducts[_currentPageIndexTop];
                final lowerProduct = lowerProducts[_currentPageIndexLower];
                controller.addToWishlistUserMatch(
                  topProduct['p_name'],
                  lowerProduct['p_name'],
                  context,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('ไม่สามารถเพิ่มไปยังรายการโปรดได้ เนื่องจากข้อมูลไม่พร้อมใช้งาน')),
                );
              }
            },
          ),
        ],
      ),
    );
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

Widget buildCardSetTop() {
  return FutureBuilder<List<Map<String, dynamic>>>(
    future: _topProductsFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (snapshot.error != null) {
        return Center(child: Text('An error occurred: ${snapshot.error}'));
      }
      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: Text('No data available'));
      }
      final topProducts = snapshot.data!;
      return Container(
        height: 250.0,
        child: PageView.builder(
          controller: _pageControllerTop,
          itemCount: topProducts.length,
          itemBuilder: (context, index) {
            final product = topProducts[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => ItemDetails(
                title: product['p_name'],
                data: product,
                ));
              },
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Container(
                  width: 300.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(product['p_imgs'][0], fit: BoxFit.cover),
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

Widget buildCardSetLower() {
  return FutureBuilder<List<Map<String, dynamic>>>(
    future: _lowerProductsFuture,
    builder: (context, snapshot) {
      // ตรวจสอบสถานะการโหลดข้อมูล
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (snapshot.error != null) {
        return Center(child: Text('An error occurred: ${snapshot.error}'));
      }
      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: Text('No data available'));
      }
      final lowerProducts = snapshot.data!;
      return Container(
        height: 250.0,
        child: PageView.builder(
          controller: _pageControllerLower,
          itemCount: lowerProducts.length,
          itemBuilder: (context, index) {
            final product = lowerProducts[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => ItemDetails(
                title: product['p_name'],
                data: product,
                ));
              },
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Container(
                  width: 300.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(product['p_imgs'][0], fit: BoxFit.cover),
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



}
