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

  _HomeScreenState(this.data);

  // void RemoveWishlist(Map<String, dynamic> product) {
  //   FirebaseFirestore.instance
  //       .collection(productsCollection)
  //       .where('p_name', isEqualTo: product['p_name'])
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     if (querySnapshot.docs.isNotEmpty) {
  //       DocumentSnapshot doc = querySnapshot.docs.first;
  //       List<dynamic> wishlist = doc['p_wishlist'];
  //       if (!wishlist.contains(currentUser!.uid)) {
  //         doc.reference.update({
  //           'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
  //         }).then((value) {
  //           VxToast.show(context, msg: "Removed from Favorite");
  //         }).catchError((error) {
  //           print('Error adding ${product['p_name']} to Favorite: $error');
  //         });
  //       }
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // Initialize controllercard here
  }

  @override
  void dispose() {
    controllercard.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGround,
      appBar: AppBar(
          backgroundColor: whiteColor,
          leading: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: IconButton(
              icon: Image.asset(
                icSearch,
                width: 23,
              ),
              onPressed: () {
                showGeneralDialog(
                  barrierLabel: "Barrier",
                  barrierDismissible: true,
                  barrierColor: Colors.black.withOpacity(0.5),
                  transitionDuration: Duration(milliseconds: 300),
                  context: context,
                  pageBuilder: (_, __, ___) {
                    return Align(
                      alignment:
                          Alignment.topCenter, 
                      child: Container(
                        height: MediaQuery.of(context).size.height *
                            0.6, 
                        width: MediaQuery.of(context).size.width,
                        child: SearchScreenPage(), 
                        decoration: const BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(18),
                            bottomRight: Radius.circular(18),
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                      ),
                    );
                  },
                  transitionBuilder: (context, anim1, anim2, child) {
                    return SlideTransition(
                      position: Tween(begin: Offset(0, -1), end: Offset(0, 0))
                          .animate(anim1),
                      child: child,
                    );
                  },
                );
              },
            ),
          ),
          title: Center(
            child: Image.asset(icLogoOnTop, height: 40),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: IconButton(
                icon: Image.asset(
                  icCart,
                  width: 21,
                ),
                onPressed: () {
                  Get.to(() => const CartScreen());
                },
              ),
            ),
          ],
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
            return CardSwiper(
              scale: 0.5,
              isLoop: false,
              controller: controllercard,
              cardsCount: products.length,
              cardBuilder: (BuildContext context, int index,
                  int percentThresholdX, int percentThresholdY) {
                previousSwipedProduct = selectedProduct;
                selectedProduct = products[index];
                Map<String, dynamic> product = products[index];
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
                                  const SizedBox( height: 2),
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
                          onPressed: ()
                            => controllercard.swipe(CardSwiperDirection.left),
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
              onSwipe: (previousIndex, currentIndex, direction){
                if(direction==CardSwiperDirection.right){
                  controller.addToWishlist(previousSwipedProduct!);
                }
                else if(direction==CardSwiperDirection.left){
                  //
                }
                else if(direction==CardSwiperDirection.top){
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