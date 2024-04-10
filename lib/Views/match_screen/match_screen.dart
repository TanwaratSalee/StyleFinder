import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/auth_screen/login_screen.dart';
import 'package:flutter_finalproject/Views/widgets_common/appbar_ontop.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/consts/firebase_consts.dart';
import 'package:flutter_finalproject/consts/images.dart';
import 'package:flutter_finalproject/controllers/auth_controller.dart';
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
  int selectedCardIndex = 0; // เก็บ index ของการ์ดที่ถูกเลือก

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
        title: appbarField(context: context),
        // actions: <Widget>[
        //   Padding(
        //     padding: const EdgeInsets.only(right: 15.0),
        //     child: IconButton(
        //       icon: Image.asset(
        //         icCart,
        //         width: 21,
        //       ),
        //       onPressed: () {
        //         Get.to(() => const CartScreen());
        //       },
        //     ),
        //   ),
        // ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 75,
                ),
                buildCardSetTop(),
                SizedBox(height: 5),
                buildCardSetlower(),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    // เพิ่ม `child:` ก่อน Row เพื่อให้เป็น child ของ Container
                    mainAxisAlignment: MainAxisAlignment
                        .center, // ใช้เพื่อจัดกึ่งกลางของแถว, คุณสามารถปรับเปลี่ยนได้ตามความต้องการ
                    children: <Widget>[
                      Text(
                        'Match with you',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        icon: Image.asset(
                          icLikeButton,
                          width: 67,
                        ),
                        onPressed: () async {
                          await Get.put(AuthController())
                              .signoutMethod(context);
                          Get.offAll(() => LoginScreen());
                        },
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
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
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
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
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

  Widget buildheart() {
    return Container(
      height: 100.0, // กำหนดความสูงของ container ที่มีการ์ด
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // ให้การ์ดเลื่อนได้ในแนวนอน
        itemCount: 10, // จำนวนการ์ด
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: 100.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/product${index % 3 + 1}.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchProductstop() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('products') // แทนที่ด้วยชื่อคอลเลคชันของคุณ
        .where('p_part', isEqualTo: 'top')
        .get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> fetchProductslower() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('products') // แทนที่ด้วยชื่อคอลเลคชันของคุณ
        .where('p_part', isEqualTo: 'lower')
        .get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}
