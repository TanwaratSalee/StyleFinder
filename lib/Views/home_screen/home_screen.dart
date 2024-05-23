import 'dart:math';
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

List<Map<String, dynamic>> getRandomizedList(
    List<Map<String, dynamic>> originalList) {
  List<Map<String, dynamic>> list = List.from(originalList); 
  list.shuffle(Random());
  return list;
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CardSwiperController controllercard = CardSwiperController();
  var controller = Get.put(HomeController());
  final dynamic data;
  var isFav = false.obs;
  Map<String, dynamic>? selectedProduct;
  Map<String, dynamic>? previousSwipedProduct;
  late List<Map<String, dynamic>> productsToShow;
  String? selectedItemDetail;
  late TextEditingController searchController;

  _HomeScreenState(this.data);

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    controllercard.dispose();
    searchController.dispose();
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
      key: _scaffoldKey,
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
                        controller: searchController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          suffixIcon:
                              Icon(Icons.search, color: greyDark).onTap(() {
                            if (searchController.text.isNotEmpty) {
                              Get.to(() => SearchScreen(
                                    title: searchController.text,
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
                  10.widthBox,
                  IconButton(
                    icon: Icon(
                      Icons.filter_list_rounded,
                      color: greyDark,
                      size: 30,
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
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
                  productsToShow = getRandomizedList(products
                      .where(
                          (product) => !isInWishlist(product, currentUser!.uid))
                      .toList());
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
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            "${NumberFormat('#,##0').format(double.parse(product['p_price']).toInt())} Bath",
                                            style: TextStyle(
                                              color: blackColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ).box.padding(EdgeInsets.all(8)).make(),
                                    ],
                                  )
                                      .box
                                      .white
                                      .rounded
                                      .shadowSm
                                      .padding(EdgeInsets.all(12))
                                      .make(),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Image.asset(
                                    icDislikeButton,
                                    width: 60,
                                  ).box.roundedFull.shadowSm.make(),
                                  onPressed: () => controllercard
                                      .swipe(CardSwiperDirection.left),
                                ),
                                SizedBox(width: 30),
                                IconButton(
                                  icon: Image.asset(
                                    icViewMoreButton,
                                    width: 60,
                                  ).box.roundedFull.shadowSm.make(),
                                  onPressed: () => navigateToItemDetails(),
                                ),
                                SizedBox(width: 30),
                                IconButton(
                                  icon: Image.asset(
                                    icLikeButton,
                                    width: 60,
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
      endDrawer: FilterDrawer(),
    );
  }
}

class FilterDrawer extends StatefulWidget {
  @override
  _FilterDrawerState createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  double _currentSliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            35.heightBox,
            ListTile(
              title: Text(
                "Filter products",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("Gender").text.fontFamily(regular).size(14).make(),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  FilterChip(
                    label: Text("All"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  SizedBox(width: 8),
                  FilterChip(
                    label: Text("Men"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  SizedBox(width: 8),
                  FilterChip(
                    label: Text("Women"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child:
                  Text("Official Store").text.fontFamily(regular).size(14).make(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 10,
                children: List.generate(
                  6,
                  (index) => CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.grey.shade300,
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text("Price").text.fontFamily(regular).size(14).make(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Slider(
                value: _currentSliderValue,
                min: 0,
                max: 999999,
                onChanged: (value) {
                  setState(() {
                    _currentSliderValue = value;
                  });
                },
                divisions: 100,
                label: "${_currentSliderValue.round()} Bath",
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text("Color").text.fontFamily(regular).size(14).make(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 15,
                children: List.generate(
                  15,
                  (index) => CircleAvatar(
                    radius: 15,
                    backgroundColor:
                        Colors.primaries[index % Colors.primaries.length],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text("Type of product").text.fontFamily(regular).size(14).make(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 10,
                children: [
                  FilterChip(
                    label: Text("Dress"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  FilterChip(
                    label: Text("Outerwear & Coats"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  FilterChip(
                    label: Text("T-Shirts"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  FilterChip(
                    label: Text("Suits"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  FilterChip(
                    label: Text("Knitwear"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  FilterChip(
                    label: Text("Activewear"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  FilterChip(
                    label: Text("Blazers"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  FilterChip(
                    label: Text("Pants"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  FilterChip(
                    label: Text("Denim"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  FilterChip(
                    label: Text("Skirts"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text("Collection").text.fontFamily(regular).size(14).make(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 10,
                children: [
                  FilterChip(
                    label: Text("Summer"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  FilterChip(
                    label: Text("Winter"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  FilterChip(
                    label: Text("Autumn"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  FilterChip(
                    label: Text("Dinner"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                  FilterChip(
                    label: Text("Everyday"),
                    onSelected: (_) {},
                    selectedColor: primaryApp,
                    backgroundColor: thinPrimaryApp,
                  ),
                ],
              ),
            ),
          ],
        ).box.white.padding(EdgeInsets.symmetric(vertical: 12)).make(),
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
