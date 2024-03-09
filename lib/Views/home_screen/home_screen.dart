// ignore_for_file: unnecessary_import, library_private_types_in_public_api, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Product {
  final String id;
  final String price;
  final String name;
  final String aboutP;
  final List<String> imageUrls;
  final dynamic wishlist;

  Product(
      {required this.id,
      required this.name,
      required this.aboutP,
      required this.price,
      required this.imageUrls,
      required this.wishlist});

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    List<String> imageUrls = List<String>.from(data['p_imgs'] ?? []);
    return Product(
      id: doc.id,
      name: data['p_name'] ?? '',
      aboutP: data['p_aboutProduct'] ?? '',
      price: data['p_price'] ?? '',
      imageUrls: imageUrls,
      wishlist: data['p_wishlist'] ?? false,
    );
  }
}

Future<List<Product>> fetchProducts() async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('products').get();

  return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGround,
      body: Padding(
        padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
        child: FutureBuilder<List<Product>>(
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

            List<Product> products = snapshot.data!;
            return CardSwiper(
              scale: 0.5,
              isLoop: true,
              cardsCount: products.length,
              cardBuilder: (BuildContext context, int index,
                  int percentThresholdX, int percentThresholdY) {
                Product product = products[index];
                return Column(
                  children: [
                    Container(
                      width: 450,
                      height: 505,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 15,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Image.network(
                            product.imageUrls.isNotEmpty
                                ? product.imageUrls[0]
                                : 'URL_ของรูปภาพ_placeholder',
                            height: 400,
                            width: 360,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              // ใส่ Container สำหรับข้อความ
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: whiteColor,
                                // borderRadius: BorderRadius.only(
                                //   bottomLeft: Radius.circular(10),
                                //   bottomRight: Radius.circular(10),
                                // ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontFamily: bold,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                  Text(
                                    'Price: ${product.aboutP} Bath',
                                    style: const TextStyle(
                                      color: fontGrey,
                                      fontFamily: light,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    NumberFormat('#,##0.00').format(double.parse(product.price)) + ' Bath',
                                    style: const TextStyle(
                                      color: fontGreyDark,
                                      fontFamily: semibold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Image.asset(
                            icDislikeButton,
                            width: 67,
                          ),
                          onPressed: () {
                            // ระบบสำหรับการคลิก Dislike
                          },
                        ),
                        IconButton(
                          icon: Image.asset(
                            icViewMoreButton,
                            width: 67,
                          ),
                          onPressed: () {
                            // ระบบสำหรับการคลิก Like
                          },
                        ),
                        IconButton(
                          icon: Image.asset(
                            icLikeButton,
                            width: 67,
                          ),
                          onPressed: () {
                            // ระบบสำหรับการคลิก View More
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
