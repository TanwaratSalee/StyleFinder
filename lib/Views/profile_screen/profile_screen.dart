import 'package:flutter_finalproject/Views/profile_screen/menu_setting_screen.dart';
import 'package:get/get.dart';

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
    _tabController = TabController(length: 2, vsync: this);
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
            fontFamily: regular,
          ),
        ),
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
              fontSize: 15,
              fontFamily: regular,
              color: greyDark2
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontFamily: regular,
              color: greyDark1
            ),
            tabs: [
              const Tab(text: 'Product'),
              const Tab(text: 'Match'),
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
                          data['imageUrl'] == ''
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.asset(
                                    imProfile,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                    data['imageUrl'],
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          const SizedBox(height: 10),
                          Text(
                            data['name'][0].toUpperCase() +
                                data['name'].substring(1),
                            style: const TextStyle(
                              fontSize: 18,
                              color: blackColor,
                              fontFamily: regular,
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
            child:
                Text("No products you liked!", style: TextStyle(color: greyDark2)),
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
                      data: data[index],
                    ),
                  ),
                );
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(/*vertical: 5,*/ horizontal: 8),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: ClipRRect(
                        child: Image.network(
                          data[index]['p_imgs'][0],
                          height: 75,
                          width: 65,
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
                                fontFamily: regular,
                              ),
                            ),
                            Text(
                              "${data[index]['p_price']}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: light,
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

Widget buildMatchTab() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('products').snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (!snapshot.hasData) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      // Temporarily store documents by their mixMatch values
      Map<String, List<DocumentSnapshot>> mixMatchGroups = {};

      // Count occurrences of each mixMatch value
      snapshot.data!.docs.forEach((doc) {
        var data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('p_mixmatch') && data['p_wishlist'].contains(currentUser?.uid)) {
          String mixMatch = data['p_mixmatch'];
          if (mixMatchGroups[mixMatch] == null) {
            mixMatchGroups[mixMatch] = [];
          }
          mixMatchGroups[mixMatch]!.add(doc);
        }
      });

      // Filter out the mixMatch groups that don't have pairs
      var validPairs = mixMatchGroups.values.where((list) => list.length >= 2 && list.length % 2 == 0).toList();

      // Flatten the list for the GridView.builder
      var flatList = validPairs.expand((i) => i).toList();

      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 1.3,
        ),
        itemCount: flatList.length ~/ 2, // Divide by 2 because each item represents a pair
        itemBuilder: (BuildContext context, int index) {
          // Calculate actual index in the flat list
          int actualIndex = index * 2;

          // Safely get data for both products in the pair
          var data1 = flatList[actualIndex].data() as Map<String, dynamic>;
          var data2 = flatList[actualIndex + 1].data() as Map<String, dynamic>;

          // Extract necessary fields
          String productName1 = data1['p_name'];
          String productName2 = data2['p_name'];
          String price1 = data1['p_price'].toString();
          String price2 = data2['p_price'].toString();
          String productImage1 = data1['p_imgs'][0];
          String productImage2 = data2['p_imgs'][0];
          String totalPrice = (int.parse(price1) + int.parse(price2)).toString();

          return GestureDetector(
            onTap: () {
              // Handle onTap event
            },
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Column(
                        children: [
                          Image.network(
                            productImage1,
                            width: 80,
                            height: 80,
                          ),
                          Image.network(
                            productImage2,
                            width: 80,
                            height: 80,
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                productName1,
                                style: const TextStyle(fontFamily: 'bold'),
                              ),
                              Text(
                                'Price: \$${price1}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              Text(
                                productName2,
                                style: const TextStyle(fontFamily: 'bold'),
                              ),
                              Text(
                                'Price: \$${price2}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Total Price: \$${totalPrice}',
                      style: const TextStyle(
                        fontFamily: 'bold',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
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
