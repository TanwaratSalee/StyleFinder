// ignore_for_file: unnecessary_import, library_private_types_in_public_api

import 'package:flutter_finalproject/Views/cart_screen/cart_screen.dart';
import 'package:flutter_finalproject/Views/search_screen/search_screen.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets_common/appbar_ontop.dart';

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

class HomeScreen extends StatefulWidget {
  final dynamic data;
  const HomeScreen({super.key, this.data});

  @override
  _HomeScreenState createState() => _HomeScreenState(data);
}

class _HomeScreenState extends State<HomeScreen> {
  final CardSwiperController controllercard = CardSwiperController();
  var controller = Get.put(HomeController());
  final dynamic data;
  var isFav = false.obs;
  Map<String, dynamic>? selectedProduct;
  Map<String, dynamic>? previousSwipedProduct;
  late List<Map<String, dynamic>> productsToShow;

  _HomeScreenState(this.data);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controllercard.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreylight,
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        title: appbarField(),
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
      body: Padding(
        padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
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

            List<Map<String, dynamic>> products = snapshot.data!;
            productsToShow = products.where((product) => !isInWishlist(product, currentUser!.uid)).toList();

            return CardSwiper(
              scale: 0.5,
              isLoop: false,
              controller: controllercard,
              cardsCount: productsToShow.length,
              cardBuilder: (BuildContext context, int index,
                  int percentThresholdX, int percentThresholdY) {
                previousSwipedProduct = selectedProduct;
                selectedProduct = productsToShow[index];
                Map<String, dynamic> product = productsToShow[index];
                  return Column(
                  children: [
                    Container(
                      width: 450,
                      height: 505,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: whiteColor,
                          width: 15,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: greyColor.withOpacity(0.5),
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
                            product['p_imgs'][0],
                            height: 410,
                            width: 360,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: whiteColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['p_name'],
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  // Text(
                                  //   product['p_aboutProduct'],
                                  //   style: const TextStyle(
                                  //     color: fontGrey,
                                  //     fontSize: 14,
                                  //     fontFamily: light,
                                  //   ),
                                  // ),
                                  Text(
                                    product['p_price'],
                                    style: const TextStyle(
                                      color: fontGreyDark,
                                      fontSize: 18,
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
                          onPressed: () =>
                              controllercard.swipe(CardSwiperDirection.left),
                        ),
                        IconButton(
                          icon: Image.asset(
                            icViewMoreButton,
                            width: 67,
                          ),
                          onPressed: () {
                            Get.to(() => ItemDetails(
                                  title: product['p_name'],
                                  data: product,
                                ));
                          },
                        ),
                        IconButton(
                          icon: Image.asset(
                            icLikeButton,
                            width: 67,
                          ),
                          onPressed: () => [
                            controllercard.swipe(CardSwiperDirection.right),
                            controller.addToWishlist(product),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              },
              onSwipe: (previousIndex, currentIndex, direction) {
                if (direction == CardSwiperDirection.right) {
                  controller.addToWishlist(previousSwipedProduct!);
                } else if (direction == CardSwiperDirection.left) {
                  //
                } else if (direction == CardSwiperDirection.top) {
                  Get.to(() => ItemDetails(
                        title: previousSwipedProduct!['p_name'],
                        data: previousSwipedProduct!,
                      ));
                }
                return true;
              },
            );
          },
        ),
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> fetchProducts() async {
  return FirestoreServices.getFeaturedProducts();
}

bool isInWishlist(Map<String, dynamic> product, String currentUid) {
  List<dynamic> wishlist = product['p_wishlist'];
  return wishlist.contains(currentUid);
}