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
    _tabController = TabController(length: 2, vsync: this); // กำหนดจำนวน tabs และ vsync
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
        title: const Text(
          'Reviews',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0), 
          child: TabBar(
            controller: _tabController,
            tabs: [
              const Tab(text: 'Shop'),
              const Tab(text: 'Product'),
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
  
  return  Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(5),
        child: _buildReviewProduct(context),
      ),
    ],
  );
}

Widget _buildReviewShop(BuildContext context) {
  return Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(5),
        child: _buildReviewHighlights(),
      ),
    ],
  );
}

Widget _buildReviewHighlights() {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return _buildReviewCard();
        },
      ),
    );
  }

Widget _buildReviewCard() {
    return Container(
      width: 200,
      margin: EdgeInsets.all(5.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: fontGrey,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reviewer Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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