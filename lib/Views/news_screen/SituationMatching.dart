import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/match_screen/matchpost_details.dart';
import 'package:flutter_finalproject/Views/store_screen/matchstore_detail.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';

class SituationMatching extends StatefulWidget {
  final int initialTabIndex;
  final String title;

  const SituationMatching(
      {Key? key, required this.initialTabIndex, required this.title})
      : super(key: key);

  @override
  _SituationMatchingState createState() => _SituationMatchingState();
}

class _SituationMatchingState extends State<SituationMatching> {
  Future<List<Widget>>? _futureContent;
  String _selectedSituation = '';
  String _title = '';

  @override
  void initState() {
    super.initState();
    _selectedSituation = getSelectedSituation(widget.initialTabIndex);
    _title = widget.title;
    _futureContent = fetchData();
  }

  String getSelectedSituation(int index) {
    switch (index) {
      case 0:
        _title = 'Popular Situation Matching';
        return '';
      case 1:
        return 'formal';
      case 2:
        return 'semi-formal';
      case 3:
        return 'casual';
      case 4:
        return 'seasonal';
      case 5:
        return 'special-activity';
      case 6:
        return 'work-from-home';
      default:
        return '';
    }
  }

  Future<List<Widget>> fetchData() async {
    List<Widget> content = [];

    final userMixAndMatchQuery =
        FirebaseFirestore.instance.collection('usermixandmatch').get();
    final storeMixAndMatchQuery =
        FirebaseFirestore.instance.collection('storemixandmatchs').get();

    final querySnapshots =
        await Future.wait([userMixAndMatchQuery, storeMixAndMatchQuery]);

    final combinedDocs = [...querySnapshots[0].docs, ...querySnapshots[1].docs];

    final userIds = combinedDocs
        .map((doc) => doc.data()['user_id'])
        .where((userId) => userId != null)
        .toSet()
        .toList();
    final vendorIds = combinedDocs
        .map((doc) => doc.data()['vendor_id'])
        .where((vendorId) => vendorId != null)
        .toSet()
        .toList();
    final productIdsTop = combinedDocs
        .map((doc) => doc.data()['product_id_top'])
        .where((productIdTop) => productIdTop != null)
        .toSet()
        .toList();
    final productIdsLower = combinedDocs
        .map((doc) => doc.data()['product_id_lower'])
        .where((productIdLower) => productIdLower != null)
        .toSet()
        .toList();

    final usersFuture = FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: userIds)
        .get();
    final vendorsFuture = FirebaseFirestore.instance
        .collection('vendors')
        .where(FieldPath.documentId, whereIn: vendorIds)
        .get();
    final productsTopFuture = FirebaseFirestore.instance
        .collection('products')
        .where(FieldPath.documentId, whereIn: productIdsTop)
        .get();
    final productsLowerFuture = FirebaseFirestore.instance
        .collection('products')
        .where(FieldPath.documentId, whereIn: productIdsLower)
        .get();

    final snapshots = await Future.wait(
        [usersFuture, vendorsFuture, productsTopFuture, productsLowerFuture]);

    final usersSnapshot = snapshots[0];
    final vendorsSnapshot = snapshots[1];
    final productsTopSnapshot = snapshots[2];
    final productsLowerSnapshot = snapshots[3];

    final userDataMap = {
      for (var doc in usersSnapshot.docs) doc.id: doc.data()
    };
    final vendorDataMap = {
      for (var doc in vendorsSnapshot.docs) doc.id: doc.data()
    };
    final productTopDataMap = {
      for (var doc in productsTopSnapshot.docs) doc.id: doc.data()
    };
    final productLowerDataMap = {
      for (var doc in productsLowerSnapshot.docs) doc.id: doc.data()
    };

    List<Map<String, dynamic>> dataWithFavoriteCount = [];

    for (var doc in combinedDocs) {
      var docData = doc.data() as Map<String, dynamic>;
      var productIdTop = docData['product_id_top'] ?? '';
      var productIdLower = docData['product_id_lower'] ?? '';
      var userId = docData['user_id'] ?? '';
      var vendorId = docData['vendor_id'] ?? '';
      var situations = List<String>.from(docData['situations'] ?? []);

      if (_selectedSituation.isNotEmpty &&
          !situations.contains(_selectedSituation)) {
        continue;
      }

      var userName = '';
      var userImage = '';

      if (userId.isNotEmpty) {
        var userData = userDataMap[userId] as Map<String, dynamic>?;
        if (userData == null) continue;
        userName = userData['name'] ?? '';
        userImage = userData['imageUrl'] ?? '';
      } else if (vendorId.isNotEmpty) {
        var vendorData = vendorDataMap[vendorId] as Map<String, dynamic>?;
        if (vendorData == null) continue;
        userName = vendorData['name'] ?? '';
        userImage = vendorData['imageUrl'] ?? '';
      }

      var productTopData =
          productTopDataMap[productIdTop] as Map<String, dynamic>?;
      if (productTopData == null) continue;
      var productNameTop = productTopData['name'] ?? '';
      var productPriceTop = productTopData['price']?.toString() ?? '0';
      var productImageTop =
          (productTopData['imgs'] as List<dynamic>?)?.first ?? '';

      var productLowerData =
          productLowerDataMap[productIdLower] as Map<String, dynamic>?;
      if (productLowerData == null) continue;
      var productNameLower = productLowerData['name'] ?? '';
      var productPriceLower = productLowerData['price']?.toString() ?? '0';
      var productImageLower =
          (productLowerData['imgs'] as List<dynamic>?)?.first ?? '';

      var favoriteCount = docData['favorite_count'] ?? 0;

      dataWithFavoriteCount.add({
        'userImage': userImage,
        'userName': userName,
        'productNameTop': productNameTop,
        'productPriceTop': productPriceTop,
        'productImageTop': productImageTop,
        'productNameLower': productNameLower,
        'productPriceLower': productPriceLower,
        'productImageLower': productImageLower,
        'favoriteCount': favoriteCount,
        'documentId': doc.id,
        'isStoreMatch': doc.reference.parent.id == 'storemixandmatchs',
        'matchedData': docData, // เพิ่ม matchedData
      });
    }

    dataWithFavoriteCount
        .sort((a, b) => b['favoriteCount'].compareTo(a['favoriteCount']));

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
        item['documentId'],
        item['isStoreMatch'],
        item['matchedData'], // ส่ง matchedData
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
      String likes,
      String documentId,
      bool isStoreMatch,
      Map<String, dynamic> matchedData) {
    return GestureDetector(
      onTap: () {
        if (isStoreMatch) {
          Get.to(() => MatchStoreDetailScreen(documentId: documentId));
        } else {
          Get.to(() => MatchPostsDetails(
                docId: documentId,
                productName1: productName1,
                productName2: productName2,
                price1: productPrice1,
                price2: productPrice2,
                productImage1: productImageTop,
                productImage2: productImageLower,
                totalPrice:
                    (double.parse(productPrice1) + double.parse(productPrice2))
                        .toString(),
                vendorName1: 'Vendor Name 1',
                vendorName2: 'Vendor Name 2',
                vendor_id: matchedData['vendor_id'] ?? '',
                collection: matchedData['collection'] ?? [],
                situations: matchedData['situations'] ?? [],
                description: matchedData['description'] ?? '',
                gender: matchedData['gender'] ?? '',
                user_id: matchedData['user_id'] ?? '',
              ));
        }
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: greysituations,
            child: Text(
              index.toString(),
              style: TextStyle(color: blackColor),
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
                                color: redColor,
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
                            color: greyColor,
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
                              color: whiteColor,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Container(
                            width: 56,
                            height: 65,
                            color: greyColor,
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
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title,
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
                buildButton('All', '', 0),
                buildButton('Formal Attire', 'formal', 1),
                buildButton('Semi-Formal Attire', 'semi-formal', 2),
                buildButton('Casual Attire', 'casual', 3),
                buildButton('Seasonal Attire', 'seasonal', 4),
                buildButton('Activity Attire', 'special-activity', 5),
                buildButton('Work from Home', 'work-from-home', 6),
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

  Widget buildButton(String text, String situation, int tabIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryfigma,
          elevation: 0,
        ),
        onPressed: () {
          setState(() {
            _selectedSituation = situation;
            _futureContent = fetchData();
            _title = tabIndex == 0 ? 'Popular Situation Matching' : text;
          });
        },
        child: Text(
          text.isEmpty ? 'Popular Situation Matching' : text,
          style: TextStyle(fontFamily: medium, color: greyDark),
        ),
      ),
    );
  }
}
