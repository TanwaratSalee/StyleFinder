import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';

class PopularSituationMatchingScreen extends StatefulWidget {
  @override
  _PopularSituationMatchingScreenState createState() =>
      _PopularSituationMatchingScreenState();
}

class _PopularSituationMatchingScreenState
    extends State<PopularSituationMatchingScreen> {
  Future<List<Widget>>? _futureContent;

  @override
  void initState() {
    super.initState();
    _futureContent = fetchData();
  }

  Future<List<Widget>> fetchData() async {
    List<Widget> content = [];
    final querySnapshot =
        await FirebaseFirestore.instance.collection('usermixandmatch').get();

    for (var index = 0; index < querySnapshot.docs.length; index++) {
      var doc = querySnapshot.docs[index];
      var docData = doc.data() as Map<String, dynamic>;
      var productIdTop = docData['product_id_top'] ?? '';
      var productIdLower = docData['product_id_lower'] ?? '';
      var userId = docData['user_id'] ?? '';

      var userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      var userData = userSnapshot.data() as Map<String, dynamic>;
      var userName = userData['name'] ?? '';
      var userImage = userData['imageUrl'] ?? '';

      var productTopSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(productIdTop)
          .get();
      var productTopData = productTopSnapshot.data() as Map<String, dynamic>;
      var productNameTop = productTopData['name'] ?? '';
      var productPriceTop = productTopData['price']?.toString() ?? '0';
      var productImageTop =
          (productTopData['imgs'] as List<dynamic>?)?.first ?? '';

      var productLowerSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(productIdLower)
          .get();
      var productLowerData =
          productLowerSnapshot.data() as Map<String, dynamic>;
      var productNameLower = productLowerData['name'] ?? '';
      var productPriceLower = productLowerData['price']?.toString() ?? '0';
      var productImageLower =
          (productLowerData['imgs'] as List<dynamic>?)?.first ?? '';

      var favoriteCount = docData['favorite_count']?.toString() ?? '0';

      content.add(buildCard(
        index + 1,
        userImage,
        userName,
        productNameTop,
        productPriceTop,
        productImageTop,
        productNameLower,
        productPriceLower,
        productImageLower,
        favoriteCount,
      ));
    }

    return content;
  }

  Widget buildCard(
      int index,
      String userImage,
      String userName,
      String productName1,
      String productPrice1,
      String productImageTop,
      String productName2,
      String productPrice2,
      String productImageLower,
      String likes) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: greysituations, // เพิ่ม background color
          child: Text(
            index.toString(),
            style: TextStyle(color: Colors.black), // เพิ่มสีของข้อความ
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 5.0),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: greyLine),
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundImage: NetworkImage(userImage),
                            ),
                            SizedBox(width: 8.0),
                            Text(userName),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 15.0,
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              likes,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: medium,
                                  color: greyDark),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 65,
                          color: Colors.grey[300],
                          child: Image.network(productImageTop),
                        ),
                        SizedBox(width: 8.0),
                        buildProductInfo(productName1, productPrice1),
                        SizedBox(width: 8.0),
                        CircleAvatar(
                          radius: 7,
                          backgroundColor: primaryApp,
                          child: Icon(
                            Icons.add,
                            size: 13,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Container(
                          width: 56,
                          height: 65,
                          color: Colors.grey[300],
                          child: Image.network(productImageLower),
                        ),
                        SizedBox(width: 8.0),
                        buildProductInfo(productName2, productPrice2),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildProductInfo(String name, String price) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 13, color: greyDark, fontFamily: medium),
          ),
          Text(
            price,
            style: TextStyle(fontSize: 13, color: greyDark, fontFamily: medium),
          ),
        ],
      ),
    );
  }

  Widget buildButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryfigma,
          elevation: 0,
        ),
        onPressed: () {
          setState(() {
            // เรียก fetchData ใหม่เมื่อกดปุ่ม เพื่ออัปเดตเนื้อหา
            _futureContent = fetchData();
          });
        },
        child: Text(
          text,
          style: TextStyle(fontFamily: medium, color: greyDark),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Popular Situation Matching',
          style: TextStyle(fontFamily: medium),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                buildButton('Formal Attire'),
                buildButton('Semi-Formal Attire'),
                buildButton('Casual Attire'),
                buildButton('Seasonal Attire'),
                buildButton('Special Activity Attire'),
                buildButton('Work from Home'),
              ],
            ),
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: FutureBuilder<List<Widget>>(
              future: _futureContent,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: snapshot.data!,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
