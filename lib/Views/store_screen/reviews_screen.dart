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
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(
          'Reviews',
        ).text.size(24).fontFamily(semiBold).color(greyDark).make(),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
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
          children: <Widget>[_buildReviewShop(), _buildReviewProduct(context)],
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

Widget _buildReviewShop() {
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
          color: greyDark,
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
          color: greyDark,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          height: 122,
          width: 122,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.photo, color: Colors.grey[500]),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reviewer Name',
                    style: TextStyle(fontSize: 16, fontFamily: bold)),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
  String buttonText = 'New';

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.grey,
          backgroundColor: whiteColor,
          shadowColor: Colors.grey,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          fixedSize: Size(110, 28),
        ),
        onPressed: () {
          setState(() {
            buttonText = buttonText == 'New' ? 'Oldest' : 'New';
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              buttonText == 'New' ? Icons.arrow_upward : Icons.arrow_downward,
              size: 16,
              color: Colors.grey,
            ),
            SizedBox(width: 4),
            Text(buttonText),
          ],
        ),
      ),
    );
  }
}
