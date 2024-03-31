
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_finalproject/Views/store_screen/match_detail_screen.dart';
import 'package:flutter_finalproject/Views/store_screen/reviews_screen.dart';
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
             _buildReviewHighlights(),
             _buildProductMatchTabs(context), 
            
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
          _buildRatingSection( context),
        ],
      ),
    );
  }

  Widget _buildRatingSection(BuildContext context) {
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
                    const Spacer(),
                    TextButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReviewScreen()),
    );
  },
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

  Widget _buildReviewHighlights() {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return _buildReviewCard();
        },
      ),
    );
  }

  Widget _buildReviewCard() {
    return Container(
      width: 200,
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
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
          const Text('Reviewer Name',
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
          const Text(
            'The review text goes here...',
            style: TextStyle(fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
Widget _buildProductMatchTabs(BuildContext context) {
    return  DefaultTabController(
      length: 2, // มีแท็บทั้งหมด 2 แท็บ
      child: Column(
        children: <Widget>[
          const TabBar(
            tabs: [
              Tab(text: 'Product'),
              Tab(text: 'Match'),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: TabBarView(
              children: [
               _buildProductTab(context),
               _buildMatchTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildProductTab(BuildContext context) {
  return Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(5),
        child: _buildCategoryTabs(context),
      ),
      Expanded(
        child: Container(),
      ),
    ],
  );
}

Widget _buildMatchTab(BuildContext context) {
  
  return  Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(5),
        child: _buildCategoryMath(context),
      ),
      Expanded(
        child: Container(),
      ),
    ],
  );
}
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

  
Widget _buildCategoryMath(BuildContext context) {
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
                _buildProductMathGrids('All'),
                _buildProductMathGrids('Outer'),
               _buildProductMathGrids('Dress'),
               _buildProductMathGrids('Blouse/Shirt'),
                _buildProductMathGrids('T-Shirt'),
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
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 2,
      ),
      itemBuilder: (BuildContext context, int index) {
       return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MatchDetailScreen()), // Ensure you have a class named ItemMatching
          );
        },
        child:  Card(
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
        ),
        );
      },
      itemCount: 50,
    );
  }
Widget _buildProductMathGrids(String category) {
  return GridView.builder(
    padding: const EdgeInsets.all(2),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 1 / 2,
    ),
    itemBuilder: (BuildContext context, int index) {
      
      String productName1 = "Product $index A";
      double price1 = 100.0; 
      String productName2 = "Product $index B";
      double price2 = 150.0; 
      double totalPrice = price1 + price2;
 return GestureDetector(
        onTap: () {
          // Add navigation to ItemMatching page here
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MatchDetailScreen()), // Ensure you have a class named ItemMatching
          );
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
                    Image.asset(
                      card1,
                      width: 80,
                      height: 80,
                    ),
                    Image.asset(
                      card2,
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
                        const SizedBox(height: 2,),
                        Text(
                          productName1, 
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Price: \$${price1.toString()}', 
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Text(
                          productName2, 
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Price: \$${price2.toString()}', 
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                       
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 8),
            //   child: Text(
            //     'Total Price: \$${totalPrice.toString()}', 
            //     style: TextStyle(
            //       color: Colors.black,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),);
    },
    itemCount: 50,
  );
}
}