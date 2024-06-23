import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_finalproject/Views/auth_screen/login_screen.dart';
import 'package:flutter_finalproject/Views/auth_screen/verifyemail_screen.dart';
import 'package:flutter_finalproject/Views/cart_screen/cart_screen.dart';
import 'package:flutter_finalproject/Views/search_screen/recent_search_screen.dart';
import 'package:flutter_finalproject/Views/widgets_common/filterDrawer.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:flutter_finalproject/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final bool isGuest;
  const HomeScreen({super.key, this.isGuest = false});

  @override
  _HomeScreenState createState() => _HomeScreenState(isGuest);
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final CardSwiperController controllercard = CardSwiperController();
  var controller = Get.put(HomeController());
  final bool isGuest;
  var isFav = false.obs;
  Map<String, dynamic>? selectedProduct;
  Map<String, dynamic>? previousSwipedProduct;
  late List<Map<String, dynamic>> productsToShow;
  String? selectedItemDetail;
  late TextEditingController searchController;

  _HomeScreenState(this.isGuest);

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    ever(controller.selectedGender, (_) => fetchFilteredProducts());
    ever(controller.maxPrice, (_) => fetchFilteredProducts());
    ever(controller.selectedColors, (_) => fetchFilteredProducts());
    ever(controller.selectedTypes, (_) => fetchFilteredProducts());
    ever(controller.selectedCollections, (_) => fetchFilteredProducts());
    ever(controller.selectedVendorIds, (_) => fetchFilteredProducts());
  }

  List<Map<String, dynamic>> getRandomizedList(
      List<Map<String, dynamic>> originalList) {
    List<Map<String, dynamic>> list = List.from(originalList);
    list.shuffle(Random());
    return list;
  }

  @override
  void dispose() {
    controllercard.dispose();
    searchController.dispose();
    if (!isGuest) {
      isEmailVerified();
    }
    super.dispose();
  }

  void fetchFilteredProducts() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> navigateToItemDetails() async {
    if (isGuest) {
      showLoginPrompt();
      return;
    }
    if (previousSwipedProduct != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemDetails(
            title: previousSwipedProduct!['name'],
            data: previousSwipedProduct!,
          ),
        ),
      );
      if (result != null) {
        setState(() {
          selectedItemDetail = result;
        });
      }
    }
  }

  void showLoginPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Required'),
          content: Text('Please login to access this feature.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Login'),
              onPressed: () {
                Navigator.of(context).pop();
                Get.off(() => LoginScreen());
              },
            ),
          ],
        );
      },
    );
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
      key: scaffoldKey,
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        title: Center(
          child: Image.asset(icLogoOnTop, height: 35)
              .box
              .padding(EdgeInsets.only(left: 40))
              .make(),
        ),
        actions: [
          IconButton(
            icon: Image.asset(icCart, width: 21),
            onPressed: () {
              if (isGuest) {
                showLoginPrompt();
              } else {
                Get.to(() => const CartScreen());
              }
            },
          ),
        ],
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            children: [
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchScreenPage()),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Search')
                                .text
                                .fontFamily(medium)
                                .color(greyDark)
                                .size(16)
                                .make(),
                            Icon(Icons.search, color: greyDark),
                          ],
                        )
                            .box
                            .width(context.screenWidth - 140)
                            .padding(EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14))
                            .border(color: greyLine)
                            .roundedLg
                            .make(),
                      ),
                      15.widthBox,
                      IconButton(
                        icon: Icon(Icons.filter_list_rounded,
                            color: greyDark, size: 30),
                        onPressed: () {
                          showModalRightSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return FilterDrawer();
                            },
                          );
                        },
                      ).box.border(color: greyLine).roundedLg.make(),
                    ],
                  ).paddingSymmetric(horizontal: 12)),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchProducts(
                    gender: controller.selectedGender.value,
                    maxPrice: controller.maxPrice.value,
                    selectedColors: controller.selectedColors,
                    selectedTypes: controller.selectedTypes,
                    selectedCollections: controller.selectedCollections,
                    vendorIds: controller.selectedVendorIds,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.error != null) {
                      return Center(
                          child: Text('An error occurred: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Product not found'));
                    }

                    List<Map<String, dynamic>> products = snapshot.data ?? [];
                    if (currentUser != null) {
                      productsToShow = getRandomizedList(products
                          .where((product) =>
                              !isInWishlist(product, currentUser!.uid))
                          .toList());
                    } else {
                      productsToShow = getRandomizedList(products);
                    }

                    if (productsToShow.isEmpty) {
                      return const Center(child: Text('Product not found'));
                    }

                    return CardSwiper(
                      scale: 0.5,
                      isLoop: false,
                      controller: controllercard,
                      allowedSwipeDirection:
                          AllowedSwipeDirection.only(left: true, right: true),
                      cardsCount: productsToShow.length,
                      numberOfCardsDisplayed: min(3, productsToShow.length),
                      cardBuilder: (BuildContext context, int index,
                          int percentThresholdX, int percentThresholdY) {
                        if (index == 0) {
                          previousSwipedProduct = productsToShow[index];
                        }
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
                                            product['imgs'][0],
                                            height: MediaQuery.of(context)
                                                        .size
                                                        .height <
                                                    855
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.41
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.46,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product['name'],
                                              style: TextStyle(
                                                  color: blackColor,
                                                  fontSize: 20,
                                                  fontFamily: medium),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              "${NumberFormat('#,##0').format(int.parse(product['price']))} Bath",
                                              style: TextStyle(
                                                  color: blackColor,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ).box.padding(EdgeInsets.all(8)).make(),
                                      ],
                                    )
                                        .box
                                        .white
                                        .rounded
                                        .outerShadow
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
                                    icon:
                                        Image.asset(icDislikeButton, width: 60)
                                            .box
                                            .roundedFull
                                            .outerShadow
                                            .make(),
                                    onPressed: () => controllercard
                                        .swipe(CardSwiperDirection.left),
                                  ),
                                  SizedBox(width: 30),
                                  IconButton(
                                    icon:
                                        Image.asset(icViewMoreButton, width: 60)
                                            .box
                                            .roundedFull
                                            .outerShadow
                                            .make(),
                                    onPressed: () => navigateToItemDetails(),
                                  ),
                                  SizedBox(width: 30),
                                  IconButton(
                                    icon: Image.asset(icLikeButton, width: 60)
                                        .box
                                        .roundedFull
                                        .outerShadow
                                        .make(),
                                    onPressed: () {
                                      controllercard
                                          .swipe(CardSwiperDirection.right);
                                      controller.addToWishlist(
                                          previousSwipedProduct!);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      onSwipe: (previousIndex, currentIndex, direction) {
                        // Check if currentIndex is valid before proceeding
                        if (currentIndex != null) {
                          Map<String, dynamic>? currentProduct =
                              productsToShow[currentIndex];

                          // Check if direction is right to add to wishlist
                          if (direction == CardSwiperDirection.right) {
                            if (!isGuest && previousSwipedProduct != null) {
                              controller.addToWishlist(previousSwipedProduct!);
                            } else if (isGuest) {
                              showLoginPrompt();
                            }
                          }

                          // Update previousSwipedProduct at the end of swipe action
                          previousSwipedProduct = currentProduct;
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
      ),
    );
  }
}

void showModalRightSheet({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: blackColor.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 200),
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return Align(
        alignment: Alignment.centerRight,
        child: Material(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: builder(context),
          ),
        ),
      );
    },
    transitionBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}
