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
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
          TabBar(
            controller: _tabController,
            labelStyle: const TextStyle(
                fontSize: 15, fontFamily: medium, color: primaryApp),
            unselectedLabelStyle: const TextStyle(
                fontSize: 14, fontFamily: regular, color: greyDark1),
            tabs: [
              const Tab(text: 'Product'),
              const Tab(text: 'Match'),
              const Tab(text: 'User Match'),
            ],
            indicatorColor: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildProductsTab(),
                buildMatchTab(),
                buildUserMixMatchTab(),
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
                                    imProfile,
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
                style: TextStyle(color: greyDark2)),
          );
        }
        return ListView.separated(
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
                margin: const EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                        child: Image.network(
                          data[index]['p_imgs'][0],
                          height: 80,
                          width: 75,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              data[index]['p_name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: medium,
                              ),
                            ),
                            Text(
                              "${NumberFormat('#,##0').format(double.parse(data[index]['p_price']).toInt())} Bath",
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: regular,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
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
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              color: Colors.grey[200],
              thickness: 1,
            ),
          ),
        );
      },
    );
  }

/* Widget buildUserMixMatchTab() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirestoreServices.getWishlistsusermixmatchs(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Center(child: CircularProgressIndicator());
      }
      var wishlistNames = snapshot.data!.docs.map((doc) => doc['p_name']).toList();
      if (wishlistNames.isEmpty) {
        return Center(child: Text("No products in your wishlist!", style: TextStyle(color: greyDark2)));
      }

      return ListView.separated(
        itemCount: wishlistNames.length,
        separatorBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Divider(
            color: Colors.grey[200],
            thickness: 1,
          ),
        ),
        itemBuilder: (context, index) {
          return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('products')
                    .where('p_name', isEqualTo: wishlistNames[index])
                    .limit(1)
                    .get(),
            builder: (context, productSnapshot) {
              if (!productSnapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              if (productSnapshot.data!.docs.isEmpty) {
                return ListTile(title: Text('No details available for ${wishlistNames[index]}'));
              }

              var productData = productSnapshot.data!.docs.first.data() as Map<String, dynamic>;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemDetails(
                        title: productData['p_name'],
                        data: productData,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            productData['p_imgs'][0],
                            height: 75,
                            width: 65,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                productData['p_name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: regular,
                                ),
                              ),
                              Text(
                                "${NumberFormat('#,##0').format(double.parse(productData['p_price']).toInt())} Bath",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: regular,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite, color: Colors.red),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection(productsCollection)
                              .doc(productData['docId']) // Make sure 'docId' is the correct document identifier
                              .update({
                            'p_wishlist': FieldValue.arrayRemove(
                                [FirebaseAuth.instance.currentUser!.uid])
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
} */

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
                  style: TextStyle(color: greyDark2)));
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
              'top_image': data['p_imgs_top'][0],
              'lower_image': data['p_imgs_lower'][0],
              'docId_top': doc.id,
              'docId_lower': doc.id
            });
          }
        }

        if (pairs.isEmpty) {
          return Center(
              child: Text("No complete pairs in your wishlist!",
                  style: TextStyle(color: greyDark2)));
        }

        return ListView.builder(
          itemCount: pairs.length,
          itemBuilder: (BuildContext context, int index) {
            var pair = pairs[index];
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: thinGrey01), 
                ),
              ),
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                child: Image.network(
                                  pair['top_image'],
                                  width: 75,
                                  height: 75,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pair['top'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ).text.fontFamily(medium).size(16).color(greyDark2).make(),
                                      Text(
                                        "${NumberFormat('#,##0').format(double.parse(pair['top_price']).toInt())} Bath",
                                      ).text.fontFamily(regular).size(14).color(greyDark1).make(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Product 2
                      GestureDetector(
                        onTap: () {
                          navigateToItemDetails(context, pair['lower']);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                child: Image.network(
                                  pair['lower_image'],
                                  width: 75,
                                  height: 75,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pair['lower'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ).text.fontFamily(medium).size(16).color(greyDark1).make(),
                                      Text(
                                        "${NumberFormat('#,##0').format(double.parse(pair['lower_price']).toInt())} Bath",
                                      ).text.fontFamily(regular).size(14).color(greyDark1).make(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Total Price
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Text(
                              "Total  ",
                              style: TextStyle(
                                color: greyDark2,
                                fontFamily: regular,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "${NumberFormat('#,##0').format(double.parse(pair['top_price']).toInt() + double.parse(pair['lower_price']).toInt())} ",
                              style: TextStyle(
                                color: greyDark2,
                                fontFamily: medium,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              " Bath",
                              style: TextStyle(
                                color: greyDark2,
                                fontFamily: 'regular',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
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
                  .p4
                  .margin(EdgeInsetsDirectional.symmetric(horizontal: 14))
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
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: greyDark1,
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
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
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
                          style: TextStyle(color: greyDark1),
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
        .collection('products')
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("No details available for $productName"),
        ));
      }
    });
  }

  Widget buildMatchTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
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
                style: TextStyle(color: greyDark2)),
          );
        }

        Map<String, List<DocumentSnapshot>> mixMatchGroups = {};

        snapshot.data!.docs.forEach((doc) {
          var data = doc.data() as Map<String, dynamic>;
          if (data.containsKey('p_mixmatch') &&
              data['p_wishlist'].contains(currentUser?.uid)) {
            String mixMatch = data['p_mixmatch'];
            if (mixMatchGroups[mixMatch] == null) {
              mixMatchGroups[mixMatch] = [];
            }
            mixMatchGroups[mixMatch]!.add(doc);
          }
        });

        var validPairs = mixMatchGroups.values
            .where((list) => list.length >= 2 && list.length % 2 == 0)
            .toList();

        var flatList = validPairs.expand((i) => i).toList();

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 1 / 0.61,
          ),
          itemCount: flatList.length ~/ 2,
          itemBuilder: (BuildContext context, int index) {
            int actualIndex = index * 2;

            var data1 = flatList[actualIndex].data() as Map<String, dynamic>;
            var data2 =
                flatList[actualIndex + 1].data() as Map<String, dynamic>;

            String productName1 = data1['p_name'];
            String productName2 = data2['p_name'];
            String price1 = data1['p_price'].toString();
            String price2 = data2['p_price'].toString();
            String productImage1 = data1['p_imgs'][0];
            String productImage2 = data2['p_imgs'][0];
            String totalPrice =
                (int.parse(price1) + int.parse(price2)).toString();

            return GestureDetector(
                onTap: () {},
                child: Column(children: [
                  Column(
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
                                    ClipRRect(
                                      // borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        productImage1,
                                        width: 75,
                                        height: 75,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(25),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              productName1,
                                              style: const TextStyle(
                                                fontFamily: medium,
                                                fontSize: 14,
                                                color: greyDark1,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              "${NumberFormat('#,##0').format(double.parse(price1.toString()).toInt())} Bath",
                                              style: const TextStyle(
                                                  color: greyDark1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      // borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        productImage2,
                                        width: 75,
                                        height: 75,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(19),
                                        child: Column(
                                          
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              productName2,
                                              style: const TextStyle(
                                                fontFamily: medium,
                                                fontSize: 14,
                                                color: greyDark1,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              "${NumberFormat('#,##0').format(double.parse(price2.toString()).toInt())} Bath",
                                              style: const TextStyle(
                                                  color: greyDark1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    Text(
                                      "Total Price  ",
                                      style: TextStyle(
                                        color: greyDark2,
                                        fontFamily: 'regular',
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "${NumberFormat('#,##0').format(double.parse(totalPrice.toString()).toInt())} ",
                                      style: TextStyle(
                                        color: greyDark2,
                                        fontFamily: 'medium',
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      " Bath",
                                      style: TextStyle(
                                        color: greyDark2,
                                        fontFamily: 'regular',
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
                                  // สร้าง List ที่มีรหัสผู้ใช้ปัจจุบันอยู่
                                  List<String> currentUserUid = [
                                    FirebaseAuth.instance.currentUser!.uid
                                  ];

                                  // สร้าง Map ที่จะใช้ในการอัปเดตเอกสารใน Firestore
                                  Map<String, dynamic> updateData = {
                                    'p_wishlist':
                                        FieldValue.arrayRemove(currentUserUid)
                                  };

                                  for (int i = actualIndex;
                                      i <= actualIndex + 1;
                                      i++) {
                                    await FirebaseFirestore.instance
                                        .collection(productsCollection)
                                        .doc(flatList[i].id)
                                        .update(updateData);
                                  }
                                  ;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: thinGrey01,
                  )
                ])
                    .box
                    .color(whiteColor)
                    .margin(EdgeInsets.symmetric(vertical: 5, horizontal: 12))
                    .padding(EdgeInsets.all(8))
                    .make());
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
