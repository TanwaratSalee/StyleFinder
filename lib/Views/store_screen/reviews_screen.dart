import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';

class ReviewScreen extends StatefulWidget {
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 2, vsync: this); // กำหนดจำนวน tabs และ vsync
  }

  @override
  void dispose() {
    _tabController.dispose(); // ทำลาย controller เมื่อไม่ใช้งาน
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(
          'Reviews',
          style: TextStyle(
            fontFamily: bold,
          ),
        ),
        centerTitle: true,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios),
        //   onPressed: () => Get.back(),
        // ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0), // ปรับความสูงเพื่อรองรับ TabBar
          child: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Shop'),
              Tab(text: 'Product'),
            ],
          ),
        ),
      ),
      body: Expanded(
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            _buildReviewShop(context),
            _buildReviewProduct(context)
          ],
        ),
      ),
    );
  }
}

Widget _buildReviewProduct(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: <Widget>[
        YourWidget(),
        Padding(
          padding: const EdgeInsets.all(5),
          child: _buildReviewHigh(),
        ),
      ],
    ),
  );
}

Widget _botton(BuildContext context) {
  return Container(
      alignment: Alignment.centerRight, // จัดตำแหน่งชิดขวากลาง
      margin: EdgeInsets.only(right: 20.0), // กำหนดระยะห่างจากขวา 20.0 พิกเซล
      child: Container(
        height: 28,
        width: 70,
        margin: EdgeInsets.only(top: 5),
        // margin: EdgeInsets.all(10),
        // padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: greyDark1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ));
}

Widget _buildReviewShop(BuildContext context) {
  return Column(
    children: <Widget>[
      YourWidget(),
      Padding(
        padding: const EdgeInsets.all(5),
        child: _buildReviewHighlights(),
      ),
    ],
  );
}

Widget _buildReviewHighlights() {
  return Container(
    height: 600,
    margin: EdgeInsets.only(top: 0.5),
    child: ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return _buildReviewCard();
      },
    ),
  );
}

Widget _buildReviewHigh() {
  return Container(
    height: 600,
    margin: EdgeInsets.only(top: 0.5),
    child: ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return _buildReviewProductCard();
      },
    ),
  );
}

Widget _buildReviewCard() {
  return Container(
    height: 142,
    width: 387,
    margin: EdgeInsets.all(5.0),
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: whiteColor,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: greyDark1,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage('your_image_url_here'),
            ),
            SizedBox(width: 10),
            Text('Reviewer Name',
                style: TextStyle(fontSize: 16, fontFamily: bold)),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: List.generate(5, (index) {
            return Icon(
              index < 4 ? Icons.star : Icons.star_border,
              color: Colors.amber,
              size: 20,
            );
          }),
        ),
        Text(
          'The review text goes here...',
          style: TextStyle(fontSize: 14),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}

Widget _buildReviewProductCard() {
  return Container(
    height: 142,
    width: 387,
    margin: EdgeInsets.all(5.0),
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: whiteColor,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: greyDark1,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      // Changed to Row to allow for side-by-side layout
      children: [
        Container(
          // This container is for the image placeholder
          height: 122, // Adjusted to fit within the parent container's padding
          width: 122, // Making it square
          decoration: BoxDecoration(
            color: Colors.grey[200], // Placeholder color
            borderRadius:
                BorderRadius.circular(8), // Optional: to match the card's style
          ),
          // You can add an image here using a widget like Image.network or for a placeholder use Icon
          child: Icon(Icons.photo, color: Colors.grey[500]), // Placeholder icon
        ),
        Expanded(
          // Using Expanded to fill the remaining space
          child: Padding(
            padding:
                const EdgeInsets.only(left: 10.0), // Added padding for spacing
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align text to the start
              children: [
                Text('Reviewer Name',
                    style:
                        TextStyle(fontSize: 16, fontFamily: bold)),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Align stars to start
                  children: List.generate(5, (index) {
                    return Icon(
                      index < 4 ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 20,
                    );
                  }),
                ),
                SizedBox(height: 10),
                Text(
                  'The review text goes here...',
                  style: TextStyle(fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class YourWidget extends StatefulWidget {
  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  String buttonText = 'New'; // Initial button text

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight, // Align the button to the center-right
      margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.grey,
          backgroundColor:
              Colors.white, // Content color for the button's children
          shadowColor: Colors.grey, // Shadow color
          elevation: 4, // Shadow elevation
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
          fixedSize:
              Size(110, 28), // Adjusted size of the button to accommodate icon
        ),
        onPressed: () {
          setState(() {
            buttonText = buttonText == 'New' ? 'Oldest' : 'New';
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.min, // Use the minimum amount of space
          children: [
            Icon(
              buttonText == 'New' ? Icons.arrow_upward : Icons.arrow_downward,
              size: 16, // Icon size
              color: Colors.grey, // Icon color
            ),
            SizedBox(width: 4), // Space between icon and text
            Text(buttonText),
          ],
        ),
      ),
    );
  }
}
