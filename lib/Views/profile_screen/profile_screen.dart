import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/profile_screen/menu_setting_screen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../consts/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:flutter_finalproject/services/firestore_services.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  TabController? _mainTabController;
  TabController? _favoriteTabController;

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    _favoriteTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _mainTabController?.dispose();
    _favoriteTabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: blackColor,
            fontSize: 26,
            fontFamily: medium,
          ),
        ),
        shadowColor: greyColor.withOpacity(0.5),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: blackColor,
            ),
            onPressed: () {
              Get.to(() => const MenuSettingScreen());
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          buildUserProfile(),
          AnimatedBuilder(
            animation: _mainTabController!,
            builder: (context, child) {
              return TabBar(
                controller: _mainTabController,
                labelStyle: const TextStyle(
                    fontSize: 15, fontFamily: regular, color: greyDark),
                unselectedLabelStyle: const TextStyle(
                    fontSize: 14, fontFamily: regular, color: greyDark),
                tabs: [
                  Tab(
                    icon: Image.asset(
                      icTapPostProfile,
                      color: _mainTabController?.index == 0
                          ? primaryApp
                          : greyColor,
                      width: 22,
                      height: 22,
                    ),
                  ),
                  Tab(
                    icon: Image.asset(
                      icTapProfileFav,
                      color: _mainTabController?.index == 1
                          ? primaryApp
                          : greyColor,
                      width: 22,
                      height: 22,
                    ),
                  ),
                ],
                unselectedLabelColor: greyColor,
                labelColor: primaryApp,
                indicatorColor: Theme.of(context).primaryColor,
                onTap: (index) {
                  setState(() {
                    // Update the state to trigger a rebuild
                  });
                },
              );
            },
          ),
          Divider(
            color: greyLine,
            thickness: 1,
            height: 2,
          ),
          Expanded(
            child: TabBarView(
              controller: _mainTabController,
              children: [
                buildPostTab(),
                Column(
                  children: [
                    TabBar(
                      controller: _favoriteTabController,
                      labelStyle: const TextStyle(
                          fontSize: 15, fontFamily: medium, color: greyColor),
                      unselectedLabelStyle: const TextStyle(
                          fontSize: 14, fontFamily: medium, color: greyColor),
                      tabs: [
                        const Tab(text: 'Product'),
                        const Tab(text: 'Match'),
                        const Tab(text: 'User Match'),
                      ],
                      unselectedLabelColor: greyColor,
                      labelColor: primaryApp,
                      indicatorColor: Theme.of(context).primaryColor,
                    ),
                    Divider(
                      color: greyLine,
                      thickness: 1,
                      height: 2,
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: TabBarView(
                        controller: _favoriteTabController,
                        children: [
                          buildProductsTab(),
                          buildMatchTab(),
                          buildUserMixMatchTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserProfile() {
    return StreamBuilder(
      stream: FirestoreServices.getUser(currentUser!.uid),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryApp),
            ),
          );
        } else {
          var data = snapshot.data!.docs[0];

          return SafeArea(
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 10),
                          data['imageUrl'] == ''
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.asset(
                                    imgProfile,
                                    width: 110,
                                    height: 110,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                    data['imageUrl'],
                                    width: 110,
                                    height: 110,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          const SizedBox(height: 10),
                          Text(
                            data['name'][0].toUpperCase() +
                                data['name'].substring(1),
                            style: const TextStyle(
                              fontSize: 20,
                              color: blackColor,
                              fontFamily: medium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget buildProductsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreServices.getWishlists(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final data = snapshot.data!.docs;
        if (data.isEmpty) {
          return const Center(
            child: Text("No products you liked!",
                style: TextStyle(color: greyDark)),
          );
        }
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemDetails(
                      title: data[index]['p_name'],
                      data: data[index].data() as Map<String, dynamic>,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                        child: Image.network(
                          data[index]['p_imgs'][0],
                          height: 70,
                          width: 65,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  data[index]['p_name'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: medium,
                                  ),
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                ).box.width(180).make(),
                                Text(
                                  "${NumberFormat('#,##0').format(double.parse(data[index]['p_price']).toInt())} Bath",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: regular,
                                      color: greyDark),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Image.asset(icTapFavoriteButton, width: 20),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection(productsCollection)
                            .doc(data[index].id)
                            .update({
                          'p_wishlist': FieldValue.arrayRemove(
                              [FirebaseAuth.instance.currentUser!.uid])
                        });
                      },
                    ),
                  ],
                )
                    .box
                    .border(color: greyLine)
                    .roundedSM
                    .margin(EdgeInsets.symmetric(horizontal: 12, vertical: 4))
                    .make(),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMatchTab() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection('favoritemixmatch').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final data = snapshot.data!.docs;
        if (data.isEmpty) {
          return const Center(
            child: Text("No products you liked!",
                style: TextStyle(color: greyDark)),
          );
        }

        final currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';

        // Filter the documents for the current user
        var userDocs =
            data.where((doc) => doc['user_id'] == currentUserUID).toList();

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 6 / 2.75,
          ),
          itemCount: userDocs.length,
          itemBuilder: (BuildContext context, int index) {
            var docData = userDocs[index].data() as Map<String, dynamic>;
            var product1 = docData['product1'] as Map<String, dynamic>;
            var product2 = docData['product2'] as Map<String, dynamic>;

            String productName1 = product1['p_name'];
            String productName2 = product2['p_name'];
            String price1 = product1['p_price'].toString();
            String price2 = product2['p_price'].toString();
            String productImage1 = product1['p_imgs'];
            String productImage2 = product2['p_imgs'];
            String totalPrice =
                (int.parse(price1) + int.parse(price2)).toString();

            return GestureDetector(
              onTap: () {
                // Navigate to detail page if needed
              },
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  productImage1,
                                  width: 60,
                                  height: 65,
                                  fit: BoxFit.cover,
                                ),
                                15.widthBox,
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        productName1,
                                        style: const TextStyle(
                                          fontFamily: medium,
                                          fontSize: 14,
                                          color: blackColor,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "${NumberFormat('#,##0').format(double.parse(price1).toInt())} Bath",
                                        style: const TextStyle(color: greyDark),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            5.heightBox,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  child: Image.network(
                                    productImage2,
                                    width: 60,
                                    height: 65,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                15.widthBox,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        productName2,
                                        style: const TextStyle(
                                          fontFamily: medium,
                                          fontSize: 14,
                                          color: blackColor,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "${NumberFormat('#,##0').format(double.parse(price2).toInt())} Bath",
                                        style: const TextStyle(color: greyDark),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            5.heightBox,
                            Row(
                              children: [
                                Text(
                                  "Total  ",
                                  style: TextStyle(
                                    color: greyDark,
                                    fontFamily: regular,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "${NumberFormat('#,##0').format(double.parse(totalPrice).toInt())} ",
                                  style: TextStyle(
                                    color: blackColor,
                                    fontFamily: medium,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  " Bath",
                                  style: TextStyle(
                                    color: greyDark,
                                    fontFamily: regular,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.favorite, color: redColor),
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('favoritemixmatch')
                                  .doc(userDocs[index].id)
                                  .delete()
                                  .then((value) {
                                print('Removed from favoritemixmatch');
                              }).catchError((error) {
                                print(
                                    'Error removing from favoritemixmatch: $error');
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
                  .box
                  .roundedSM
                  .border(color: greyLine)
                  .margin(EdgeInsets.symmetric(horizontal: 12, vertical: 4))
                  .padding(EdgeInsets.all(8))
                  .make(),
            );
          },
        );
      },
    );
  }

  Widget buildUserMixMatchTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreServices.getWishlistsusermixmatchs(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        var documents = snapshot.data!.docs;

        if (documents.isEmpty) {
          return Center(
              child: Text("No products in your wishlist!",
                  style: TextStyle(color: greyDark)));
        }
        List<Map<String, dynamic>> pairs = [];
        for (var doc in documents) {
          var data = doc.data() as Map<String, dynamic>;
          if (data['p_name_top'] != null && data['p_name_lower'] != null) {
            pairs.add({
              'top': data['p_name_top'],
              'lower': data['p_name_lower'],
              'top_price': data['p_price_top'].toString(),
              'lower_price': data['p_price_lower'].toString(),
              'top_image': data['p_imgs_top'],
              'lower_image': data['p_imgs_lower'],
              'docId_top': doc.id,
              'docId_lower': doc.id
            });
          }
        }

        if (pairs.isEmpty) {
          return Center(
              child: Text("No complete pairs in your wishlist!",
                  style: TextStyle(color: greyDark)));
        }

        return ListView.builder(
          itemCount: pairs.length,
          itemBuilder: (BuildContext context, int index) {
            var pair = pairs[index];
            return Container(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product 1
                      GestureDetector(
                        onTap: () {
                          navigateToItemDetails(context, pair['top']);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              pair['top_image'],
                              width: 60,
                              height: 65,
                              fit: BoxFit.cover,
                            ),
                            15.widthBox,
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pair['top'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                      .text
                                      .fontFamily(medium)
                                      .size(14)
                                      .color(blackColor)
                                      .make(),
                                  Text(
                                    "${NumberFormat('#,##0').format(double.parse(pair['top_price']).toInt())} Bath",
                                  )
                                      .text
                                      .fontFamily(regular)
                                      .size(14)
                                      .color(greyDark)
                                      .make(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      5.heightBox,
                      // Product 2
                      GestureDetector(
                        onTap: () {
                          navigateToItemDetails(context, pair['lower']);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              pair['lower_image'],
                              width: 60,
                              height: 65,
                              fit: BoxFit.cover,
                            ),
                            15.widthBox,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    pair['lower'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                      .text
                                      .fontFamily(medium)
                                      .size(14)
                                      .color(blackColor)
                                      .make(),
                                  Text(
                                    "${NumberFormat('#,##0').format(double.parse(pair['lower_price']).toInt())} Bath",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: regular,
                                      color: greyDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      10.heightBox,
                      // Total Price
                      Row(
                        children: [
                          Text(
                            "Total  ",
                            style: TextStyle(
                              color: greyDark,
                              fontFamily: regular,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "${NumberFormat('#,##0').format(double.parse(pair['top_price']).toInt() + double.parse(pair['lower_price']).toInt())} ",
                            style: TextStyle(
                              color: blackColor,
                              fontFamily: medium,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            " Bath",
                            style: TextStyle(
                              color: greyDark,
                              fontFamily: regular,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  // Favorite Icon
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.favorite, color: redColor),
                      onPressed: () async {
                        _showDeleteConfirmationDialog(context, pair['top'],
                            pair['docId_top'], pair['docId_lower']);
                      },
                    ),
                  ),
                ],
              )
                  .box
                  .roundedSM
                  .border(color: greyLine)
                  .margin(EdgeInsets.symmetric(horizontal: 12, vertical: 4))
                  .padding(EdgeInsets.all(8))
                  .make(),
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String productName,
      String docIdTop, String docIdLower) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: AnimatedPadding(
            duration: Duration(milliseconds: 100),
            curve: Curves.easeInOut,
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: whiteColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: greyDark,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Confirm Deletion",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    "Are you sure you want to delete ?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: greyDark),
                        ),
                      ),
                      SizedBox(width: 20.0),
                      TextButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('usermixmatchs')
                              .doc(docIdTop)
                              .delete();
                          await FirebaseFirestore.instance
                              .collection('usermixmatchs')
                              .doc(docIdLower)
                              .delete();
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void navigateToItemDetails(BuildContext context, String productName) {
    FirebaseFirestore.instance
        .collection(productsCollection)
        .where('p_name', isEqualTo: productName)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var productData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetails(
              title: productData['p_name'],
              data: productData,
            ),
          ),
        );
      } else {
        VxToast.show(
          context,
          msg: 'No details available for $productName',
        );
      }
    });
  }

  Widget buildPostTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('postusermixmatchs').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        var data = snapshot.data!.docs;
        if (data.isEmpty) {
          return Center(
            child: Text("No posts available!", style: TextStyle(color: greyDark)),
          );
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = (constraints.maxWidth - 6) / 3;
            return SingleChildScrollView(
              child: Center(
                child: Wrap(
                  spacing: 2, // Horizontal spacing between widgets
                  runSpacing: 2, // Vertical spacing between widgets
                  children: List.generate(data.length, (index) {
                    var doc = data[index];
                    var topImage = doc['p_imgs_top'];
                    var lowerImage = doc['p_imgs_lower'];
                    return Container(
                      width: itemWidth,
                      height: 240,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              width: itemWidth,
                              height: 120,
                              decoration: BoxDecoration(
                                color: greyThin,
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  topImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 120,
                            left: 0,
                            right: 0,
                            child: Container(
                              width: itemWidth,
                              height: 120,
                              decoration: BoxDecoration(
                                color: greyThin,
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  lowerImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          // Eye icon and number of views
                          Positioned(
                            top: 215,
                            left: 5,
                            child: Row(
                              children: [
                                Image.asset(
                                  iceyes, // Path to your image
                                  width: 18,
                                  height: 18,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '0',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
