
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:get/get.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreylight,
      appBar: AppBar(
        title: const Text('DIOR'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildLogoAndRatingSection(context),
            // _buildReviewHighlights(),
             _buildProductMatchTabs(context), 
             _buildCategoryTabs(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoAndRatingSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Column(
        children: <Widget>[
          _buildRatingSection(),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    imProfile,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 24),
                    const SizedBox(width: 8),
                    const Text(
                      '4.9/5.0',
                      style: TextStyle(fontSize: 14, fontFamily: regular),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: const Text('All Reviews >>>'),
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

  // Widget _buildReviewHighlights() {
  //   return Container(
  //     height: 120,
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: 3,
  //       itemBuilder: (context, index) {
  //         return _buildReviewCard();
  //       },
  //     ),
  //   );
  // }

  // Widget _buildReviewCard() {
  //   return Container(
  //     width: 200,
  //     margin: EdgeInsets.all(5.0),
  //     padding: EdgeInsets.all(10.0),
  //     decoration: BoxDecoration(
  //       color: whiteColor,
  //       borderRadius: BorderRadius.circular(8),
  //       boxShadow: [
  //         BoxShadow(
  //           color: fontGrey,
  //           blurRadius: 4,
  //           offset: Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text('Reviewer Name',
  //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //         Row(
  //           children: List.generate(5, (index) {
  //             return Icon(
  //               index < 4 ? Icons.star : Icons.star_border,
  //               color: Colors.amber,
  //               size: 20,
  //             );
  //           }),
  //         ),
  //         Text(
  //           'The review text goes here...',
  //           style: TextStyle(fontSize: 14),
  //           maxLines: 2,
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildCategoryTabs(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Column(
        children: <Widget>[
          const TabBar(
            isScrollable: true,
            indicatorColor: primaryApp,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Outer'),
              Tab(text: 'Dress'),
              Tab(text: 'Blouse/Shirt'),
              Tab(text: 'T-Shirt'),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: TabBarView(
              children: [
                _buildProductGrid('All'),
                _buildProductGrid('Outer'),
                _buildProductGrid('Dress'),
                _buildProductGrid('Blouse/Shirt'),
                _buildProductGrid('T-Shirt'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  

  Widget _buildProductGrid(String category) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.5,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                card1,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 210,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Product Title',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    Text('Price',
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      itemCount: 10,
    );
  }
}

Widget _buildProductMatchTabs(BuildContext context) {
    return const DefaultTabController(
      length: 2, // มีแท็บทั้งหมด 2 แท็บ
      child: Column(
        children: <Widget>[
          TabBar(
            tabs: [
              Tab(text: 'Product'),
              Tab(text: 'Match'),
            ],
          ),
          
        ],
      ),
    );
  }


Widget _buildMatchView() {
  // ตัวอย่าง: สามารถเป็น ListView, GridView หรือโครงสร้างอื่นที่แสดงการจับคู่
  return DefaultTabController(
      length: 5,
      child: Column(
        children: <Widget>[
          const TabBar(
            isScrollable: true,
            indicatorColor: primaryApp,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Outer'),
              Tab(text: 'Dress'),
              Tab(text: 'Blouse/Shirt'),
              Tab(text: 'T-Shirt'),
            ],
          ),
           Container(
          //   height: MediaQuery.of(context).size.height * 0.9,
             child: TabBarView(
               children: [
                // Center(child: Text('Content for All')),
                // Center(child: Text('Content for Outer')),
                // Center(child: Text('Content for Dress')),
                // Center(child: Text('Content for Blouse/Shirt')),
                // Center(child: Text('Content for T-Shirt')),
               ],
             ),
           ),
        ],
      ),
    );
}
