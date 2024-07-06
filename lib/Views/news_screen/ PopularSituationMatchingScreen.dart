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
  String _selectedSituation = '';
  String _title = 'Popular Situation Matching';

  @override
  void initState() {
    super.initState();
    _futureContent = fetchData();
  }

  Future<List<Widget>> fetchData() async {
    List<Widget> content = [];
    final querySnapshot =
        await FirebaseFirestore.instance.collection('usermixandmatch').get();

    final userIds =
        querySnapshot.docs.map((doc) => doc.data()['user_id']).toList();
    final productIdsTop =
        querySnapshot.docs.map((doc) => doc.data()['product_id_top']).toList();
    final productIdsLower = querySnapshot.docs
        .map((doc) => doc.data()['product_id_lower'])
        .toList();

    final usersFuture = FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: userIds)
        .get();
    final productsTopFuture = FirebaseFirestore.instance
        .collection('products')
        .where(FieldPath.documentId, whereIn: productIdsTop)
        .get();
    final productsLowerFuture = FirebaseFirestore.instance
        .collection('products')
        .where(FieldPath.documentId, whereIn: productIdsLower)
        .get();

    final usersSnapshot = await usersFuture;
    final productsTopSnapshot = await productsTopFuture;
    final productsLowerSnapshot = await productsLowerFuture;

    final userDataMap = {
      for (var doc in usersSnapshot.docs) doc.id: doc.data()
    };
    final productTopDataMap = {
      for (var doc in productsTopSnapshot.docs) doc.id: doc.data()
    };
    final productLowerDataMap = {
      for (var doc in productsLowerSnapshot.docs) doc.id: doc.data()
    };

    // เก็บข้อมูลพร้อม favorite_count เพื่อใช้ในการจัดเรียง
    List<Map<String, dynamic>> dataWithFavoriteCount = [];

    for (var index = 0; index < querySnapshot.docs.length; index++) {
      var doc = querySnapshot.docs[index];
      var docData = doc.data() as Map<String, dynamic>;
      var productIdTop = docData['product_id_top'] ?? '';
      var productIdLower = docData['product_id_lower'] ?? '';
      var userId = docData['user_id'] ?? '';
      var situations = List<String>.from(
          docData['situations'] ?? []); // ดึงข้อมูลสถานการณ์ที่เป็น array

      // กรองข้อมูลตามสถานการณ์ที่เลือก
      if (_selectedSituation.isNotEmpty &&
          !situations.contains(_selectedSituation)) {
        continue;
      }

      var userData = userDataMap[userId] as Map<String, dynamic>;
      var userName = userData['name'] ?? '';
      var userImage = userData['imageUrl'] ?? '';

      var productTopData =
          productTopDataMap[productIdTop] as Map<String, dynamic>;
      var productNameTop = productTopData['name'] ?? '';
      var productPriceTop = productTopData['price']?.toString() ?? '0';
      var productImageTop =
          (productTopData['imgs'] as List<dynamic>?)?.first ?? '';

      var productLowerData =
          productLowerDataMap[productIdLower] as Map<String, dynamic>;
      var productNameLower = productLowerData['name'] ?? '';
      var productPriceLower = productLowerData['price']?.toString() ?? '0';
      var productImageLower =
          (productLowerData['imgs'] as List<dynamic>?)?.first ?? '';

      var favoriteCount = docData['favorite_count'] ?? 0;

      dataWithFavoriteCount.add({
        'index': index,
        'userImage': userImage,
        'userName': userName,
        'productNameTop': productNameTop,
        'productPriceTop': productPriceTop,
        'productImageTop': productImageTop,
        'productNameLower': productNameLower,
        'productPriceLower': productPriceLower,
        'productImageLower': productImageLower,
        'favoriteCount': favoriteCount
      });
    }

    // จัดเรียงข้อมูลตาม favorite_count
    dataWithFavoriteCount
        .sort((a, b) => b['favoriteCount'].compareTo(a['favoriteCount']));

    // จำกัดจำนวนข้อมูลที่ต้องการแสดงเป็น 10 อันดับแรก
    final top10Data = dataWithFavoriteCount.take(10).toList();

    for (var i = 0; i < top10Data.length; i++) {
      var item = top10Data[i];
      content.add(buildCard(
        i + 1,
        item['userImage'],
        item['userName'],
        item['productNameTop'],
        item['productPriceTop'],
        item['productImageTop'],
        item['productNameLower'],
        item['productPriceLower'],
        item['productImageLower'],
        item['favoriteCount'].toString(),
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

  Widget buildButton(String text, String situation) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryfigma,
          elevation: 0,
        ),
        onPressed: () {
          setState(() {
            _selectedSituation = situation; // อัปเดตสถานการณ์ที่เลือก
            _title = text.isEmpty
                ? 'Popular Situation Matching'
                : text; // อัปเดต title
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
          _title, // ใช้ตัวแปร _title
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
                buildButton('All', ''),
                buildButton('Formal Attire', 'formal'),
                buildButton('Semi-Formal Attire', 'semi-formal'),
                buildButton('Casual Attire', 'casual'),
                buildButton('Seasonal Attire', 'seasonal'),
                buildButton('Special Activity Attire', 'special-activity'),
                buildButton('Work from Home', 'work-from-home'),
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
