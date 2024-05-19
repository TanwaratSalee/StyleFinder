import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_finalproject/Views/store_screen/item_details.dart';
import 'package:flutter_finalproject/consts/consts.dart';

class CollectionProductTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 12, // Number of categories
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: primaryApp,
            labelStyle: TextStyle(fontSize: 13, fontFamily: regular, color: greyDark2),
            unselectedLabelStyle: TextStyle(fontSize: 12, fontFamily: regular, color: greyDark1),
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Dresses'),
              Tab(text: 'Outerwear & Coats'),
              Tab(text: 'Blazers'),
              Tab(text: 'Suits'),
              Tab(text: 'Blouses & Tops'),
              Tab(text: 'Knitwear'),
              Tab(text: 'T-shirts'),
              Tab(text: 'Skirts'),
              Tab(text: 'Pants'),
              Tab(text: 'Denim'),
              Tab(text: 'Activewear'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildProductGridAll(context),
            _buildProductGridCategory('Dresses'),
            _buildProductGridCategory('Outerwear & Coats'),
            _buildProductGridCategory('Blazers'),
            _buildProductGridCategory('Suits'),
            _buildProductGridCategory('Blouses & Tops'),
            _buildProductGridCategory('Knitwear'),
            _buildProductGridCategory('T-shirts'),
            _buildProductGridCategory('Skirts'),
            _buildProductGridCategory('Pants'),
            _buildProductGridCategory('Denim'),
            _buildProductGridCategory('Activewear'),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGridAll(BuildContext context) {
    CollectionReference productsCollection = FirebaseFirestore.instance.collection('products');
    return FutureBuilder<QuerySnapshot>(
      future: productsCollection.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No Items');
        }
        List<QueryDocumentSnapshot> allProducts = snapshot.data!.docs;
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1 / 1.35),
          itemCount: allProducts.length,
          itemBuilder: (context, index) {
            var product = allProducts[index].data() as Map<String, dynamic>;
            String productName = product['p_name'];
            String price = product['p_price'];
            String productImage = product['p_imgs'][0];
            return _buildProductTile(context, productName, price, productImage, product);
          },
        );
      },
    );
  }

  Widget _buildProductGridCategory(String category) {
    Query query = FirebaseFirestore.instance.collection('products').where('category', isEqualTo: category);
    return FutureBuilder<QuerySnapshot>(
      future: query.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: const Text('No Items'));
        }
        List<QueryDocumentSnapshot> products = snapshot.data!.docs;
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1 / 1.35),
          itemCount: products.length,
          itemBuilder: (context, index) {
            var product = products[index].data() as Map<String, dynamic>;
            String productName = product['p_name'];
            String price = product['p_price'];
            String productImage = product['p_imgs'][0];
            return _buildProductTile(context, productName, price, productImage, product);
          },
        );
      },
    );
  }

  Widget _buildProductTile(BuildContext context, String productName, String price, String productImage, Map<String, dynamic> productData) {
  // Check if the productImage URL is valid
  if (productImage == null || productImage.isEmpty) {
    productImage = 'https://via.placeholder.com/150';  // Placeholder image URL
  }

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemDetails(
            title: productName,
            data: productData,
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
            height: 190,
            errorBuilder: (context, error, stackTrace) => Image.network(
              'https://via.placeholder.com/150',  // Fallback image in case of error
              fit: BoxFit.cover,
              width: double.infinity,
              height: 190,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                  "${NumberFormat('#,##0').format(double.parse(price).toInt())} Bath",
                  style: const TextStyle(
                    color: greyColor,
                    fontFamily: regular,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}
