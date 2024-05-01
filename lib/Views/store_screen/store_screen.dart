import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_finalproject/Views/collection_screen/loading_indicator.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:flutter_finalproject/Views/store_screen/mixandmatch_detail.dart';
import 'package:flutter_finalproject/Views/store_screen/reviews_screen.dart';
import 'package:flutter_finalproject/consts/consts.dart';
import 'package:intl/intl.dart';

class StoreScreen extends StatelessWidget {
  final String vendorId;
  const StoreScreen({super.key, required this.vendorId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchSellerName(vendorId),
      builder: (context, snapshot) {
        String title = snapshot.hasData ? snapshot.data! : 'Loading...';
        return Scaffold(
          backgroundColor: whiteColor,
          appBar: AppBar(
            title: Text(title)
                .text
                .color(blackColor)
                .fontFamily(medium)
                .size(26)
                .make(),
            centerTitle: true,
            // leading: IconButton(
            //   icon: const Icon(Icons.arrow_back_ios),
            //   onPressed: () => Get.back(),
            // ),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            // physics: NeverScrollableScrollPhysics(),
            child: Column(
              // แก้ไขในส่วนนี้
              children: [
                _buildLogoAndRatingSection(context),
                // _buildReviewHighlights(),
                _buildProductMatchTabs(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogoAndRatingSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Column(
        children: <Widget>[
          _buildRatingSection(context),
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
                  child: FutureBuilder<String>(
                    future: fetchSellerImgs(vendorId),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: greyColor, width: 3),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              imProfile,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        return Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: greyColor, width: 3),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              snapshot.data!,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: greyColor, width: 3),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              imProfile,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }
                    },
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
                    ).text.fontFamily(regular).size(14).color(greyDark2).make(),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReviewScreen()),
                        );
                      },
                      child: const Text('All Reviews >>>')
                          .text
                          .fontFamily(regular)
                          .size(14)
                          .color(greyDark2)
                          .make(),
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

  Widget _buildReviewCard() {
    return Container(
      width: 200,
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          const BoxShadow(
            color: greyDark1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Reviewer Name',
              style: TextStyle(fontSize: 16, fontFamily: bold)),
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
    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          TabBar(
            labelStyle: const TextStyle(
                fontSize: 15, fontFamily: regular, color: greyDark2),
            unselectedLabelStyle: const TextStyle(
                fontSize: 14, fontFamily: regular, color: greyDark1),
            tabs: [
              const Tab(text: 'Product'),
              const Tab(text: 'Match'),
            ],
            indicatorColor: Theme.of(context).primaryColor,
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
        /* child: */ _buildCategoryTabs(context),
        // ),
        Expanded(
          child: Container(),
        ),
      ],
    );
  }

  Widget _buildMatchTab(BuildContext context) {
    return Column(
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
      length: 9,
      child: Column(
        children: <Widget>[
          const TabBar(
            isScrollable: true,
            indicatorColor: primaryApp,
            labelStyle:
                TextStyle(fontSize: 13, fontFamily: regular, color: greyDark2),
            unselectedLabelStyle:
                TextStyle(fontSize: 12, fontFamily: regular, color: greyDark1),
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Knitwear'),
              Tab(text: 'Dresses'),
              Tab(text: 'Coat'),
              Tab(text: 'T-shirts'),
              Tab(text: 'Skirts'),
              Tab(text: 'Pants'),
              Tab(text: 'Shorts'),
              Tab(text: 'Shirts'),
            ],
          ).box.color(thinPrimaryApp).make(),
          Container(
            height: 700,
            child: TabBarView(
              children: [
                _buildProductGridAll('All', 'All'),
                _buildProductGridKnitwear('Knitwear', 'Knitwear'),
                _buildProductGridDress('Dresses', 'Dresses'),
                _buildProductGridCoat('Coat', 'Coat'),
                _buildProductGridTshirt('T-shirts', 'T-shirts'),
                _buildProductGridSkirt('Skirts', 'Skirts'),
                _buildProductGridPant('Pants', 'Pants'),
                _buildProductGridShort('Shorts', 'Shorts'),
                _buildProductGridShirt('Shirts', 'Shirts'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGridAll(String category, String subcollection) {
    Query query = FirebaseFirestore.instance
        .collection('products')
        .where('vendor_id', isEqualTo: vendorId);

    // Check if the subcollection is "All"
    if (subcollection != 'All') {
      query = query.where('p_subcollection', isEqualTo: subcollection);
    }

    return FutureBuilder<QuerySnapshot>(
      future: query.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: loadingIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No Items');
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 1 / 1.2),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            var product = snapshot.data!.docs[index];
            String productName = product.get('p_name');
            String price = product.get('p_price');
            String productImage = product.get('p_imgs')[0];

            return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemDetails(
                            title: productName,
                            data: product.data() as Map<String, dynamic>,
                          ),
                        ),
                      );
                    },
                    child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          // color: whiteColor,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(14),
                                topLeft: Radius.circular(14),
                              ),
                              child: Image.network(
                                productImage,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 150,
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 3),
                                    Text(
                                      productName,
                                      style: TextStyle(
                                        fontFamily: 'Medium',
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "${NumberFormat('#,##0').format(double.parse('$price').toInt())} Bath",
                                      style: TextStyle(
                                        color: greyDark1,
                                        fontFamily: 'Regular',
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ) 
                        ))
                .box
                .color(whiteColor)
                .border(color: thinGrey01)
                .margin(EdgeInsets.all(6))
                .rounded
                .make();
          },
        );
      },
    );
  }

  Widget _buildProductGridKnitwear(String category, String subcollection) {
    Query query = FirebaseFirestore.instance
        .collection('products')
        .where('vendor_id', isEqualTo: vendorId);

    // Check if the subcollection is "All"
    if (subcollection != 'All') {
      query = query.where('p_subcollection', isEqualTo: subcollection);
    }

    return FutureBuilder<QuerySnapshot>(
      future: query.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: loadingIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: const Text('No Items'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 1 / 1.1),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            var product = snapshot.data!.docs[index];
            String productName = product.get('p_name');
            String price = product.get('p_price');
            String productImage = product.get('p_imgs')[0];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemDetails(
                      title: productName,
                      data: product.data() as Map<String, dynamic>,
                    ),
                  ),
                );
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.network(
                      productImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          3.heightBox,
                          Text(
                            productName,
                            style: const TextStyle(
                              fontFamily: medium,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${NumberFormat('#,##0').format(double.parse(
                              '$price',
                            ).toInt())} Bath",
                            // "${NumberFormat('#,##0').format(double.parse('$price',).toInt())} Bath",
                            // '$price',
                            style: const TextStyle(
                                color: greyDark1, fontFamily: regular),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).box.color(whiteColor).make(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProductGridDress(String category, String subcollection) {
    Query query = FirebaseFirestore.instance
        .collection('products')
        .where('vendor_id', isEqualTo: vendorId);

    // Check if the subcollection is "All"
    if (subcollection != 'All') {
      query = query.where('p_subcollection', isEqualTo: subcollection);
    }

    return FutureBuilder<QuerySnapshot>(
      future: query.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: loadingIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: const Text('No Items'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 1 / 1.1),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            var product = snapshot.data!.docs[index];
            String productName = product.get('p_name');
            String price = product.get('p_price');
            String productImage = product.get('p_imgs')[0];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemDetails(
                      title: productName,
                      data: product.data() as Map<String, dynamic>,
                    ),
                  ),
                );
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.network(
                      productImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          3.heightBox,
                          Text(
                            productName,
                            style: const TextStyle(
                              fontFamily: medium,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${NumberFormat('#,##0').format(double.parse(
                              '$price',
                            ).toInt())} Bath",
                            // "${NumberFormat('#,##0').format(double.parse('$price',).toInt())} Bath",
                            // '$price',
                            style: const TextStyle(
                                color: greyDark1, fontFamily: regular),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).box.color(whiteColor).make(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProductGridCoat(String category, String subcollection) {
    Query query = FirebaseFirestore.instance
        .collection('products')
        .where('vendor_id', isEqualTo: vendorId);

    // Check if the subcollection is "All"
    if (subcollection != 'All') {
      query = query.where('p_subcollection', isEqualTo: subcollection);
    }

    return FutureBuilder<QuerySnapshot>(
      future: query.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: loadingIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: const Text('No Items'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 1 / 1.1),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            var product = snapshot.data!.docs[index];
            String productName = product.get('p_name');
            String price = product.get('p_price');
            String productImage = product.get('p_imgs')[0];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemDetails(
                      title: productName,
                      data: product.data() as Map<String, dynamic>,
                    ),
                  ),
                );
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.network(
                      productImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          3.heightBox,
                          Text(
                            productName,
                            style: const TextStyle(
                              fontFamily: medium,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${NumberFormat('#,##0').format(double.parse(
                              '$price',
                            ).toInt())} Bath",
                            // "${NumberFormat('#,##0').format(double.parse('$price',).toInt())} Bath",
                            // '$price',
                            style: const TextStyle(
                                color: greyDark1, fontFamily: regular),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).box.color(whiteColor).make(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProductGridTshirt(String category, String subcollection) {
    Query query = FirebaseFirestore.instance
        .collection('products')
        .where('vendor_id', isEqualTo: vendorId);

    // Check if the subcollection is "All"
    if (subcollection != 'All') {
      query = query.where('p_subcollection', isEqualTo: subcollection);
    }

    return FutureBuilder<QuerySnapshot>(
      future: query.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: loadingIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: const Text('No Items'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 1 / 1.1),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            var product = snapshot.data!.docs[index];
            String productName = product.get('p_name');
            String price = product.get('p_price');
            String productImage = product.get('p_imgs')[0];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemDetails(
                      title: productName,
                      data: product.data() as Map<String, dynamic>,
                    ),
                  ),
                );
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.network(
                      productImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          3.heightBox,
                          Text(
                            productName,
                            style: const TextStyle(
                              fontFamily: medium,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${NumberFormat('#,##0').format(double.parse(
                              '$price',
                            ).toInt())} Bath",
                            // "${NumberFormat('#,##0').format(double.parse('$price',).toInt())} Bath",
                            // '$price',
                            style: const TextStyle(
                                color: greyDark1, fontFamily: regular),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).box.color(whiteColor).make(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProductGridShirt(String category, String subcollection) {
    Query query = FirebaseFirestore.instance
        .collection('products')
        .where('vendor_id', isEqualTo: vendorId);

    // Check if the subcollection is "All"
    if (subcollection != 'All') {
      query = query.where('p_subcollection', isEqualTo: subcollection);
    }

    return FutureBuilder<QuerySnapshot>(
      future: query.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: loadingIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: const Text('No Items'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 1 / 1.1),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            var product = snapshot.data!.docs[index];
            String productName = product.get('p_name');
            String price = product.get('p_price');
            String productImage = product.get('p_imgs')[0];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemDetails(
                      title: productName,
                      data: product.data() as Map<String, dynamic>,
                    ),
                  ),
                );
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.network(
                      productImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          3.heightBox,
                          Text(
                            productName,
                            style: const TextStyle(
                              fontFamily: medium,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${NumberFormat('#,##0').format(double.parse(
                              '$price',
                            ).toInt())} Bath",
                            // "${NumberFormat('#,##0').format(double.parse('$price',).toInt())} Bath",
                            // '$price',
                            style: const TextStyle(
                                color: greyDark1, fontFamily: regular),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).box.color(whiteColor).make(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryMath(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: TabBarView(
              children: [
                _buildProductMathGrids('All'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGridShort(String category, String subcollection) {
    Query query = FirebaseFirestore.instance
        .collection('products')
        .where('vendor_id', isEqualTo: vendorId);

    // Check if the subcollection is "All"
    if (subcollection != 'All') {
      query = query.where('p_subcollection', isEqualTo: subcollection);
    }

    return FutureBuilder<QuerySnapshot>(
      future: query.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: loadingIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: const Text('No Items'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 1 / 1.1),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            var product = snapshot.data!.docs[index];
            String productName = product.get('p_name');
            String price = product.get('p_price');
            String productImage = product.get('p_imgs')[0];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemDetails(
                      title: productName,
                      data: product.data() as Map<String, dynamic>,
                    ),
                  ),
                );
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.network(
                      productImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          3.heightBox,
                          Text(
                            productName,
                            style: const TextStyle(
                              fontFamily: medium,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${NumberFormat('#,##0').format(double.parse(
                              '$price',
                            ).toInt())} Bath",
                            // "${NumberFormat('#,##0').format(double.parse('$price',).toInt())} Bath",
                            // '$price',
                            style: const TextStyle(
                                color: greyDark1, fontFamily: regular),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).box.color(whiteColor).make(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProductGridPant(String category, String subcollection) {
    Query query = FirebaseFirestore.instance
        .collection('products')
        .where('vendor_id', isEqualTo: vendorId);

    // Check if the subcollection is "All"
    if (subcollection != 'All') {
      query = query.where('p_subcollection', isEqualTo: subcollection);
    }

    return FutureBuilder<QuerySnapshot>(
      future: query.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: loadingIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: const Text('No Items'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 1 / 1.1),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            var product = snapshot.data!.docs[index];
            String productName = product.get('p_name');
            String price = product.get('p_price');
            String productImage = product.get('p_imgs')[0];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemDetails(
                      title: productName,
                      data: product.data() as Map<String, dynamic>,
                    ),
                  ),
                );
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.network(
                      productImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          3.heightBox,
                          Text(
                            productName,
                            style: const TextStyle(
                              fontFamily: medium,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${NumberFormat('#,##0').format(double.parse(
                              '$price',
                            ).toInt())} Bath",
                            // "${NumberFormat('#,##0').format(double.parse('$price',).toInt())} Bath",
                            // '$price',
                            style: const TextStyle(
                                color: greyDark1, fontFamily: regular),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).box.color(whiteColor).make(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProductGridSkirt(String category, String subcollection) {
    Query query = FirebaseFirestore.instance
        .collection('products')
        .where('vendor_id', isEqualTo: vendorId);

    // Check if the subcollection is "All"
    if (subcollection != 'All') {
      query = query.where('p_subcollection', isEqualTo: subcollection);
    }

    return FutureBuilder<QuerySnapshot>(
      future: query.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: loadingIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: const Text('No Items'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 1 / 1.1),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            var product = snapshot.data!.docs[index];
            String productName = product.get('p_name');
            String price = product.get('p_price');
            String productImage = product.get('p_imgs')[0];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemDetails(
                      title: productName,
                      data: product.data() as Map<String, dynamic>,
                    ),
                  ),
                );
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.network(
                      productImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          3.heightBox,
                          Text(
                            productName,
                            style: const TextStyle(
                              fontFamily: medium,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${NumberFormat('#,##0').format(double.parse(
                              '$price',
                            ).toInt())} Bath",
                            // "${NumberFormat('#,##0').format(double.parse('$price',).toInt())} Bath",
                            // '$price',
                            style: const TextStyle(
                                color: greyDark1, fontFamily: regular),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).box.color(whiteColor).make(),
              ),
            );
          },
        );
      },
    );
  }
  // Widget _buildProductMathGrids(String category) {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: FirebaseFirestore.instance.collection('products').snapshots(),
  //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //       if (!snapshot.hasData) {
  //         return Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       }

  Widget _buildProductMathGrids(String category) {
    Query query = FirebaseFirestore.instance
        .collection('products')
        .where('vendor_id')
        .where('p_mixmatch');

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // Initialize a map to group products by their 'p_mixmatch' value
        Map<String, List<DocumentSnapshot>> mixMatchMap = {};

        // Populate the map
        for (var doc in snapshot.data!.docs) {
          var data = doc.data() as Map<String, dynamic>;
          // เพิ่มเงื่อนไขเช็ค vendor.id ตรงนี้
          if (data['vendor_id'] == vendorId && data['p_mixmatch'] != null) {
            String mixMatchKey = data['p_mixmatch'];
            if (!mixMatchMap.containsKey(mixMatchKey)) {
              mixMatchMap[mixMatchKey] = [];
            }
            mixMatchMap[mixMatchKey]!.add(doc);
          }
        }

        // Filter out any 'p_mixmatch' groups that do not have exactly 2 products
        var validPairs = mixMatchMap.entries
            .where((entry) => entry.value.length == 2)
            .toList();

        // Calculate the total number of valid pairs to display
        int itemCount = validPairs.length;

        return GridView.builder(
          padding: const EdgeInsets.all(2),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1 / 2,
          ),
          itemCount: itemCount,
          itemBuilder: (BuildContext context, int index) {
            // Each pair of matched products
            var pair = validPairs[index].value;

            // Assuming the data structure ensures there are exactly 2 products per matched 'p_mixmatch'
            var data1 = pair[0].data() as Map<String, dynamic>;
            var data2 = pair[1].data() as Map<String, dynamic>;

            String price1 = data1['p_price'].toString();
            String price2 = data2['p_price'].toString();
            String totalPrice =
                (int.parse(price1) + int.parse(price2)).toString();

            String productName1 = data1['p_name'];
            String productName2 = data2['p_name'];

            String productImage1 = data1['p_imgs'][0];
            String productImage2 = data2['p_imgs'][0];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MatchDetailScreen(
                      price1: price1,
                      price2: price2,
                      productName1: productName1,
                      productName2: productName2,
                      productImage1: productImage1,
                      productImage2: productImage2,
                      totalPrice: totalPrice,
                    ),
                  ),
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
                                const SizedBox(height: 2),
                                Text(
                                  productName1,
                                  style: const TextStyle(fontFamily: bold),
                                ),
                                Text(
                                  'Price: \$${price1.toString()}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  productName2,
                                  style: const TextStyle(fontFamily: bold),
                                ),
                                Text(
                                  'Price: \$${price2.toString()}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Total Price: \$${totalPrice.toString()}',
                        style: const TextStyle(
                          color: blackColor,
                          fontFamily: bold,
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

  Future<String> fetchSellerName(String vendorId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('vendor_id', isEqualTo: vendorId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      return data['p_seller'] ?? 'Unknown Seller';
    } else {
      return 'Unknown Seller';
    }
  }

  Future<String> fetchSellerImgs(String vendorId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('vendors')
          .where('vendor_id', isEqualTo: vendorId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> data =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        return data['imageUrl'] ?? 'Error product image';
      } else {
        return 'Error product image';
      }
    } catch (e) {
      print('An error occurred fetching data: $e');
      return 'Error product image';
    }
  }
}
