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
  List<Widget> selectedContent = [];
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _buttonKeys = {};

  @override
  void initState() {
    super.initState();
    String initialTitle = Get.arguments ?? 'Formal Attire';
    switch (initialTitle) {
      case 'Semi-Formal Attire':
        updateContent([
          buildCard('3', 'Charlie', 'Semi-Formal Product 1', '109.99 Bath',
              'Semi-Formal Product 2', '69.99 Bath', '45'),
          buildCard('4', 'David', 'Semi-Formal Product 3', '99.99 Bath',
              'Semi-Formal Product 4', '79.99 Bath', '12'),
        ], 'Semi-Formal Attire');
        break;
      case 'Casual Attire':
        updateContent([
          buildCard('5', 'Eve', 'Casual Product 1', '89.99 Bath',
              'Casual Product 2', '59.99 Bath', '56'),
          buildCard('6', 'Frank', 'Casual Product 3', '109.99 Bath',
              'Casual Product 4', '69.99 Bath', '38'),
        ], 'Casual Attire');
        break;
      case 'Seasonal Attire':
        updateContent([
          buildCard('7', 'Grace', 'Seasonal Product 1', '99.99 Bath',
              'Seasonal Product 2', '79.99 Bath', '20'),
          buildCard('8', 'Hank', 'Seasonal Product 3', '89.99 Bath',
              'Seasonal Product 4', '59.99 Bath', '41'),
        ], 'Seasonal Attire');
        break;
      case 'Special Activity Attire':
        updateContent([
          buildCard('1', 'Alice', 'Special Product 1', '99.99 Bath',
              'Special Product 2', '79.99 Bath', '32'),
          buildCard('2', 'Bob', 'Special Product 3', '89.99 Bath',
              'Special Product 4', '59.99 Bath', '24'),
        ], 'Special Activity Attire');
        break;
      case 'Work from Home':
        updateContent([
          buildCard('3', 'Charlie', 'WFH Product 1', '109.99 Bath',
              'WFH Product 2', '69.99 Bath', '45'),
          buildCard('4', 'David', 'WFH Product 3', '99.99 Bath',
              'WFH Product 4', '79.99 Bath', '12'),
        ], 'Work from Home');
        break;
      default:
        updateContent([
          buildCard('1', 'Alice', 'Formal Product 1', '99.99 Bath',
              'Formal Product 2', '79.99 Bath', '32'),
          buildCard('2', 'Bob', 'Formal Product 3', '89.99 Bath',
              'Formal Product 4', '59.99 Bath', '24'),
        ], 'Formal Attire');
        break;
    }
  }

  void updateContent(List<Widget> content, String buttonKey) {
    setState(() {
      selectedContent = content;
    });
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      scrollToButton(buttonKey);
    });
  }

  void scrollToButton(String buttonKey) {
    final keyContext = _buttonKeys[buttonKey]?.currentContext;
    if (keyContext != null) {
      Scrollable.ensureVisible(
        keyContext,
        duration: Duration(milliseconds: 300),
        alignment: 0.5,
      );
    }
  }

  Widget buildButton(String text, List<Widget> content) {
    _buttonKeys[text] = GlobalKey();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        key: _buttonKeys[text],
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryfigma,
          elevation: 0,
        ),
        onPressed: () {
          updateContent(content, text);
        },
        child: Text(
          text,
          style: TextStyle(fontFamily: medium, color: greyDark),
        ),
      ),
    );
  }

  Widget buildCircleAvatar(String text) {
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: CircleAvatar(
        radius: 10,
        backgroundColor: greyLine,
        child: Text(
          text,
          style: TextStyle(color: blackColor, fontSize: 14),
        ),
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

  Widget buildCard(
      String avatarText,
      String userName,
      String productName1,
      String productPrice1,
      String productName2,
      String productPrice2,
      String likes) {
    return Row(
      children: [
        buildCircleAvatar(avatarText),
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
                              backgroundImage: NetworkImage(
                                'https://via.placeholder.com/150',
                              ),
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
                          child: Icon(
                            Icons.image,
                            size: 40,
                            color: Colors.grey,
                          ),
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
                          child: Icon(
                            Icons.image,
                            size: 40,
                            color: Colors.grey,
                          ),
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
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                buildButton('Formal Attire', [
                  buildCard('1', 'Alice', 'Formal Product 1', '99.99 Bath',
                      'Formal Product 2', '79.99 Bath', '32'),
                  buildCard('2', 'Bob', 'Formal Product 3', '89.99 Bath',
                      'Formal Product 4', '59.99 Bath', '24'),
                ]),
                buildButton('Semi-Formal Attire', [
                  buildCard(
                      '3',
                      'Charlie',
                      'Semi-Formal Product 1',
                      '109.99 Bath',
                      'Semi-Formal Product 2',
                      '69.99 Bath',
                      '45'),
                  buildCard('4', 'David', 'Semi-Formal Product 3', '99.99 Bath',
                      'Semi-Formal Product 4', '79.99 Bath', '12'),
                ]),
                buildButton('Casual Attire', [
                  buildCard('5', 'Eve', 'Casual Product 1', '89.99 Bath',
                      'Casual Product 2', '59.99 Bath', '56'),
                  buildCard('6', 'Frank', 'Casual Product 3', '109.99 Bath',
                      'Casual Product 4', '69.99 Bath', '38'),
                ]),
                buildButton('Seasonal Attire', [
                  buildCard('7', 'Grace', 'Seasonal Product 1', '99.99 Bath',
                      'Seasonal Product 2', '79.99 Bath', '20'),
                  buildCard('8', 'Hank', 'Seasonal Product 3', '89.99 Bath',
                      'Seasonal Product 4', '59.99 Bath', '41'),
                ]),
                buildButton('Special Activity Attire', [
                  buildCard('1', 'Alice', 'Special Product 1', '99.99 Bath',
                      'Special Product 2', '79.99 Bath', '32'),
                  buildCard('2', 'Bob', 'Special Product 3', '89.99 Bath',
                      'Special Product 4', '59.99 Bath', '24'),
                ]),
                buildButton('Work from Home', [
                  buildCard('3', 'Charlie', 'WFH Product 1', '109.99 Bath',
                      'WFH Product 2', '69.99 Bath', '45'),
                  buildCard('4', 'David', 'WFH Product 3', '99.99 Bath',
                      'WFH Product 4', '79.99 Bath', '12'),
                ]),
              ],
            ),
          ),
          SizedBox(height: 8.0), // ลดระยะห่างระหว่างการ์ด
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: selectedContent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
