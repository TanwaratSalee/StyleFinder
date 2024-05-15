// ignore_for_file: unnecessary_import, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_finalproject/Views/auth_screen/verifyemail_screen.dart';
import 'package:flutter_finalproject/Views/cart_screen/cart_screen.dart';
import 'package:flutter_finalproject/Views/news_screen/component/search_screen.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
  String? selectedItemDetail;

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

  Future<void> navigateToItemDetails() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ItemDetails(
                title: previousSwipedProduct!['p_name'],
                data: previousSwipedProduct!,
              )),
    );
    if (result != null) {
      setState(() {
        selectedItemDetail = result;
      });
    }
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
    var screenSize = MediaQuery.of(context).size; 

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(icLogoOnTop, height: 35),
                ),
              ),
              IconButton(
                icon: Image.asset(icCart, width: 21),
                onPressed: () {
                  Get.to(() => const CartScreen());
                },
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: controller.searchController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          suffixIcon:
                              Icon(Icons.search, color: greyDark1).onTap(() {
                            if (controller.searchController.text.isNotEmpty) {
                              Get.to(() => SearchScreen(
                                    title: controller.searchController.text,
                                  ));
                            }
                          }),
                          filled: true,
                          fillColor: whiteColor,
                          hintText: 'Search',
                          hintStyle: TextStyle(color: greyColor),
                          contentPadding: EdgeInsets.symmetric(horizontal: 25),
                        ),
                      ),
                    ).box.border(color: greyColor, width: 0.5).roundedLg.make(),
                  ),
                  5.widthBox,
                  IconButton(
                    icon: Icon(
                      Icons.filter_list_rounded,
                      color: greyDark1,
                      size: 30,
                    ),
                    onPressed: () {},
                  ).box.border(color: greyColor, width: 0.5).roundedLg.make(),
                ],
              ),
            ),
            Expanded(
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
                      .where(
                          (product) => !isInWishlist(product, currentUser!.uid))
                      .toList();
                  return CardSwiper(
                    scale: 0.5,
                    isLoop: false,
                    controller: controllercard,
                    allowedSwipeDirection:
                        AllowedSwipeDirection.only(left: true, right: true),
                    cardsCount: productsToShow.length,
                    cardBuilder: (BuildContext context, int index,
                        int percentThresholdX, int percentThresholdY) {
                      previousSwipedProduct = selectedProduct;
                      selectedProduct = productsToShow[index];
                      Map<String, dynamic> product = productsToShow[index];

                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: [
                            Container(
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 1),
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(14),
                                            topLeft: Radius.circular(14)),
                                        child: Image.network(
                                          product['p_imgs'][0],
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.47,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product['p_name'],
                                            style: TextStyle(
                                              color: blackColor,
                                              fontSize: 20,
                                              fontFamily: medium,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            "${NumberFormat('#,##0').format(double.parse(product['p_price']).toInt())} Bath",
                                            style: TextStyle(
                                              color: greyDark2,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ).box.padding(EdgeInsets.all(8)).make(),
                                    ],
                                  )
                                      .box
                                      .white
                                      .roundedLg
                                      .shadowSm
                                      .padding(EdgeInsets.all(12))
                                      .make(),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  icon: Image.asset(
                                    icDislikeButton,
                                    width: 67,
                                  ).box.roundedFull.shadowSm.make(),
                                  onPressed: () => controllercard
                                      .swipe(CardSwiperDirection.left),
                                ),
                                IconButton(
                                  icon: Image.asset(
                                    icViewMoreButton,
                                    width: 67,
                                  ).box.roundedFull.shadowSm.make(),
                                  onPressed: () => navigateToItemDetails(),
                                ),
                                IconButton(
                                  icon: Image.asset(
                                    icLikeButton,
                                    width: 67,
                                  ).box.roundedFull.shadowSm.make(),
                                  onPressed: () => [
                                    controllercard
                                        .swipe(CardSwiperDirection.right),
                                    controller.addToWishlist(product),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    onSwipe: (previousIndex, currentIndex, direction) {
                      if (direction == CardSwiperDirection.right) {
                        controller.addToWishlist(previousSwipedProduct!);
                      } else if (direction == CardSwiperDirection.left) {
                      } else if (direction == CardSwiperDirection.top) {
                        navigateToItemDetails();
                      }
                      return true;
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> fetchProducts() async {
  return FirestoreServices.getFeaturedProducts();
}

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

bool isInWishlist(Map<String, dynamic> product, String currentUid) {
  List<dynamic> wishlist = product['p_wishlist'];
  return wishlist.contains(currentUid);
}
