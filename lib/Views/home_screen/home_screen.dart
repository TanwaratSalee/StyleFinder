// ignore_for_file: unnecessary_import, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_finalproject/Views/auth_screen/verifyemail_screen.dart';
import 'package:flutter_finalproject/Views/cart_screen/cart_screen.dart';
import 'package:flutter_finalproject/Views/search_screen/search_screen.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
    isEmailVerified();
    super.dispose();
  }

  Future<bool> isEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      return true;
    } else {
      Get.off(() => VerifyEmailScreen(
            email: email,
            name: '',
            password: '',
          ));
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        title: appbarField(context: context),
        elevation: 8.0,
        shadowColor: greyColor.withOpacity(0.5),
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
            productsToShow = products
                .where((product) => !isInWishlist(product, currentUser!.uid))
                .toList();

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
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                product['p_imgs'][0],
                                height: 420,
                                width: 320,
                                fit: BoxFit.cover,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['p_name'],
                                    style: const TextStyle(
                                      color: blackColor,
                                      fontSize: 20,
                                      fontFamily: bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  // ),
                                  Text(
                                    "${NumberFormat('#,##0').format(double.parse(product['p_price']).toInt())} Bath",
                                    style: const TextStyle(
                                      color: greyDark2,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ).box.padding(EdgeInsets.all(8)).make(),
                            ],
                          ).box.white.roundedLg.shadowSm.padding(EdgeInsets.all(12)).make()

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
                            width: 62,
                          ).box.roundedFull.shadowSm.make(),
                          onPressed: () =>
                              controllercard.swipe(CardSwiperDirection.left),
                        ),
                        IconButton(
                          icon: Image.asset(
                            icViewMoreButton,
                            width: 62,
                          ).box.roundedFull.shadowSm.make(),
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
                            width: 62,
                          ).box.roundedFull.shadowSm.make(),
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
